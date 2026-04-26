# Storage

## ZFS Scripts

Scripts for creating pools and datasets, snapshotting, and replicating ZFS data.

---

### Pool Creation

#### `zpoolCreateZorro.sh`
Creates the `zorro` root pool (SSD, encrypted with passphrase).

```bash
./zpoolCreateZorro.sh [pool_name] [device]
# Default: pool=zorro, device=/dev/disk/by-id/ata-WD_Blue_SA510_2.5_4TB_...-part4
```

Key options: `ashift=12`, `autotrim=on`, `compression=lz4`, `encryption=on` (passphrase).

---

#### `zpoolCreateNasHdd.sh`
Creates an encrypted NAS pool on HDD devices using RAIDZ1.

```bash
./zpoolCreateNasHdd.sh [pool_name] [devices...]
# Default: pool=naspool1, devices matched by scsi-0QEMU_QEMU_HARDDISK_incus_nashdd*
```

Key options: `raidz1`, `compression=lz4`, `encryption=on` (key file: `/etc/nas-key.txt`).

---

#### `zpoolCreateNasSdd.sh`
Creates an encrypted NAS pool on a single SSD device.

```bash
./zpoolCreateNasSdd.sh [pool_name] [device]
# Default: pool=naspool0, device=scsi-0QEMU_QEMU_HARDDISK_incus_sdd1
```

Key options: `ashift=12`, `autotrim=on`, `compression=lz4`, `encryption=on` (key file: `/etc/nas-key.txt`).

---

#### `zpoolCreateBackup4T.sh`
Creates an encrypted backup pool (macOS-compatible, hex key).

```bash
./zpoolCreateBackup4T.sh [pool_name] [device]
# Default: pool=Backup4T, device=/dev/disk6
```

Key options: `ashift=12`, `compression=lz4`, `encryption=on` (hex key, prompted).

---

#### `zpoolCreateIncus.sh`
Creates an encrypted pool for Incus containers (key loaded from file).

```bash
./zpoolCreateIncus.sh [pool_name] [device]
# Default: pool=incus1, device=/dev/disk/by-id/ata-WD_Blue_SA510_2.5_4TB_...-part5
```

Key options: `encryption=on` (hex key file: `/etc/zfs/incus-key.txt`).

---

### Dataset Creation

#### `zfsCreateHomeDataset.sh`
Creates a shared home/NAS dataset with group-writable ACLs.

```bash
./zfsCreateHomeDataset.sh [pool_name] [dataset_name]
# Default: pool=naspool1, dataset=nas_hdd
# Mounts at /<dataset_name>, owned root:users, mode 2775
```

---

#### `zfsCreateTimeMachineDataset.sh`
Creates a dataset suitable for Time Machine backups (unencrypted, lz4 compressed).

```bash
./zfsCreateTimeMachineDataset.sh [pool_name] [dataset_name]
# Default: pool=naspool1, dataset=nas_hdd/TimeMachine
# Mounts at /<dataset_name>, owned root:users, mode 2775
```

---

#### `zfsCreateZorroDatasets.sh`
Creates `root` and `home` datasets on the zorro pool.

```bash
./zfsCreateZorroDatasets.sh [pool_name]
# Default: pool=zorro
# Creates <pool>/root -> mountpoint=/ and <pool>/home -> mountpoint=/home
```

---

### Snapshots

#### `zfsSnapshot.py`
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

### Replication

#### `zfsSendRecv.py`
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

#### `zfsSendIncus1.sh`
One-off script that pulls a specific snapshot of all `incus1` datasets from the `zorro` host over SSH and receives them into `Backup5T`.

```bash
# Hardcoded snapshot: 2025-12-14_after_encrypted_move
# Source: ssh zorro -- zfs send ...
# Target: Backup5T/<dataset>
./zfsSendIncus1.sh
```

---

### Restore

#### `rsyncRootFromSnapshot.sh`
Restores filesystem content from a ZFS snapshot using `rsync`. Finds all `.zfs/snapshots/<name>` directories on the system and rsyncs each back to `/mnt<original_path>`.

```bash
./rsyncRootFromSnapshot.sh [snapshot_name]
# Default snapshot: debian_updated
# Destination root: /mnt
```

Uses `rsync -axHAWXS --numeric-ids` to preserve all attributes and ACLs.

---

## ZFS Pools

### `zorro` — OS / System Pool

| Property | Value |
|----------|-------|
| Size | 496G |
| Used | 24.0G |
| Free | 472G |
| Health | ONLINE |
| Topology | mirror-0 |
| Last scrub/resilver | Resilvered 26.1G in 00:01:13 with 0 errors (2026-04-18) |

**Vdevs:**

| Vdev | Member | Device |
|------|--------|--------|
| mirror-0 | `ata-WD_Blue_SA510_2.5_4TB_253221D00108-part4` | `/dev/sdc4` (500G) |
| mirror-0 | `ata-Samsung_SSD_870_EVO_4TB_S757NL0Y501333J-part1` | `/dev/sdg1` (1T) |

