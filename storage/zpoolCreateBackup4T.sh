#!/bin/bash

POOLNAME=${1:-Backup4T}
DEVICES=${@:-"/dev/disk6"}
DEVICES=($DEVICES)

printf "pool: <%s>\n" $POOLNAME
echo "dev2:  ${DEVICES[@]}"

zpool create -f \
    -o ashift=12 \
    -O normalization=formD \
    -O atime=off \
    -O acltype=posixacl \
    -O xattr=sa \
    -O relatime=on \
    -O compression=lz4 \
    -O mountpoint=none \
    -O canmount=off \
    -O encryption=on \
    -O keyformat=hex \
    -O keylocation=prompt \
    $POOLNAME \
    "${DEVICES[@]}"
