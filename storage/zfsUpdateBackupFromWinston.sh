#!/usr/bin/env bash
#
# zfsUpdateBackupFromWinston.sh
#
# Pull the latest snapshots from winston (naspool1/nas_hdd) down to a backup
# zpool attached to THIS host (macOS, OpenZFS at /usr/local/zfs/bin).
#
# This is a *pull* — it runs on the Mac, opens an ssh to winston, and pipes
# `zfs send` into a local `zfs recv`. It does NOT create new snapshots: winston
# runs sanoid every 15 minutes, so the job here is only to bring the backup
# forward to whatever the newest snapshot on winston already is.
#
# Conventions enforced (see Nas-Winston/CLAUDE.md):
#   * Raw sends only (`zfs send -w`). The existing chain was started raw, and
#     raw/non-raw sends cannot be mixed for the same incremental history.
#     Raw also means the backup never needs the encryption key loaded.
#   * No `-R` / `-p`. Those carry the *sender's* mountpoint/keylocation/canmount
#     into the stream, which is what silently broke auto-mount on winston after
#     the 2026-08 restore. Plain `-w` sends data only, leaving local props alone.
#   * The incremental base is chosen from what the TARGET already has, then
#     verified on the source by GUID before anything is sent.
#
# LIMITATION - only works for datasets that are their own encryption root.
#   winston's naspool1/nas_hdd/{Home,Users} each are, so per-dataset raw
#   incrementals work. zorro's zorro/* and incus1/* inherit encryption from the
#   POOL ROOT, and OpenZFS rejects per-dataset raw incrementals for those with
#   "cannot receive incremental stream: IV set guid mismatch" (confirmed
#   2026-09-07 on all 23 datasets; a rollback to the common base does NOT help).
#   Those pools must be replicated recursively from the encryption root:
#     zfs send -R -w -I @<common-base> <pool>@<snap> | zfs recv -F -u <target>
#   See the vault note "HowTo - Backup NAS to USB Drive" for the full procedure.
#
set -euo pipefail

export PATH="/usr/local/zfs/bin:$PATH"

# ---------------------------------------------------------------- defaults ---
REMOTE="winston"
SRC_PARENT="naspool1/nas_hdd"
DEST_POOL="Backup4T"
DEST_PARENT=""                       # defaults to <DEST_POOL>/nas_hdd
DATASETS_DEFAULT="Home Users"        # TimeMachine has no backup dataset
DATASETS=""
DRY_RUN=0
LIST_ONLY=0
LATEST_ONLY=0                        # 0 => send -I (keep intermediates)
NO_EXPORT=0
ALLOW_FULL=0
SEARCH_DIR=""

WE_IMPORTED=0

usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Updates a locally-attached backup pool with the latest snapshots from winston.

Options:
  -n, --dry-run        Show what would run; send/recv nothing. Implies no writes.
  -l, --list           Report source/target snapshot state and exit (read-only).
  -d, --dataset NAME   Dataset under ${SRC_PARENT} to sync (repeatable).
                       Use "." for the parent dataset itself (a pool root).
                       Default: ${DATASETS_DEFAULT}
  -p, --pool NAME      Destination pool name. Default: ${DEST_POOL}
      --dest-parent DS Destination parent dataset. Default: <pool>/nas_hdd
      --src-parent DS  Source parent dataset. Default: ${SRC_PARENT}
      --search-dir DIR Extra directory to scan for pool devices (passed to
                       'zpool import -d'). Normally unnecessary for USB disks.
      --remote HOST    ssh target for the source host. Default: ${REMOTE}
      --latest-only    Use 'send -i' (endpoint only) instead of 'send -I'
                       (which also replicates intermediate snapshots).
      --allow-full     Permit an initial full send when the target dataset is
                       missing. Off by default — a full send here is ~1.9T.
      --no-export      Leave the pool imported when finished.
  -h, --help           This text.

Examples:
  $(basename "$0") --list                 # what would sync, without touching it
  $(basename "$0") --dry-run              # print the exact send/recv pipelines
  $(basename "$0")                        # sync Home + Users, then export
  $(basename "$0") -d Home --no-export    # just Home, leave pool imported
EOF
    exit "${1:-1}"
}

