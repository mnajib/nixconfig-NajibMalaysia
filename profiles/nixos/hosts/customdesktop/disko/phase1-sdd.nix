# Phase 1: build a NEW pool (single disk) on sdd, ready for data migration
{ lib, ... }: let
  #libdisk = import ./_lib-disk.nix { inherit lib;  };
  diskoLib = import ../../../../../modules/disko/lib-disk.nix { inherit lib;  };
in {
  disko.devices = {
    #disk.sdd = libdisk.mkDisk {
    #disk.sdd = diskoLib.mkDiskZfs {
    disk."A16T" = diskoLib.mkDiskZfs {
      device = "/dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T";
      #type = "disk";
      #efiMount  = "/boot/efi-sdd";
      #bootMount = "/boot-sdd";
      #makeZfs = true;      # create the pool here
      format = true;
      poolName = "Riyadh3";# temporary name during migration
      swapSize = "16GiB";
      bootSize = "2GiB";
      espSize = "512MiB";
    };

    # Create the pool (single vdev for now). We'll send/recv data into it,
    # then later convert to a 3-way mirror by zpool attach.
    zpool."Riyadh3" = {
      type = "zpool";
      mode = "single";   # single device vdev
      options = { ashift = "12"; };   # good default for 4k
      rootFsOptions = {
        compression = "zstd";
        acltype = "posixacl";
        xattr = "sa";
        atime = "off";
        mountpoint = "legacy"; #"none";
      };
      datasets = {

        root = {
          type = "zfs_fs";
          options.mountpoint = "/";
        };
        nix = {
          type = "zfs_fs";
          options.mountpoint = "/nix";
        };
        home = {
          type = "zfs_fs";
          options.mountpoint = "/home";
        };

      };  # we will replicate (backup copy; send recieve) datasets from the old pool
    };
  };
}

# Run it (DOUBLE-CHECK the by-id first!):
#   sudo nix run github:nix-community/disko -- --mode disko ./profiles/nixos/hosts/customdesktop/disko/phase1-sdd.nix

