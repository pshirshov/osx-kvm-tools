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

Edit `/etc/fstab` (`btrfs` with `user_subvol_rm_allowed` is essential for docker):

```
UUID=xxx		/		btrfs		defaults,discard,autodefrag,noatime,user_subvol_rm_allowed	0 0
192.168.1.100:/Users/user /mnt/home-user nfs defaults,bg,retry=3600,noauto,x-systemd.automount 0 0
UUID=xxx		/boot		vfat		noauto	0 0
```

Edit `/etc/exports` on your macOS guest:

```
/Users/user -mapall=user:staff 192.168.1.99
```

Install `supervisord` from `brew` and edit `/usr/local/etc/supervisor.d/docker.ini`:

```
[program:dockerfw]
command=/bin/bash /Users/user/Documents/forwardall
stopsignal=KILL
killasgroup=true
stdout_logfile=/tmp/dockerfw.out.log        ; stdout log path, NONE for none; default AUTO
stdout_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
stdout_logfile_backups=10     ; # of stdout logfile backups (0 means none, default 10)
stdout_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
stdout_events_enabled=false   ; emit events on stdout writes (default false)
stdout_syslog=false           ; send stdout to syslog with process name (default false)
stderr_logfile=/tmp/dockerfw.err.log        ; stderr log path, NONE for none; default AUTO
stderr_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
stderr_logfile_backups=10     ; # of stderr logfile backups (0 means none, default 10)
stderr_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
stderr_events_enabled=false   ; emit events on stderr writes (default false)
stderr_syslog=false           ; send stderr to syslog with process name (default false)
```

Put `guest/forwardall` into `~/Documents/`

Use `conf/lxc-docker.yaml` as to run docker in lxc:

```
lxc launch ubuntu:18.04 docker < lxc-docker.yaml
```

Install `docker-machine` from brew then use `./hack docker-reset` to setup your guest.