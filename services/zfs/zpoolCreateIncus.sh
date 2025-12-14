#!/bin/bash

POOLNAME=${1:-incus1}
DEVICES=${@:-"/dev/disk/by-id/ata-WD_Blue_SA510_2.5_4TB_253221D00108-part5"}
DEVICES=($DEVICES)

printf "pool: <%s>\n" $POOLNAME
echo "dev2:  ${DEVICES[@]}"

zpool create -f \
    -O encryption=on \
    -O keyformat=hex \
    -O keylocation=file:///etc/zfs/incus-key.txt \
    $POOLNAME \
    "${DEVICES}"