log()  { printf '%s\n' "$*"; }
info() { printf '  %s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

# ------------------------------------------------------------------- args ----
while [ $# -gt 0 ]; do
    case "$1" in
        -n|--dry-run)   DRY_RUN=1 ;;
        -l|--list)      LIST_ONLY=1 ;;
        -d|--dataset)   [ $# -ge 2 ] || die "--dataset needs a value"
                        DATASETS="${DATASETS} $2"; shift ;;
        -p|--pool)      [ $# -ge 2 ] || die "--pool needs a value"
                        DEST_POOL="$2"; shift ;;
        --dest-parent)  [ $# -ge 2 ] || die "--dest-parent needs a value"
                        DEST_PARENT="$2"; shift ;;
        --src-parent)   [ $# -ge 2 ] || die "--src-parent needs a value"
                        SRC_PARENT="$2"; shift ;;
        --search-dir)   [ $# -ge 2 ] || die "--search-dir needs a value"
                        SEARCH_DIR="$2"; shift ;;
        --remote)       [ $# -ge 2 ] || die "--remote needs a value"
                        REMOTE="$2"; shift ;;
        --latest-only)  LATEST_ONLY=1 ;;
        --allow-full)   ALLOW_FULL=1 ;;
        --no-export)    NO_EXPORT=1 ;;
        -h|--help)      usage 0 ;;
        *)              die "unknown option: $1 (try --help)" ;;
    esac
    shift
done

[ -n "$DATASETS" ]    || DATASETS="$DATASETS_DEFAULT"
[ -n "$DEST_PARENT" ] || DEST_PARENT="${DEST_POOL}/nas_hdd"

command -v zfs   >/dev/null 2>&1 || die "zfs not found (expected /usr/local/zfs/bin)"
command -v zpool >/dev/null 2>&1 || die "zpool not found (expected /usr/local/zfs/bin)"

# --------------------------------------------------------------- helpers ----
# Local zfs/zpool need root; ssh to winston uses passwordless sudo.
zfs_l()   { sudo zfs   "$@"; }
zpool_l() { sudo zpool "$@"; }
zfs_r()   { ssh -o BatchMode=yes "$REMOTE" "sudo -n zfs $*"; }

# Newest snapshot of a dataset, short name only (no leading '@'). Empty if none.
latest_snap_local() {
    zfs_l list -H -t snapshot -o name -s creation -d 1 "$1" 2>/dev/null \
        | tail -1 | cut -d@ -f2
}
latest_snap_remote() {
    zfs_r list -H -t snapshot -o name -s creation -d 1 "$1" 2>/dev/null \
        | tail -1 | cut -d@ -f2
}
# Newest snapshot present on BOTH sides, walking the target's snapshots
# newest-first. Using the target's newest alone is wrong when the source runs
# sanoid: pruning removes the old _hourly/_daily while keeping the _monthly
# taken at the same instant, so the newest common snapshot is often a few
# entries back. Prints the short name; returns 1 if there is no common snapshot.
pick_base() {
    local dest="$1" src="$2" snap srcsnaps
    srcsnaps="$(zfs_r list -H -t snapshot -o name -d 1 "$src" 2>/dev/null | sed 's/.*@//')"
    [ -n "$srcsnaps" ] || return 1
    while IFS= read -r snap; do
        [ -n "$snap" ] || continue
        if printf '%s\n' "$srcsnaps" | grep -qxF "$snap"; then
            printf '%s\n' "$snap"; return 0
        fi
    done < <(zfs_l list -H -t snapshot -o name -s creation -d 1 "$dest" 2>/dev/null \
                | sed 's/.*@//' \
                | awk '{a[NR]=$0} END{for(i=NR;i>=1;i--) print a[i]}')
    return 1
}

guid_local()  { zfs_l get -H -o value guid "$1" 2>/dev/null || true; }
guid_remote() { zfs_r get -H -o value guid "$1" 2>/dev/null || true; }

exists_local()  { zfs_l list -H -o name "$1" >/dev/null 2>&1; }
exists_remote() { zfs_r list -H -o name "$1" >/dev/null 2>&1; }

pool_imported() { zpool_l list -H -o name 2>/dev/null | grep -qx "$DEST_POOL"; }