**Datasets:**

| Dataset | Used | Avail | Mountpoint |
|---------|------|-------|------------|
| `zorro` | 24.1G | 457G | `/` |
| `zorro/home` | 7.58G | 457G | `/home` |
| `zorro/root` | 16.5G | 457G | `/root` |

---

### `incus1` — Incus Container/VM Pool

| Property | Value |
|----------|-------|
| Size | 992G |
| Used | 45.1G |
| Free | 947G |
| Health | ONLINE |
| Topology | mirror-0 |
| Last scrub | Scrubbed with 0 errors (2026-04-12) |

**Vdevs:**

| Vdev | Member | Device |
|------|--------|--------|
| mirror-0 | `ata-WD_Blue_SA510_2.5_4TB_253221D00108-part5` | `/dev/sdc5` (1000G) |
| mirror-0 | `ata-Samsung_SSD_870_EVO_4TB_S757NL0Y501333J-part2` | `/dev/sdg2` (2.64T) |

**Datasets:**

| Dataset | Used | Avail | Notes |
|---------|------|-------|-------|
| `incus1` | 45.1G | 916G | Pool root (legacy mount) |
| `incus1/buckets` | 98K | 916G | |
| `incus1/containers` | 13.0G | 916G | |
| `incus1/containers/bowser` | 13.0G | 37.0G | Quota enforced |
| `incus1/containers/ntp` | 1.51M | 10.0G | Quota enforced |
| `incus1/custom` | 98K | 916G | |
| `incus1/deleted` | 11.1M | 916G | Recycle area |
| `incus1/images` | 98K | 916G | |
| `incus1/virtual-machines` | 31.9G | 916G | |
| `incus1/virtual-machines/muffin` | 1004K | 499M | VM metadata; `.block` = 15.0G |
| `incus1/virtual-machines/sam` | 1.14M | 499M | VM metadata; `.block` = 12.7G |
| `incus1/virtual-machines/winston` | 2.49M | 498M | VM metadata; `.block` = 4.23G |

---

## Physical Drives

> Note: `/dev/sdX` names are assigned at boot and may differ between sessions. Use ATA IDs for stable references.

| Device | Model | Serial | Size | Role |
|--------|-------|--------|------|------|
| `/dev/sda` | WDC WD80EFBX-68AZZN0 | VR08PUNK | 7.3T | NAS array (bulk pool) |
| `/dev/sdb` | ST8000VN004-3CP101 | WWZ3638L | 7.3T | NAS array (bulk pool) |
| `/dev/sdc` | WD Blue SA510 2.5 4TB | 253221D00108 | 3.6T | Boot drive + ZFS (primary SSD) |
| `/dev/sdd` | Samsung SSD 870 EVO 4TB | S757NL0Y501255L | 3.6T | Boot drive + ZFS (secondary SSD) |
| `/dev/sde` | ST8000VN0022-2EL112 | ZA17C96C | 7.3T | NAS array (bulk pool) |
| `/dev/sdf` | WDC WD80EFBX-68AZZN0 | VR0808PK | 7.3T | NAS array (bulk pool) |
| `/dev/sdg` | Samsung SSD 870 EVO 4TB | S757NL0Y501333J | 3.6T | ZFS mirror (SSD pair for sdc) |

### Disk IDs (`/dev/disk/by-id/`)

| ATA ID | WWN | Device |
|--------|-----|--------|
| `ata-WDC_WD80EFBX-68AZZN0_VR08PUNK` | `wwn-0x5000cca0c3c3f4e8` | `/dev/sda` |
| `ata-ST8000VN004-3CP101_WWZ3638L` | `wwn-0x5000c500e7b89afe` | `/dev/sdb` |
| `ata-WD_Blue_SA510_2.5_4TB_253221D00108` | `wwn-0x5001b44dd440a0e6` | `/dev/sdc` |
| `ata-Samsung_SSD_870_EVO_4TB_S757NL0Y501255L` | `wwn-0x5002538f5550e532` | `/dev/sdd` |
| `ata-ST8000VN0022-2EL112_ZA17C96C` | `wwn-0x5000c500a2d1df89` | `/dev/sde` |
| `ata-WDC_WD80EFBX-68AZZN0_VR0808PK` | `wwn-0x5000cca0c3c3a405` | `/dev/sdf` |
| `ata-Samsung_SSD_870_EVO_4TB_S757NL0Y501333J` | `wwn-0x5002538f5550e580` | `/dev/sdg` |

---

## Partitions

### `ata-WDC_WD80EFBX-68AZZN0_VR08PUNK` — WDC WD80EFBX (7.3T, NAS array)

| Partition | PARTUUID | Size | Type | ZFS Pool UUID |
|-----------|----------|------|------|---------------|
| part1 | `77899c60-8280-df43-bf70-33d070cc6a79` | 7.3T | zfs_member | `6807500269204703395` |
| part9 | `45d6cb0d-dce1-c34d-81b4-08c23421a71b` | 8M | (reserved) | — |

