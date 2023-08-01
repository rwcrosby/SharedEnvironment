# New Linux instance setup

- Install the O/S

- Install ansible and git

    ```
    sudo apt update
    sudo apt-get install ansible git
    ```

- Clone the shared environment (or link to it on a shared volume)

    `git clone https://github.com/rwcrosby/SharedEnvironment.git ~/Projects/SharedEnvironment`

- Ansible setup

    `ansible-platbook setup_linux_vm`

## Ansible Roles

- sudo
- base_setup
- install_python
- gnome_customization

# Network Setup

VM Setup assumes two network interfaces

- Two interfaces
    1. Nat
        - DHCP
    2. Host only 
        - Hypervisor Dependent
        - dhcp

- `avahi`` running on the guests to allow local name resolution


## Network commands

```shell

# Static ip

nmcli con add con-name hostonly ifname enp0s8 type ethernet ip4 192.168.33.101/24 gw4 192.168.33.1

# dhcp

nmcli con add con-name hostonly ifname enp0s8 type ethernet ipv4 method auto

ip route add 172.17.128.0/24 via 192.168.56.101 dev enp0s8

# Finding gateway used:

ip route get 192.168.33.100

# Start connection

nmcli con up hostonly

```

- 07/25/23
    - Connectivity between two VM's using host only networking
        - Host only adapter set to dhcp
        - Using .local as domain name


# libvert VM setup

Physical system only

- libvert
    - Install TPM
    - Download windows image

- https://www.reddit.com/r/kvm/comments/ri0db6/virt_manager_windows_vm_only_800_x_600_resolution/

- https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md


# SSH Keys

- WSL

cat id_ecdsa.pub

ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLTvRIzzaxDxhQeOuaGf8M+vNMOcb1b2WzqayxuXDnV4QPLtgl4thqam/Rjwb+IJBEcZkYZxBVGyRkGjagfDXw4= rcrosby@PMWS213

- Win11

cat .\id_ecdsa.pub


ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGIVusjIpv43HlDuBcRv/QYWlPGAvJOB1ppNbOCQ5eyJRgxbiRcWCmEpbbjE3zJ0NG4iGYBb9iPlt0mmw3nEXpQ= camcom\rcrosby@PMWS213
