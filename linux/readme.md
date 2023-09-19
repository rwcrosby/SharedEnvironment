# New Linux instance setup

- Install the O/S

- Install ansible and git

    ```shell
    sudo apt update
    sudo apt-get install ansible git
    ```

    or

    ```shell
    sudo dnf install ansible git nano fuse
    ```

- Allow shared drive access

    - VirtualBox

        ```shell
        sudo usermod -aG vboxsf rcrosby
        - logout and back in

    - VMWare

        Add to `etc/fstab`

        ```shell
        vmhgfs-fuse /mnt/hgfs fuse defaults,allow_other,uid=1000 0 0
        ```

- Clone the shared environment (or link to it on a shared volume)

    - Clone

        ```shell
        git clone https://github.com/rwcrosby/SharedEnvironment.git ~/Projects/SharedEnvironment`
        ```

    - VirtualBox

        ```shell
        ln -s /media/sf_Ubuntu-22.04/home/rcrosby/Projects .
        ```
    - VMWare

        ```shell
        mkdir -p ~/Projects
        ln -s /mnt/hgfs/rcrosby/Projects/SharedEnvironment ~/Projects/
        ```

- Copy ssh key

    ```shell
    ansible-playbook -i vmname.local copy_ssh_key.yaml
    ``````

- Ansible setup

    ```shell
    ansible-playbook setup_linux_vm.yaml
    ``````

## Ansible Roles

- sudo
- base_setup
- install_python
- gnome_customization

## Alpine

- Uncomment community repo in `/etc/apk/repositories`

    ```shell
    apk update
    apk add nano tmux sudo avahi git
    ```

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


# Virtualization

## QEMU

https://adonis0147.github.io/post/qemu-macos-apple-silicon/

https://developers.redhat.com/blog/2020/03/06/configure-and-run-a-qemu-based-vm-outside-of-libvirt

https://www.qemu.org/docs/master/system/keys.html


## libvert VM setup

Physical system only

- libvert
    - Install TPM
    - Download windows image

- https://www.reddit.com/r/kvm/comments/ri0db6/virt_manager_windows_vm_only_800_x_600_resolution/

- https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md

### <2023-09-01 Fri 08:04>

`virt-manager`` seems to handle this just fine in conjunction with `qemu`


# SSH Keys

- WSL

cat id_ecdsa.pub

ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLTvRIzzaxDxhQeOuaGf8M+vNMOcb1b2WzqayxuXDnV4QPLtgl4thqam/Rjwb+IJBEcZkYZxBVGyRkGjagfDXw4= rcrosby@PMWS213

- Win11

cat .\id_ecdsa.pub


ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGIVusjIpv43HlDuBcRv/QYWlPGAvJOB1ppNbOCQ5eyJRgxbiRcWCmEpbbjE3zJ0NG4iGYBb9iPlt0mmw3nEXpQ= camcom\rcrosby@PMWS213

# Utilities

## Testing

https://arstechnica.com/gadgets/2020/02/how-fast-are-your-disks-find-out-the-open-source-way-with-fio/


