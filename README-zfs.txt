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
