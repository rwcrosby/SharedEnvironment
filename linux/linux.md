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

    `ansible-platbook setup_new_ubuntu_vm`

## Ansible Roles

- sudo
- base_setup
- install_python
- gnome_customization
- hostonly_interface

# Network Setup

VM Setup assumes two network interfaces

- Two interfaces
    1. Nat
        - DHCP
    2. Host only 
        - Ansible configured
        - Static IP, DNS, Gateway
        - Hypervisor Dependent

# libvert VM setup

Physical system only

- libvert
    - Install TPM
    - Download windows image

- https://www.reddit.com/r/kvm/comments/ri0db6/virt_manager_windows_vm_only_800_x_600_resolution/

- https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md


