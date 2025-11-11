# disko-config.nix
#
# -------------------------------------
# Prepare: Clear the drive
# -------------------------------------
#
# To zap GPT and MBR data:
#   sudo sgdisk --zap-all /dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T
#
# To wipe filesystem signatures:
# This will Zaps everything: GPT headers, partition table, backup GPT, and PMBR.
# Leaves the disk in a completely unpartitioned state.
# But does not overwrite filesystem data (use wipefs or dd for that).
# Use when you want to remove traces of old filesystems but keep the partition layout.
# Useful before reformatting partitions without repartitioning the disk.
#   sudo wipefs -a /dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T
#
# To zero out first few MBs (optional)
#   sudo dd if=/dev/zero of=/dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T bs=1M count=10
#
# To Clears the GPT partition table, (optional)
# but leaves the protective MBR (PMBR) intact,
# and does not wipe filesystem signatures or backup GPT headers.
#   sudo sgdisk --clear /dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T
#
# List
#  sudo gdisk -l /dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T
#
# -------------------------------------
# Format
# -------------------------------------
# To run disko
#   sudo nix run github:nix-community/disko -- --help
#   sudo nix run github:nix-community/disko -- --mode destroy --dry-run ./profiles/nixos/hosts/customdesktop/disko/phase1-drives-wrapper-diskoCLI.nix
#   sudo nix run github:nix-community/disko -- --mode destroy ./profiles/nixos/hosts/customdesktop/disko/phase1-drives-wrapper-diskoCLI.nix
#   sudo nix run github:nix-community/disko -- --mode format --dry-run ./profiles/nixos/hosts/customdesktop/disko/phase1-drives-wrapper-diskoCLI.nix
#   sudo nix run github:nix-community/disko -- --mode format ./profiles/nixos/hosts/customdesktop/disko/phase1-drives-wrapper-diskoCLI.nix
#
# -------------------------------------
# Create temporary bootable pool on /dev/sdd5 (Riyadh2)
# -------------------------------------
# sudo zpool create -f Riyadh2 /dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T-part5
# sudo zfs create -o mountpoint=legacy Riyadh2/nixos-root
# sudo zfs create -o mountpoint=legacy Riyadh2/nixos-nix
# sudo zfs create -o mountpoint=legacy Riyadh2/nixos-home
# sudo zfs create -o mountpoint=legacy Riyadh2/nixos-rootuser
#
#
# 2025-11-09
# This file can be call by
#   - directly disko CLI ( !!! and it will do ... !!!).
#     sudo nix run github:nix-community/disko -- --mode disko ./profiles/nixos/hosts/customdesktop/disko/phase1-drives-wrapper-diskoCLI.nix
#   or
#   - by host profile, and will activate when do 'nixos-rebuild', ... (that wil not ..., but only ...)
#
#
{ lib }:
{
  #--------------------------------------------------------------------------
  # NOTE:
  #--------------------------------------------------------------------------
  # [2025-11-11 10:44:08] [najib@customdesktop:~/src/nixconfig-NajibMalaysia]$ sudo gdisk -l /dev/sde
  # Number  Start (sector)    End (sector)  Size       Code  Name
  #    1            2048            4095   1024.0 KiB  EF02  disk-A16T-biosboot
  #    2            4096         4198399   2.0 GiB     8300  disk-A16T-bootpart
  #    3         4198400         6295551   1024.0 MiB  EF00  disk-A16T-esp
  #    4         6295552        39849983   16.0 GiB    8200  disk-A16T-swap
  #    5        39849984      1953523711   912.5 GiB   BF01  disk-A16T-zfs
  #-------------------------------------------------------------------------
  #disk.sdh = {
  disk."A16T" = { # the name here will also be use in partitions name ("disk-A16T-biosboot", "disk-A16T-bootpart", "disk-A16T-esp", ...)
  #disk."ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T" = {
    device = "/dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T";
    type = "disk";
    #wipe = true; # To ensure it clears the disk before formatting
    content = {
      type = "gpt";
      partitions = {

        #--------------------------------------------------------------------
        #"biosboot" = {
        "bios" = {
          size = "1M";
          #size = "1MiB";
          #type = "bios_grub";
          type = "EF02";
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
        #"bootpart" = { # The name here will also be use in partitions name
        "boot" = { # The name here will also be use in partitions name
          #start = espSize; end = "${espSize} + ${bootSize}";
          size = "2G";
          content = {
            type = "filesystem";
            format = "btrfs";
            ##mountpoint = "/boot-${lib.strings.sanitizeDerivationName device}";
            ##mountpoint = "/boot-ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T";
            #mountpoint = "/boot";
            ##mountpoint = "/boot1";
            ##mountpoint = "/boot2";
            mountOptions = [
              "noatime"
              #"compress=zstd"
              "compress=zstd" # Level 1 - falset compression
              "autodefrag" # Automatic defragmentation
              "space_cache=v2" # Better space traking
            ];
          };
        };

        #--------------------------------------------------------------------
        # For EFI firrmware boot files
        #   bootx64.efi
        #   grubx64.efi
        #   EFI boot manager entries
        #   Hardwaree-specific EFI apps
        # Will be accessed by: EFI firmware
        #"esp" = { # the name here will also be use in partitions name
        "efi" = { # the name here will also be use in partitions name
          size = "1G"; #"2G"; #"2GiB"; #"1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            ##mountpoint = "/boot1001"; # temp mountpoint. named to avoid conflict with existing /boot and /boot2, for now
            ##mountpoint = "/efi-ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T";
            #mountpoint = "/boot/efi";
            ##mountpoint = "/efi1";
            ##mountpoint = "/efi2";
          };
        };

        #--------------------------------------------------------------------
        "swap" = { # the name here will also be use in partitions name
          size = "16G";
          #size = "16GiB";
          #type = "8200";
          content = {
            type = "swap";
            resumeDevice = true;
          };
        };

        #--------------------------------------------------------------------
        "zfs" = { # the name here will also be use in partitions name
          size = "100%";
          type = "bf01"; # Solaris /usr & Apple ZFS

          # Lets only create the partition here — no 'pool' property
          #
          # OR
          #
          content = {
            type = "zfs";
            pool = "Riyadh2"; # Name of the ZFS pool
            #mountpoint = "none"; # XXX: ???
          };
          #
          # OR
          #
          # Do not format here, ZFS will handle this
        };

        #--------------------------------------------------------------------
      };
    };
  };
  #--------------------------------------------------------------------------

  zpool."Riyadh2" = {
    type = "zpool";
    mode = "";
    #mode = "mirror";
    #mode = "raidz2";
    options = { ashift = "12"; };
    rootFsOptions = {
      compression = "zstd";
      acltype = "posixacl";
      xattr = "sa";
      atime = "off";
      mountpoint = "legacy";
    };

    # Explicitly use the /dev/disk/by-id path for your partition
    # NOTE: Disko will number partitions in the order you define them (above).
    #devices = [
    #  "/dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T-part5"
    #];

    datasets = {
      #root = {
      nixos = {
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

