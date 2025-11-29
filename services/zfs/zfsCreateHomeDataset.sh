#!/bin/bash

POOLNAME=${1:-naspool1}
DSNAME=${2:-nas_hdd}

zfs create \
    -o mountpoint=/$DSNAME \
    -o canmount=on \
    $POOLNAME/$DSNAME

chown root:users /$DSNAME
chmod 2775 /$DSNAME
setfacl -d -m g:users:rwx /$DSNAME