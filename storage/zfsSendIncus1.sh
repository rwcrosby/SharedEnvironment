#!/bin/bash

SNAPSHOT=2025-12-14_after_encrypted_move
DATASETS=$(ssh zorro -- zfs list -t snapshot -H -o name -r incus1 | grep $SNAPSHOT)

echo $DATASETS

for DATASET in $DATASETS; do
    echo "Sending dataset: $DATASET"
    ssh zorro -- zfs send -v $DATASET | sudo zfs recv -F Backup5T/$DATASET
done