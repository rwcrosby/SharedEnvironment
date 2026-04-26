#!/usr/bin/env python3
import argparse
import subprocess
import sys


def parse_args():
    parser = argparse.ArgumentParser(
        description="Copy ZFS snapshots from one pool to another via send/recv"
    )
    parser.add_argument("source_pool", help="Source ZFS pool")
    parser.add_argument("target_pool", help="Target ZFS pool")
    parser.add_argument("snapshot", help="Snapshot name to send (without @)")
    parser.add_argument(
        "--incremental", "-i", metavar="OLD_SNAPSHOT",
        help="Base snapshot for incremental send (triggers 'zfs send -i')"
    )
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
        sys.exit(f"Error listing datasets in '{pool}': {e}")


def send_recv(source_pool, dataset, target_pool, snapshot, incremental, dry_run):
    # Preserve the dataset hierarchy under the target pool
    rel = dataset[len(source_pool):]          # '' for pool root, '/sub/ds' otherwise
    target_ds = f"{target_pool}{rel}"

    source_snap = f"{dataset}@{snapshot}"

    if incremental:
        send_cmd = f"zfs send -i {dataset}@{incremental} {source_snap}"
    else:
        send_cmd = f"zfs send {source_snap}"

    recv_cmd = f"zfs recv -Fu {target_ds}"
    pipeline = f"{send_cmd} | {recv_cmd}"

    if dry_run:
        print(f"[DRY RUN] {pipeline}")
        return True

    print(f"Sending: {source_snap} -> {target_ds}")
    try:
        subprocess.check_call(pipeline, shell=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error sending {source_snap}: {e}", file=sys.stderr)
        return False


def main():
    args = parse_args()

    mode = f"incremental from '{args.incremental}'" if args.incremental else "full"
    print(f"Mode:          {mode}")
    print(f"Source pool:   {args.source_pool}")
    print(f"Target pool:   {args.target_pool}")
    print(f"Snapshot:      {args.snapshot}")

    datasets = list_datasets(args.source_pool, args.dry_run)
    if not datasets:
        sys.exit(f"No datasets found in pool '{args.source_pool}'")

    print(f"Datasets:      {len(datasets)}\n")

    errors = 0
    for ds in datasets:
        ok = send_recv(
            args.source_pool, ds, args.target_pool,
            args.snapshot, args.incremental, args.dry_run
        )
        if not ok:
            errors += 1

    if errors:
        sys.exit(f"\n{errors} dataset(s) failed.")


if __name__ == "__main__":
    main()
