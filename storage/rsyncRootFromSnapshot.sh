#!/bin/bash

snapshot=${1:-debian_updated}
destroot=/mnt

for snapdir in $(find / -type d -name $snapshot | grep .zfs); do

    basedir=$(echo $snapdir | sed -e "s/\(.*\)\/\.zfs.*/\1/")

    echo From $snapdir to /mnt$basedir
    rsync -axHAWXS --numeric-ids --info=progress2 $snapdir/ $destroot$basedir
done