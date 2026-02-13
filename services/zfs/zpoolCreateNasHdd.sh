#!/bin/bash

POOLNAME=${1:-naspool1}
DEVICES=${@:-"/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_nashdd*"}
DEVICES=($DEVICES)

printf "pool: <%s>\n" $POOLNAME
echo "dev2:  ${DEVICES[@]}"

zpool create -f \
    -o ashift=12 \
    -o autotrim=on \
    -O normalization=formD \
    -O atime=off \
    -O acltype=posixacl \
    -O xattr=sa \
    -O relatime=on \
    -O compression=lz4 \
    -O mountpoint=none \
    -O canmount=off \
    -O encryption=on \
    -O keyformat=raw \
    -O keylocation=file:///etc/nas-key.txt \
    $POOLNAME \
    raidz1 \
    "${DEVICES[@]}"
