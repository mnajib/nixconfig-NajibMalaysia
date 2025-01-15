zpool create -o compatibility=grub2 -m none myPool1 /dev/disk/by-id/myDisk1
#zpool create -o compatibility=grub2 -m none myPool1 /dev/disk/by-partlabel/myDisk1
#zpool create -o compatibility=grub2 -m none myPool1 /dev/disk/by-partuuid/myDisk1
zpool get compatibility myPool1

#XXX: grub2 not support zfs encryption
#zfs create -o mountpoint=none -o encryption=on -o keylocation=prompt -o keyformat=passphrase -O compression=on myPool1/a
zfs create -o mountpoint=none -O compression=on myPool1/a

zfs create -o mountpoint=legacy myPool1/a/nixos
zfs create -o mountpoint=legacy myPool1/a/home
zfs get encryption,compression,mountpoint myPool1/a myPool1/a/nixos myPool1/a/home

zpool list -v myPool1
zpool status -v myPool1

---------------------------------------------------

To export a pool:
  zpool export myPool1

To import a pool:
  zpool import myPool1
  zpool import all

To make new disk as hot-spare for myPool:
  zpool add myPool1 spare myDisk7
  zpool set autoreplace=on myPool1
  zpool get all myPool1

To remove a disk from hot-spare:
  zpool remove myPool1 myDisk7

To share a hot-spare disk to another/multiple pool:
  zpool add myPool2 spare myDisk7
  zpool add myPool3 spare myDisk7 myDisk8
  zpool add myPool4 spare myDisk7 myDisk8

---------------------------------------------------

zpool detach myPool5 myDisk9
zpool clearlabel myDisk9
cryptsetup close /dev/mapper/...

-------------------------------------------------------------------------------
 expand vdev size?
-------------------------------------------------------------------------------
[root@timestandstill ~]# zpool list
NAME          SIZE  ALLOC   FREE    CAP  DEDUP  HEALTH  ALTROOT
dfbackup      214G   207G  7.49G    96%  1.00x  ONLINE  -
[root@timestandstill ~]# zpool get autoexpand
NAME         PROPERTY    VALUE   SOURCE
dfbackup     autoexpand  on      local
[root@timestandstill ~]# zpool set autoexpand=off dfbackup
[root@timestandstill ~]# zpool online -e dfbackup /dev/disk/by-id/virtio-sbs-XLPH83
[root@timestandstill ~]# zpool list
NAME          SIZE  ALLOC   FREE    CAP  DEDUP  HEALTH  ALTROOT
dfbackup      249G   207G  42.5G    82%  1.00x  ONLINE  -
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
 Which drive is which?
-------------------------------------------------------------------------------
lsscsi
sudo fdisk -l /dev/sdc
lsblk -pif
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT

-------------------------------------------------------------------------------
