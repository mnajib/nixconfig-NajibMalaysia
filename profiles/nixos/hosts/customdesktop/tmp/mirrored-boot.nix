{ config, lib, ... }:
{
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    zfsSupport = true;

    devices = [
      "/dev/disk/by-id/ata-WDC_WD10SPCX-75KHST0_WXU1AA60XS04"
      "/dev/disk/by-id/ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0JD0ZC"
      "/dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T"
    ];

    mirroredBoots = [
      { path = "/boot-sdb"; devices = [ "/dev/disk/by-id/ata-WDC_WD10SPCX-75KHST0_WXU1AA60XS04" ]; }
      { path = "/boot-sdf"; devices = [ "/dev/disk/by-id/ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0JD0ZC" ]; }
      { path = "/boot-sdd"; devices = [ "/dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T" ]; }
    ];
  };

  boot.supportedFilesystems = [ "zfs" "btrfs" "vfat" ];
}

