#!/usr/bin/env python3
import argparse
import datetime
import subprocess
import sys


def parse_args():
    parser = argparse.ArgumentParser(
        description="Recursively snapshot all datasets in a ZFS pool"
    )
    parser.add_argument("pool", help="ZFS pool name")
    parser.add_argument("descriptor", help="Snapshot label appended after the date")
    parser.add_argument("--dry-run", action="store_true", help="Print commands without executing")
    return parser.parse_args()


def list_datasets(pool, dry_run):
    if dry_run:
        print(f"[DRY RUN] zfs list -r -H -o name {pool}")
        return [pool, f"{pool}/data", f"{pool}/home"]
    try:
        out = subprocess.check_output(
            ["zfs", "list", "-r", "-H", "-o", "name", pool], text=True
        )
        return out.strip().splitlines()
    except subprocess.CalledProcessError as e:
        sys.exit(f"Error listing datasets for pool '{pool}': {e}")


def take_snapshot(dataset, snap_name, dry_run):
    snapshot = f"{dataset}@{snap_name}"
    cmd = ["zfs", "snapshot", snapshot]
    if dry_run:
        print(f"[DRY RUN] {' '.join(cmd)}")
        return
    try:
        print(f"Snapshotting: {snapshot}")
        subprocess.check_call(cmd)
    except subprocess.CalledProcessError as e:
        print(f"Error snapshotting {snapshot}: {e}", file=sys.stderr)


def main():
    args = parse_args()
    date_str = datetime.date.today().strftime("%y-%m-%d")
    snap_name = f"{date_str}_{args.descriptor}"

    datasets = list_datasets(args.pool, args.dry_run)
    if not datasets:
        sys.exit(f"No datasets found in pool '{args.pool}'")

    print(f"Snapshot name: {snap_name}")
    print(f"Datasets found: {len(datasets)}")
    for ds in datasets:
        take_snapshot(ds, snap_name, args.dry_run)


if __name__ == "__main__":
    main()
