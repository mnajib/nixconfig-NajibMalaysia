{ lib, ... }:
let
  libdisk = import ../../../../modules/disko/lib-disk.nix { inherit lib; };
in {
  disko.devices = {

    disk.sdb = libdisk.mkBare {
      device = "/dev/disk/by-id/ata-WDC_WD10SPCX-75KHST0_WXU1AA60XS04";
      swapSize = "16GiB";
      bootSize = "2GiB";
      espSize = "512MiB";
    };

    disk.sdf = libdisk.mkBare {
      device = "/dev/disk/by-id/ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0JD0ZC";
      swapSize = "16GiB";
      bootSize = "2GiB";
      espSize = "512MiB";
    };

  };
}

