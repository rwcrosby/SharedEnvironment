#/bin/bash

POOLNAME=${1:-zorro}
DEVICES=${@:-"/dev/disk/by-id/ata-WD_Blue_SA510_2.5_4TB_253221D00108-part4"}

printf "pool: <%s>\n" $POOLNAME
printf "dev:  <%s>\n" $DEVICES

zpool create -f \
    -o ashift=12 \
    -o autotrim=on \
    -O normalization=formD \
    -O atime=off \
    -O acltype=posixacl \
    -O xattr=sa \
    -O dnodesize=auto \
    -O relatime=on \
    -O compression=lz4 \
    -O mountpoint=none \
    -O canmount=off \
    -O mountpoint=/ \
    -R /mnt \
    -O encryption=on \
    -O keyformat=passphrase \
    -O keylocation=prompt \
    $POOLNAME \
    ${DEVICES}
