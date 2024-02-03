To export a pool:
  zpool export myPool1

To import a pool:
  zpool import myPool1

To make new disk as hot-spare for myPool:
  zpool add myPool1 spare myDisk7
  ...

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

