# Storage Setup

## Physical Drives

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

### `/dev/sda` — WDC WD80EFBX (VR08PUNK)

| Partition | Size | Type | ZFS Pool UUID |
|-----------|------|------|---------------|
| `sda1` | 7.3T | zfs_member | `6807500269204703395` |
| `sda9` | 8M | (reserved) | — |

### `/dev/sdb` — ST8000VN004 (WWZ3638L)

| Partition | Size | Type | ZFS Pool UUID |
|-----------|------|------|---------------|
| `sdb1` | 7.3T | zfs_member | `6807500269204703395` |
| `sdb9` | 8M | (reserved) | — |

### `/dev/sdc` — WD Blue SA510 (253221D00108)

| Partition | Size | Type | UUID | Label | Mountpoint |
|-----------|------|------|------|-------|------------|
| `sdc1` | 1M | BIOS boot | — | — | — |
| `sdc2` | 512M | vfat (EFI) | `DE0B-E036` | EFI | — |
| `sdc3` | 1G | ext4 (boot) | `4b6746e6-d63b-4616-a7be-c21d9661aefc` | boot | — |
| `sdc4` | 500G | zfs_member | `13563816363507188287` | — | — (zorro) |
| `sdc5` | 1000G | zfs_member | `13685500576337936062` | — | — (incus1) |

### `/dev/sdd` — Samsung SSD 870 EVO (S757NL0Y501255L)

| Partition | Size | Type | UUID | Mountpoint |
|-----------|------|------|------|------------|
| `sdd1` | 1000K | BIOS boot | — | — |
| `sdd2` | 512M | vfat (EFI) | `B887-87DA` | `/boot/efi` |
| `sdd3` | 1G | ext4 (boot) | `68e1be74-9e6a-4608-b803-7b6b5d21e3e2` | `/boot` |
| `sdd4` | 1T | zfs_member | `11675859661761872393` | — (zorro) |
| `sdd5` | 2.5T | zfs_member | `14168974846271485002` | — (incus1) |

### `/dev/sde` — ST8000VN0022 (ZA17C96C)

| Partition | Size | Type | ZFS Pool UUID |
|-----------|------|------|---------------|
| `sde1` | 7.3T | zfs_member | `6807500269204703395` |
| `sde9` | 8M | (reserved) | — |

### `/dev/sdf` — WDC WD80EFBX (VR0808PK)

| Partition | Size | Type | ZFS Pool UUID |
|-----------|------|------|---------------|
| `sdf1` | 7.3T | zfs_member | `6807500269204703395` |
| `sdf9` | 8M | (reserved) | — |

### `/dev/sdg` — Samsung SSD 870 EVO (S757NL0Y501333J)

| Partition | Size | Type | ZFS Pool UUID |
|-----------|------|------|---------------|
| `sdg1` | 1T | zfs_member | `13563816363507188287` (zorro) |
| `sdg2` | 2.6T | zfs_member | `13685500576337936062` (incus1) |

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

## Unassigned / Notes

- **`/dev/sda`, `/dev/sdb`, `/dev/sde`, `/dev/sdf`** — four 7.3T HDDs all share ZFS pool UUID `6807500269204703395` but are not listed in any active `zpool list` output. These are likely a separate bulk pool not currently imported (e.g. a NAS array imported under a different host or offline).
- **`zd0`, `zd16`, `zd32`** — ZFS virtual block devices (50G, 50G, 100G) backing the Incus VMs (`muffin`, `sam`, `winston`).
- **Boot configuration**: `/dev/sdd` is the active boot disk (`/boot/efi`, `/boot` mounted). `/dev/sdc` has matching EFI and boot partitions as a backup/mirror boot disk.