cleanup() {
    local rc=$?
    if [ "$WE_IMPORTED" -eq 1 ] && [ "$NO_EXPORT" -eq 0 ]; then
        log ""
        log "Exporting ${DEST_POOL} ..."
        if zpool_l export "$DEST_POOL" 2>/dev/null; then
            info "exported — safe to unplug"
        else
            warn "could not export ${DEST_POOL}; do NOT unplug until 'sudo zpool export ${DEST_POOL}' succeeds"
        fi
    fi
    exit "$rc"
}

# ------------------------------------------------------------ preflight -----
log "Source : ${REMOTE}:${SRC_PARENT}"
log "Target : ${DEST_PARENT}  (pool ${DEST_POOL})"
log "Mode   : raw incremental ($([ "$LATEST_ONLY" -eq 1 ] && echo 'send -i, endpoint only' || echo 'send -I, keeps intermediates'))"
log ""

ssh -o BatchMode=yes -o ConnectTimeout=10 "$REMOTE" true 2>/dev/null \
    || die "cannot ssh to '${REMOTE}' non-interactively"

# Import the pool if it isn't already. Only export what we imported.
if pool_imported; then
    log "Pool ${DEST_POOL} already imported."
    trap cleanup EXIT INT TERM
else
    if [ -n "$SEARCH_DIR" ]; then IMPORT_D="-d $SEARCH_DIR"; else IMPORT_D=""; fi
    # shellcheck disable=SC2086  # IMPORT_D is an intentional word-split flag pair
    if ! zpool_l import $IMPORT_D 2>/dev/null | grep -q "pool: ${DEST_POOL}\b"; then
        die "pool '${DEST_POOL}' is neither imported nor available to import — is the backup drive plugged in?"
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
        log "[DRY RUN] would import pool ${DEST_POOL}"
        log ""
        log "Pool is not imported, so per-dataset state cannot be read. Re-run"
        log "with the drive attached, or without --dry-run, for the real plan."
        exit 0
    fi
    log "Importing ${DEST_POOL} ..."
    # Deliberately no -f: force-importing a pool that is live elsewhere can
    # corrupt it (CLAUDE.md safety rule).
    # shellcheck disable=SC2086
    zpool_l import $IMPORT_D "$DEST_POOL" || die "import of ${DEST_POOL} failed"
    WE_IMPORTED=1
    trap cleanup EXIT INT TERM
    info "imported"
fi
log ""

# --------------------------------------------------------------- per-ds -----
synced=0; skipped=0; failed=0