### `ata-ST8000VN004-3CP101_WWZ3638L` — ST8000VN004 (7.3T, NAS array)

| Partition | PARTUUID | Size | Type | ZFS Pool UUID |
|-----------|----------|------|------|---------------|
| part1 | `11ce31d4-51be-8643-a02c-67cc51d2c870` | 7.3T | zfs_member | `6807500269204703395` |
| part9 | `55aaf46c-8732-8d44-9ae9-d5bba5bb3ae7` | 8M | (reserved) | — |

### `ata-WD_Blue_SA510_2.5_4TB_253221D00108` — WD Blue SA510 (3.6T, primary SSD)

| Partition | PARTUUID | Size | Type | UUID | Label | Mountpoint |
|-----------|----------|------|------|------|-------|------------|
| part1 | `fbdd8219-4953-47c1-a18f-8f231eae0d79` | 1M | BIOS boot | — | — | — |
| part2 | `6f037c1b-7436-4d6d-830f-0a1b27532b26` | 512M | vfat (EFI) | `DE0B-E036` | EFI | — |
| part3 | `c8f8343c-b005-4674-919a-b067f778fe58` | 1G | ext4 (boot) | `4b6746e6-d63b-4616-a7be-c21d9661aefc` | boot | — |
| part4 | `7b6954b9-6c6d-44ab-930e-4488e778bda7` | 500G | zfs_member | `13563816363507188287` | — | — (zorro) |
| part5 | `ec9f244b-01fe-47b6-ad8c-0f56743a6f5a` | 1000G | zfs_member | `13685500576337936062` | — | — (incus1) |

### `ata-Samsung_SSD_870_EVO_4TB_S757NL0Y501255L` — Samsung SSD 870 EVO (3.6T, secondary SSD / active boot disk)

| Partition | PARTUUID | Size | Type | UUID | Mountpoint |
|-----------|----------|------|------|------|------------|
| part1 | `4bac1920-5d7f-4866-96d2-7338ab4558f8` | 1000K | BIOS boot | — | — |
| part2 | `4fa3a046-c070-4328-a8de-36c07e5f5dc1` | 512M | vfat (EFI) | `B887-87DA` | `/boot/efi` |
| part3 | `66eb06aa-98e0-442c-a09c-9e50bb01d09b` | 1G | ext4 (boot) | `68e1be74-9e6a-4608-b803-7b6b5d21e3e2` | `/boot` |
| part4 | `ed362fb9-d139-45aa-ac67-0d8f6a663ddd` | 1T | zfs_member | `11675859661761872393` | — (zorro) |
| part5 | `02f79d51-2c4d-4d5a-b179-74c27a4d2018` | 2.5T | zfs_member | `14168974846271485002` | — (incus1) |

### `ata-ST8000VN0022-2EL112_ZA17C96C` — ST8000VN0022 (7.3T, NAS array)

| Partition | PARTUUID | Size | Type | ZFS Pool UUID |
|-----------|----------|------|------|---------------|
| part1 | `11221bdd-661e-bf4c-881c-0d6ef6f343d6` | 7.3T | zfs_member | `6807500269204703395` |
| part9 | `9b1fa09a-10a5-9343-840b-093b5c8aa73a` | 8M | (reserved) | — |

### `ata-WDC_WD80EFBX-68AZZN0_VR0808PK` — WDC WD80EFBX (7.3T, NAS array)

| Partition | PARTUUID | Size | Type | ZFS Pool UUID |
|-----------|----------|------|------|---------------|
| part1 | `9e827c91-5e57-5f49-874c-c9db4fbf28aa` | 7.3T | zfs_member | `6807500269204703395` |
| part9 | `5bbfb49b-5b1c-e744-8962-913c8d22800a` | 8M | (reserved) | — |

### `ata-Samsung_SSD_870_EVO_4TB_S757NL0Y501333J` — Samsung SSD 870 EVO (3.6T, ZFS mirror for primary SSD)

| Partition | PARTUUID | Size | Type | ZFS Pool UUID |
|-----------|----------|------|------|---------------|
| part1 | `b170b868-c409-43f7-9fea-0894091b801a` | 1T | zfs_member | `13563816363507188287` (zorro) |
| part2 | `fb7a9154-cf8f-4e39-af26-b567a450ceb6` | 2.6T | zfs_member | `13685500576337936062` (incus1) |

---

## Notes

- **`/dev/sda`, `/dev/sdb`, `/dev/sde`, `/dev/sdf`** — four 7.3T HDDs all share ZFS pool UUID `6807500269204703395` but are not listed in any active `zpool list` output. These are likely a separate bulk pool not currently imported (e.g. a NAS array imported under a different host or offline).
- **`zd0`, `zd16`, `zd32`** — ZFS virtual block devices (50G, 50G, 100G) backing the Incus VMs (`muffin`, `sam`, `winston`).
- **Boot configuration**: `S757NL0Y501255L` is the active boot disk (`/boot/efi`, `/boot` mounted). `253221D00108` has matching EFI and boot partitions as a backup/mirror boot disk.
