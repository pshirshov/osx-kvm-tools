grub
====

```
GRUB_CMDLINE_LINUX="mitigations=off iommu=pt amd_iommu=on"
```

or

```
GRUB_CMDLINE_LINUX="mitigations=off iommu=pt amd_iommu=on isolcpus=8-31,40-63"
```


docker
======

Let's assume that our guest has address `192.168.1.100` and vm host has address `192.168.1.99`.

1. On your VM host edit `/etc/fstab`

```
UUID=xxx		/		btrfs		defaults,discard,autodefrag,noatime,user_subvol_rm_allowed	0 0
192.168.1.100:/Users/user /mnt/home-user nfs defaults,bg,retry=3600,noauto,x-systemd.automount 0 0
192.168.1.100:/private/var/folders /mnt/var-folders nfs defaults,bg,retry=3600,noauto,x-systemd.automount 0 0
```

Notes:
- `btrfs` with `user_subvol_rm_allowed` is essential for docker
- Depending on your workflow you may wish to expose other host directories

2. Generate a MAC address (let's say it's `aa:bb:cc:dd:ee:ff`). You may want to use your DHCP to bind that MAC address to a domain name and/or static IP

### On your guest

1. Edit `/etc/exports`:

```
/Users/user -mapall=user:staff 192.168.1.99
/private/var/folders -mapall=root:staff 192.168.10.69
```

1. Run `nfsd checkexports && sudo nfsd update`
3. Install `supervisord` from `brew`, use `brew services` to enable it
4. Put your public key under `~/.ssh/id_rsa.pub`, make sure `root` user can login onto your VM host with this key without password
5. Create `~/Documents/hackintosh.docker.sh` with content like:

```
export MAC_VM_HOST=host-name
export MAC_VM_GUEST=guest-name
export MAC_VM_GUEST_USER=user
export MAC_VM_DOCKER=docker-name
export MAC_VM_DOCKER_MACADDR="aa:bb:cc:dd:ee:ff"

if [[ $(hostname) == "${MAC_VM_GUEST}" ]]; then
  export DOCKER_TLS_VERIFY="1"
  export DOCKER_HOST="tcp://${MAC_VM_DOCKER}:2376"
  export DOCKER_CERT_PATH="$HOME/.docker/machine/machines/default"
  export DOCKER_MACHINE_NAME="default"
  #eval "$(docker-machine env default)"
fi
```

6. Install `brew install docker docker-machine && brew link docker`  then use `./hack docker-reset` to setup your guest.
