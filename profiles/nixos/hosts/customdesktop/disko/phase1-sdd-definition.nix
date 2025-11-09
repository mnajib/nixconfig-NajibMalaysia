#
# This file can be call by
#   - directly disko CLI ( !!! and it will do ... !!!).
#   or
#   - by host profile, and will activate when do 'nixos-rebuild', ... (that wil not ..., but only ...)
#

{ lib }:

{
  disk."A16T" = {
    type = "disk";
    device = "/dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "512MiB";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        swap = {
          size = "16GiB";
          content = {
            type = "swap";
          };
        };
        zfs = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "Riyadh3";
          };
        };
      };
    };
  };

  zpool."Riyadh3" = {
    type = "zpool";
    mode = "single";
    options = { ashift = "12"; };
    rootFsOptions = {
      compression = "zstd";
      acltype = "posixacl";
      xattr = "sa";
      atime = "off";
      mountpoint = "legacy";
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
    };
  };
}

