# ZFS Scripts

Scripts for creating pools and datasets, snapshotting, and replicating ZFS data.

---

## Pool Creation

### `zpoolCreateZorro.sh`
Creates the `zorro` root pool (SSD, encrypted with passphrase).

```bash
./zpoolCreateZorro.sh [pool_name] [device]
# Default: pool=zorro, device=/dev/disk/by-id/ata-WD_Blue_SA510_2.5_4TB_...-part4
```

Key options: `ashift=12`, `autotrim=on`, `compression=lz4`, `encryption=on` (passphrase).

---

### `zpoolCreateNasHdd.sh`
Creates an encrypted NAS pool on HDD devices using RAIDZ1.

```bash
./zpoolCreateNasHdd.sh [pool_name] [devices...]
# Default: pool=naspool1, devices matched by scsi-0QEMU_QEMU_HARDDISK_incus_nashdd*
```

Key options: `raidz1`, `compression=lz4`, `encryption=on` (key file: `/etc/nas-key.txt`).

---

### `zpoolCreateNasSdd.sh`
Creates an encrypted NAS pool on a single SSD device.

```bash
./zpoolCreateNasSdd.sh [pool_name] [device]
# Default: pool=naspool0, device=scsi-0QEMU_QEMU_HARDDISK_incus_sdd1
```

Key options: `ashift=12`, `autotrim=on`, `compression=lz4`, `encryption=on` (key file: `/etc/nas-key.txt`).

---

### `zpoolCreateBackup4T.sh`
Creates an encrypted backup pool (macOS-compatible, hex key).

```bash
./zpoolCreateBackup4T.sh [pool_name] [device]
# Default: pool=Backup4T, device=/dev/disk6
```

Key options: `ashift=12`, `compression=lz4`, `encryption=on` (hex key, prompted).

---

### `zpoolCreateIncus.sh`
Creates an encrypted pool for Incus containers (key loaded from file).

```bash
./zpoolCreateIncus.sh [pool_name] [device]
# Default: pool=incus1, device=/dev/disk/by-id/ata-WD_Blue_SA510_2.5_4TB_...-part5
```

Key options: `encryption=on` (hex key file: `/etc/zfs/incus-key.txt`).

---

## Dataset Creation

### `zfsCreateHomeDataset.sh`
Creates a shared home/NAS dataset with group-writable ACLs.

```bash
./zfsCreateHomeDataset.sh [pool_name] [dataset_name]
# Default: pool=naspool1, dataset=nas_hdd
# Mounts at /<dataset_name>, owned root:users, mode 2775
```

---

### `zfsCreateTimeMachineDataset.sh`
Creates a dataset suitable for Time Machine backups (unencrypted, lz4 compressed).

```bash
./zfsCreateTimeMachineDataset.sh [pool_name] [dataset_name]
# Default: pool=naspool1, dataset=nas_hdd/TimeMachine
# Mounts at /<dataset_name>, owned root:users, mode 2775
```

---

### `zfsCreateZorroDatasets.sh`
Creates `root` and `home` datasets on the zorro pool.

```bash
./zfsCreateZorroDatasets.sh [pool_name]
# Default: pool=zorro
# Creates <pool>/root -> mountpoint=/ and <pool>/home -> mountpoint=/home
```

---

## Snapshots

### `zfsSnapshot.py`
Recursively snapshots all datasets in a pool. Snapshot names are formatted as `yy-mm-dd_<descriptor>`.

```bash
./zfsSnapshot.py <pool> <descriptor> [--dry-run]
```

| Argument | Description |
|----------|-------------|
| `pool` | ZFS pool to snapshot |
| `descriptor` | Label appended to the date (e.g. `weekly`, `pre-upgrade`) |
| `--dry-run` | Print commands without executing |

```bash
./zfsSnapshot.py tank weekly
# Creates tank@26-04-26_weekly, tank/data@26-04-26_weekly, etc.
```

---

## Replication

### `zfsSendRecv.py`
Copies snapshots from one pool to another via `zfs send | zfs recv`, preserving the dataset hierarchy. Supports full and incremental sends.

```bash
./zfsSendRecv.py [--incremental OLD_SNAPSHOT] [--dry-run] <source_pool> <target_pool> <snapshot>
```

| Argument | Description |
|----------|-------------|
| `source_pool` | Pool to send from |
| `target_pool` | Pool to receive into |
| `snapshot` | Snapshot name to send (without `@`) |
| `-i / --incremental OLD_SNAPSHOT` | Send only changes since `OLD_SNAPSHOT` |
| `--dry-run` | Print commands without executing |

```bash
# Full replication
./zfsSendRecv.py tank backup 26-04-26_weekly

# Incremental replication
./zfsSendRecv.py -i 26-04-19_weekly tank backup 26-04-26_weekly
```

Dataset mapping: `<source_pool>/sub/ds` → `<target_pool>/sub/ds`.
Uses `zfs recv -Fu` (force rollback, no auto-mount).

---

### `zfsSendIncus1.sh`
One-off script that pulls a specific snapshot of all `incus1` datasets from the `zorro` host over SSH and receives them into `Backup5T`.

```bash
# Hardcoded snapshot: 2025-12-14_after_encrypted_move
# Source: ssh zorro -- zfs send ...
# Target: Backup5T/<dataset>
./zfsSendIncus1.sh
```

---

## Restore

### `rsyncRootFromSnapshot.sh`
Restores filesystem content from a ZFS snapshot using `rsync`. Finds all `.zfs/snapshots/<name>` directories on the system and rsyncs each back to `/mnt<original_path>`.

```bash
./rsyncRootFromSnapshot.sh [snapshot_name]
# Default snapshot: debian_updated
# Destination root: /mnt
```

Uses `rsync -axHAWXS --numeric-ids` to preserve all attributes and ACLs.
