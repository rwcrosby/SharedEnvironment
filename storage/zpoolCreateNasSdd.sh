#/bin/bash

POOLNAME=${1:-naspool0}
DEVICES=${@:-"/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_sdd1"}

printf "pool: <%s>\n" $POOLNAME
printf "dev:  <%s>\n" $DEVICES

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
    ${DEVICES}
