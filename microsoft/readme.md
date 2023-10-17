# Microsoft Files

Word and powerpoint templates

- In Word set:

    Word->Preferences->File Locations->Workgroup Templates

# Windows 11 Virtual Machines

https://communities.vmware.com/t5/VMware-Fusion-Documents/The-Unofficial-Fusion-13-for-Apple-Silicon-Companion-Guide/ta-p/2939907

# WSL2

## Fedora Setup

- <2023-10-16 Mon 17:43> Add Fedora to WSL

    - Downloaded fedora root filesystem

    - Imported to wsl2

- <2023-10-16 Mon 18:00> Installed packages

    - parted
    - e2fsprogs

- <2023-10-16 Mon 17:47> Created vhdx file and formatted

    - https://github.com/microsoft/WSL/discussions/5896
    - https://github.com/MicrosoftDocs/WSL/blob/main/WSL/wsl2-mount-disk.md
    - https://docs.fedoraproject.org/en-US/quick-docs/creating-a-disk-partition-in-linux/


   - `wsl --mount \\.\PHYSICALDRIVE1 --partition 2`

    - Appears as /mnt/wsl/PHYSICALDRIVE1p2
    - Needs to be remounted after reboots

- <2023-10-17 Tue 13:26> Make sure to user uid:1000/gid:1000

- <2023-10-17 Tue 14:07> Other config

    - Enable systemd in `/etc/esl.conf`