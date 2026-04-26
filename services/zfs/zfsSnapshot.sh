#!/bin/bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $(basename "$0") <title>" >&2
    exit 1
fi

TITLE="$1"
DATE=$(date +%Y-%m-%d)
SNAP_NAME="${DATE}-${TITLE}"

zpool list -H -o name | while read -r pool; do
    zfs snapshot -r "${pool}@${SNAP_NAME}"
    echo "Snapshotted ${pool}@${SNAP_NAME}"
done
