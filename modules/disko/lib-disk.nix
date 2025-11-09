# modules/disko/lib-disk.nix
{ lib, ... }:
let
  mkDiskCommon = {
    device,
    espSize ? "1GiB",#"512MiB", # Considider "1GiB" extra space for multiple OS
    bootSize ? "2GiB", # "2GiB" big space for multiple kernels
    swapSize ? "16GiB"
  }: {
    inherit device;
    type = "disk";
    content = {
      type = "gpt";

      #partitions = ]
      partitions = {

        #----------------------------------------------------------------------
        #
        #{
        #   name = "bios-boot";
        "bios-boot" = {
          #start = "1MiB"; end = "2MiB";
          size = "1MiB"; #"1M";
          type = "EF02"; # BIOS GRUB MBR
        };

        #----------------------------------------------------------------------
        # For EFI firrmware boot files
        #   bootx64.efi
        #   grubx64.efi
        #   EFI boot manager entries
        #   Hardwaree-specific EFI apps
        # Will be accessed by: EFI firmware
        "ESP" = {
          #start = "2MiB"; end = espSize;
          size = espSize;
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat"; # EFI requirement: must be FAT32
            mountpoint = "/boot/efi-${lib.strings.sanitizeDerivationName device}";
          };
        };

        #----------------------------------------------------------------------
        # For kernel, initrd, bootloader config
        #   vmlinuz-<version> (kernels)
        #   initrd.img-<version>
        #   grub.cfg
        #   System.map
        #   Boot assets & themes
        # I give it generously 2GiB for multiple kernels
        # Will be accessed by Linux bootloader & OS
        "boot-partition" = {
          #start = espSize; end = "${espSize} + ${bootSize}";
          size = bootSize;
          content = {
            type = "filesystem";
            format = "btrfs";
            mountpoint = "/boot-${lib.strings.sanitizeDerivationName device}";
            mountOptions = [
              "noatime"
              #"compress=zstd"
              "compress=zstd" # Level 1 - falset compression
              "autodefrag" # Automatic defragmentation
              "space_cache=v2" # Better space traking
            ];
          };
        };

        #----------------------------------------------------------------------
        "swap" = {
          #start = "${espSize} + ${bootSize}";
          #end = "${espSize} + ${bootSize} + ${swapSize}";
          size = swapSize;
          content = { type = "swap"; };
        };

        #----------------------------------------------------------------------
      #];
      };

    };
  };

  # ──────────────────────────────
  # Bare (no formatting of last partition)
  mkDiskBare = {
    device,
    swapSize ? "16GiB",
    bootSize ? "2GiB",
    espSize ? "512MiB",
  }:
    let
      base = mkDiskCommon { inherit device swapSize bootSize espSize; };
    in base // {
      #content.partitions = base.content.partitions ++ [
      content.partitions = base.content.partitions // {
        "myblank" = {
          #name = "data";
          #start = "${espSize} + ${bootSize} + ${swapSize}";
          #end = "100%";
          size = "100%";
          # no "content" → left unformatted
        };
      #];
      };
    };

  # ──────────────────────────────
  # ZFS variant
  mkDiskZfs = {
    device,
    poolName ? "zpool0",
    format ? true,
    swapSize ? "16GiB",
    bootSize ? "2GiB",
    espSize ? "512MiB",
  }:
    let
      base = mkDiskCommon { inherit device swapSize bootSize espSize; };
      zfsPartition = if format then {
        name = "zfs";
        type = "bf01"; # Solaris / usr & Apple ZFS
        #start = "${espSize} + ${bootSize} + ${swapSize}";
        #end = "100%";
        size = "100%";
        content = {
          type = "zfs";
          pool = poolName;
        };
      } else {
        name = "zfs";
        type = "bf01"; # Solaris / usr & Apple ZFS
        #start = "${espSize} + ${bootSize} + ${swapSize}";
        #end = "100%";
        size = "100%";
        # but left it (the partition) blank; only create the partition, but not format it etc.
      };
    #in base // { content.partitions = base.content.partitions ++ [ zfsPartition ]; };
    in base // {
        content.partitions = base.content.partitions // {
          #"myzfs" = zfsPartition;
          "zfs" = zfsPartition;
        };
      };

  # ──────────────────────────────
  # Btrfs variant
  mkDiskBtrfs = {
    device,
    mountpoint ? "/",
    subvolumes ? {},
    swapSize ? "16GiB",
    bootSize ? "2GiB",
    espSize ? "512MiB",
  }:
    let
      base = mkDiskCommon { inherit device swapSize bootSize espSize; };
    in base // {
      #content.partitions = base.content.partitions ++ [
      content.partitions = base.content.partitions // {
        #{
        "mybtrfs" = {
          name = "btrfs";
          #start = "${espSize} + ${bootSize} + ${swapSize}";
          #end = "100%";
          size = "100%";
          content = {
            type = "filesystem";
            format = "btrfs";
            inherit mountpoint;
            subvolumes = subvolumes;
            mountOptions = [ "noatime" "compress=zstd" ];
          };
        };
      #];
      };
    };

in {
  inherit mkDiskBare mkDiskZfs mkDiskBtrfs;
}

