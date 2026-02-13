#!/usr/bin/env python3
import argparse
import yaml
import sys
import os
import subprocess
import datetime

def parse_args():
    parser = argparse.ArgumentParser(description="Backup Manager for ZFS and Incus")
    parser.add_argument("--config", required=True, help="Path to configuration file")
    parser.add_argument("--type", choices=['full', 'incremental'], help="Override backup type")
    parser.add_argument("--target", help="Override target volume path")
    parser.add_argument("--tag", help="Override backup tag")
    parser.add_argument("--server", help="Remote server hostname (e.g. user@host)")
    parser.add_argument("--dry-run", action="store_true", help="Print commands without executing")
    return parser.parse_args()

def load_config(config_path):
    try:
        with open(config_path, 'r') as f:
            return yaml.safe_load(f)
    except FileNotFoundError:
        sys.exit(f"Error: Configuration file not found: {config_path}")
    except yaml.YAMLError as exc:
        sys.exit(f"Error parsing YAML: {exc}")

def run_command(cmd, dry_run=False):
    if dry_run:
        print(f"[DRY RUN] {' '.join(cmd)}")
        return True
    
    try:
        print(f"Running: {' '.join(cmd)}")
        subprocess.check_call(cmd)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}", file=sys.stderr)
        return False

def build_remote_cmd(server, cmd):
    if not server:
        # For local pipe or execution, we return the list.
        # But if we need to stringify for a pipe construction later, we might need a string.
        # Let's return list for now, and handle stringification in the caller or specific run method.
        return cmd
    cmd_str = ' '.join(cmd)
    return ['ssh', server, cmd_str]

def get_zfs_mountpoint(dataset, dry_run=False):
    if dry_run:
        return f"/mock/mountpoint/{dataset}"
    try:
        # zfs get -H -o value mountpoint dataset
        out = subprocess.check_output(['zfs', 'get', '-H', '-o', 'value', 'mountpoint', dataset], text=True).strip()
        return out
    except subprocess.CalledProcessError:
        return None

def backup_zfs(dataset, target, tag, backup_type, server=None, dry_run=False):
    # Ensure date is at the start of the names
    dt = datetime.date.today().strftime("%Y-%m-%d")
    
    snap_name = f"{dt}_{tag}"
    snapshot = f"{dataset}@{snap_name}"
    
    # Target dataset for recv: target/dataset_basename
    # e.g. target=tank/backups, dataset=rpool/data -> tank/backups/data
    ds_basename = dataset.split('/')[-1]
    target_ds = f"{target}/{ds_basename}"
    
    origin = server if server else "Local"
    print(f"Replicating ZFS dataset ({origin}): {dataset} to {target_ds} (Snapshot: {snapshot})")
    
    # 1. Take snapshot
    snap_cmd = ['zfs', 'snapshot', snapshot]
    snap_cmd_exec = build_remote_cmd(server, snap_cmd)
        
    if not run_command(snap_cmd_exec, dry_run):
        return

    # 2. Pipeline: zfs send ... | zfs recv ...
    # We construct the pipeline as a shell string.
    
    # Source side
    if server:
        send_cmd = f"ssh {server} zfs send {snapshot}"
    else:
        send_cmd = f"zfs send {snapshot}"
        
    # Destination side (always local recv based on requirements? Or recv to remote?)
    # "output should zfs revc to the specified target" implies the script runs where the target is?
    # Usually "pull" capability.
    recv_cmd = f"zfs recv -F {target_ds}"
    
    full_pipeline = f"{send_cmd} | {recv_cmd}"

    if dry_run:
        print(f"[DRY RUN] {full_pipeline}")
    else:
        try:
            print(f"Running: {full_pipeline}")
            # shell=True required for pipe
            subprocess.check_call(full_pipeline, shell=True)
        except subprocess.CalledProcessError as e:
            print(f"Error executing pipeline: {e}", file=sys.stderr)

def backup_incus(instance, target, tag, backup_type, server=None, dry_run=False):
    dt = datetime.date.today().strftime("%Y-%m-%d")
    
    # For incus, we need a file path.
    # If target is a ZFS dataset, we need its mountpoint.
    mountpoint = get_zfs_mountpoint(target, dry_run=dry_run)
    if not mountpoint or mountpoint == 'legacy' or mountpoint == 'none':
        # Fallback? Or assume target is a path if it looks like one?
        if target.startswith('/'):
            target_path = target
        else:
             print(f"Error: Could not resolve mountpoint for ZFS dataset '{target}' to store Incus backup.", file=sys.stderr)
             return
    else:
        target_path = mountpoint
        
    filename = f"{dt}_{instance}_{tag}.tar.gz"
    filepath = os.path.join(target_path, filename)
    
    origin = server if server else "Local"
    print(f"Backing up Incus instance ({origin}): {instance} to {filepath}")
    
    if server:
        # Remote: ssh server "incus export instance -" > filepath
        # We can do this with shell redirection
        cmd_str = f"ssh {server} \"incus export {instance} -\" > {filepath}"
        if dry_run:
            print(f"[DRY RUN] {cmd_str}")
        else:
             try:
                 print(f"Running: {cmd_str}")
                 subprocess.check_call(cmd_str, shell=True)
             except subprocess.CalledProcessError as e:
                print(f"Error exporting instance: {e}", file=sys.stderr)
    else:
        # Local
        cmd_list = ['incus', 'export', instance, filepath]
        if dry_run:
             print(f"[DRY RUN] {' '.join(cmd_list)}")
        else:
            try:
                 print(f"Running: {' '.join(cmd_list)}")
                 subprocess.check_call(cmd_list)
            except subprocess.CalledProcessError as e:
                 print(f"Error exporting instance: {e}", file=sys.stderr)

def main():
    args = parse_args()
    config = load_config(args.config)
    
    # Overrides
    backup_type = args.type if args.type else config.get('type', 'full')
    target_vol = args.target if args.target else config.get('target_volume')
    tag = args.tag if args.tag else config.get('tag', datetime.datetime.now().strftime("%Y%m%d_%H%M%S"))
    server = args.server if args.server else config.get('server')
    
    if not target_vol:
        sys.exit("Error: Target volume not specified in config or arguments")

    # If target looks like a path, check it exists. If it's a dataset, we might check `zfs list`.
    if target_vol.startswith('/'):
        if not os.path.isdir(target_vol):
             if not args.dry_run:
                  sys.exit(f"Error: Target directory does not exist: {target_vol}")
    # Else assume it's a zfs dataset, validation happens during execution or we could check `zfs list` here.

    # Process ZFS datasets
    zfs_datasets = config.get('zfs_datasets', [])
    for dataset in zfs_datasets:
        backup_zfs(dataset, target_vol, tag, backup_type, server=server, dry_run=args.dry_run)

    # Process Incus instances
    incus_instances = config.get('incus_instances', [])
    for instance in incus_instances:
        backup_incus(instance, target_vol, tag, backup_type, server=server, dry_run=args.dry_run)

if __name__ == "__main__":
    main()
