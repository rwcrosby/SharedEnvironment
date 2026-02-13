#!/bin/bash

POOLNAME=${1:-zorro}
DSNAME=${2:-root}

zfs create \
    -o mountpoint=/ \
    -o canmount=on \
    $POOLNAME/$DSNAME

DSNAME=${2:-home}

zfs create \
    -o mountpoint=/home \
    -o canmount=on \
    $POOLNAME/$DSNAME

