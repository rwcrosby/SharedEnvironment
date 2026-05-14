#!/bin/bash

# Copy dataset hierarchy from one pool to another, recreating local properties.
# Does not copy data — only structure and attributes.

set -euo pipefail

usage() {
    cat >&2 <<EOF
Usage: $(basename "$0") [-n] [-p prop=value] ... <source_pool> <dest_pool>

  -n            Dry run — print commands without executing
  -p prop=val   Override or add a property on all destination datasets
                (can be specified multiple times)

Examples:
  $(basename "$0") naspool0 backup4t
  $(basename "$0") -n -p mountpoint=none -p canmount=off naspool0 backup4t
EOF
    exit 1
}

DRY_RUN=false
declare -A PROP_OVERRIDES

while getopts ":np:" opt; do
    case $opt in
        n) DRY_RUN=true ;;
        p)
            key="${OPTARG%%=*}"
            val="${OPTARG#*=}"
            PROP_OVERRIDES["$key"]="$val"
            ;;
        :) echo "Option -$OPTARG requires an argument." >&2; usage ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

[[ $# -ne 2 ]] && usage

SRC_POOL="$1"
DST_POOL="$2"

# Verify source pool exists
if ! zpool list -H -o name "$SRC_POOL" &>/dev/null; then
    echo "Error: source pool '$SRC_POOL' not found." >&2
    exit 1
fi

run() {
    if $DRY_RUN; then
        echo "[DRY RUN]" "$@"
    else
        echo "+" "$@"
        "$@"
    fi
}

# Properties that are read-only or meaningless to copy
SKIP_PROPS=(
    type creation used available referenced compressratio mounted
    guid createtxg objsetid unique inconsistent logicalused logicalreferenced
    refcompressratio written clones defer_clones userrefs objsetid
    receive_resume_token inconsistent filesystem_count snapshot_count
    special_small_blocks volblocksize  # volblocksize must be set at creation for zvols
)

is_skip_prop() {
    local prop="$1"
    for skip in "${SKIP_PROPS[@]}"; do
        [[ "$prop" == "$skip" ]] && return 0
    done
    return 1
}

# Get locally-set properties for a dataset as "-o key=value" args
local_prop_args() {
    local dataset="$1"
    local -n _out="$2"
    _out=()

    while IFS=$'\t' read -r prop value source; do
        [[ "$source" != "local" ]] && continue
        is_skip_prop "$prop" && continue

        # Apply override if present
        if [[ -v PROP_OVERRIDES["$prop"] ]]; then
            value="${PROP_OVERRIDES[$prop]}"
        fi

        _out+=( "-o" "${prop}=${value}" )
    done < <(zfs get -H -o property,value,source all "$dataset")

    # Add any overrides not already present in source
    for key in "${!PROP_OVERRIDES[@]}"; do
        local already=false
        for arg in "${_out[@]}"; do
            [[ "$arg" == "${key}="* ]] && already=true && break
        done
        $already || _out+=( "-o" "${key}=${PROP_OVERRIDES[$key]}" )
    done
}

# List datasets in source pool, parents before children
mapfile -t DATASETS < <(zfs list -H -o name -r -t filesystem,volume "$SRC_POOL" | sort)

if [[ ${#DATASETS[@]} -eq 0 ]]; then
    echo "No datasets found in pool '$SRC_POOL'." >&2
    exit 1
fi

echo "Copying structure: $SRC_POOL → $DST_POOL"
echo "Datasets to process: ${#DATASETS[@]}"
$DRY_RUN && echo "(dry run)"
echo ""

for src_ds in "${DATASETS[@]}"; do
    # Replace source pool prefix with destination pool prefix
    dst_ds="${DST_POOL}${src_ds#$SRC_POOL}"

    ds_type=$(zfs get -H -o value type "$src_ds")

    # Check if destination already exists
    if zfs list -H -o name "$dst_ds" &>/dev/null; then
        echo "Exists — updating properties: $dst_ds"
        declare -a prop_args
        local_prop_args "$src_ds" prop_args
        if [[ ${#prop_args[@]} -gt 0 ]]; then
            # zfs set accepts one property at a time
            i=0
            while [[ $i -lt ${#prop_args[@]} ]]; do
                # prop_args pairs are: "-o" "key=val" — extract just "key=val"
                run zfs set "${prop_args[$((i+1))]}" "$dst_ds"
                i=$((i + 2))
            done
        fi
    else
        echo "Creating ($ds_type): $dst_ds"
        declare -a prop_args
        local_prop_args "$src_ds" prop_args

        if [[ "$ds_type" == "volume" ]]; then
            volsize=$(zfs get -H -o value volsize "$src_ds")
            run zfs create "${prop_args[@]}" -V "$volsize" "$dst_ds"
        else
            run zfs create "${prop_args[@]}" "$dst_ds"
        fi
    fi
done

echo ""
echo "Done."
