#
# This file can be call by
#   - directly disko CLI ( !!! and it will do ... !!!).
#     sudo nix run github:nix-community/disko -- --mode disko ./profiles/nixos/hosts/customdesktop/disko/phase1-sdd-standalone.nix
#     sudo nix run github:nix-community/disko -- --mode disko ./phase1-sdd-standalone.nix
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
            #mountpoint = "/boot";
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
            pool = "Riyadh2";
          };
        };
      };
    };
  };

  zpool."Riyadh2" = {
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
        #options.mountpoint = "/";
        options.mountpoint = "legacy";
      };
      nix = {
        type = "zfs_fs";
        #options.mountpoint = "/nix";
        options.mountpoint = "legacy";
      };
      home = {
        type = "zfs_fs";
        #options.mountpoint = "/home";
        options.mountpoint = "legacy";
      };
      rootuser = {
        type = "zfs_fs";
        #options.mountpoint = "/root";
        options.mountpoint = "legacy";
      };
      persist = {
        type = "zfs_fs";
        #options.mountpoint = "/persist";
        options.mountpoint = "legacy";
      };
    };
  };
}