for ds in $DATASETS; do
    # "." means the parent dataset itself (e.g. the incus1 pool root).
    if [ "$ds" = "." ]; then
        src="${SRC_PARENT}"
        dest="${DEST_PARENT}"
    else
        src="${SRC_PARENT}/${ds}"
        dest="${DEST_PARENT}/${ds}"
    fi
    log "=== ${ds} ==="

    if ! exists_remote "$src"; then
        warn "source ${src} does not exist — skipping"
        failed=$((failed + 1)); log ""; continue
    fi

    newest="$(latest_snap_remote "$src")"
    if [ -z "$newest" ]; then
        warn "source ${src} has no snapshots — skipping"
        failed=$((failed + 1)); log ""; continue
    fi
    info "source newest : @${newest}"

    # ---- target missing: full send is a big deal, so it is opt-in ----------
    if ! exists_local "$dest"; then
        info "target        : MISSING (${dest})"
        if [ "$ALLOW_FULL" -ne 1 ]; then
            warn "no target dataset and --allow-full not given — skipping ${ds}"
            warn "  a full raw send of ${src} would transfer the entire dataset"
            failed=$((failed + 1)); log ""; continue
        fi
        if [ "$LIST_ONLY" -eq 1 ]; then
            info "action        : would do an INITIAL FULL raw send"
            log ""; continue
        fi
        cmd="ssh ${REMOTE} sudo -n zfs send -w -v ${src}@${newest} | sudo zfs recv -F -u ${dest}"
        if [ "$DRY_RUN" -eq 1 ]; then
            info "[DRY RUN] $cmd"; log ""; continue
        fi
        # `zfs recv` will not create missing intermediate datasets, so make the
        # parent first. canmount=off/mountpoint=none matches how Backup4T's
        # container datasets are configured.
        parent="${dest%/*}"
        if [ "$parent" != "$dest" ] && ! exists_local "$parent"; then
            info "creating parent ${parent}"
            zfs_l create -p -o canmount=off -o mountpoint=none "$parent" \
                || { warn "could not create parent ${parent}"; failed=$((failed + 1)); log ""; continue; }
        fi

        log "  full raw send -> ${dest}"
        if ssh -o BatchMode=yes "$REMOTE" "sudo -n zfs send -w -v ${src}@${newest}" \
             | zfs_l recv -F -u "$dest"; then
            info "done"; synced=$((synced + 1))
        else
            warn "full send of ${ds} FAILED"; failed=$((failed + 1))
        fi
        log ""; continue
    fi

    # ---- incremental: newest snapshot common to both sides ----------------
    tgt_newest="$(latest_snap_local "$dest")"
    if [ -z "$tgt_newest" ]; then
        warn "target ${dest} exists but has no snapshots — cannot pick an incremental base"
        warn "  resolve manually (it may need a full send with --allow-full)"
        failed=$((failed + 1)); log ""; continue
    fi
    info "target newest : @${tgt_newest}"

    if ! base="$(pick_base "$dest" "$src")" || [ -z "$base" ]; then
        warn "no snapshot common to ${dest} and ${src}"
        warn "  the incremental chain is broken (sanoid may have pruned the base)."
        warn "  Recovering means a new full send — inspect before acting:"
        warn "    ssh ${REMOTE} sudo zfs list -t snapshot -d1 ${src}"
        failed=$((failed + 1)); log ""; continue
    fi
    if [ "$base" != "$tgt_newest" ]; then
        info "common base   : @${base}  (target snapshots after it were pruned"
        info "                on the source; 'recv -F' will roll them back)"
    fi

    # naspool1 was rebuilt from scratch in 2026-07 and restored *from* this
    # backup, so names alone can't prove the two chains are the same lineage.
    # GUIDs can. Without this check a name-only match could aim `recv -F` at an
    # unrelated history and roll the backup back over good data.
    g_src="$(guid_remote "${src}@${base}")"
    g_dst="$(guid_local  "${dest}@${base}")"
    if [ -n "$g_src" ] && [ -n "$g_dst" ] && [ "$g_src" != "$g_dst" ]; then
        warn "GUID mismatch on @${base} (source ${g_src} vs target ${g_dst})"
        warn "  same name, different lineage — refusing to send. Investigate manually."
        failed=$((failed + 1)); log ""; continue
    fi

    # Checked only after the base is confirmed to be shared lineage — a name
    # match alone would otherwise report "up to date" for an unrelated chain.
    if [ "$base" = "$newest" ] && [ "$tgt_newest" = "$newest" ]; then
        info "action        : up to date, nothing to send"
        skipped=$((skipped + 1)); log ""; continue
    fi

    if [ "$LATEST_ONLY" -eq 1 ]; then inc="-i"; else inc="-I"; fi
    send_cmd="sudo -n zfs send -w -v ${inc} @${base} ${src}@${newest}"
    pipeline="ssh ${REMOTE} ${send_cmd} | sudo zfs recv -F -u ${dest}"

    if [ "$LIST_ONLY" -eq 1 ]; then
        info "action        : would send @${base} -> @${newest}"
        log ""; continue
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
        info "[DRY RUN] $pipeline"; log ""; continue
    fi

    log "  sending @${base} -> @${newest}"
    # -u so the received dataset is not mounted here; this is a backup target,
    # and its macOS mountpoints are managed separately.
    if ssh -o BatchMode=yes "$REMOTE" "$send_cmd" | zfs_l recv -F -u "$dest"; then
        info "done"; synced=$((synced + 1))
    else
        warn "send of ${ds} FAILED"; failed=$((failed + 1))
    fi
    log ""
done

# -------------------------------------------------------------- summary -----
log "----------------------------------------"
log "synced: ${synced}   up-to-date: ${skipped}   problems: ${failed}"

if [ "$LIST_ONLY" -eq 0 ] && [ "$DRY_RUN" -eq 0 ] && [ "$synced" -gt 0 ]; then
    log ""
    log "Target snapshots now:"
    zfs_l list -t snapshot -o name,creation -s creation -r "$DEST_PARENT" 2>/dev/null | tail -12
fi

[ "$failed" -eq 0 ] || exit 1
