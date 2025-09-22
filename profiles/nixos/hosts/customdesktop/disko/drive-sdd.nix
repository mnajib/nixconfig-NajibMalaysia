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
# To run disko (.../partition/format/...)
#   sudo nix run github:nix-community/disko -- --mode format ./profiles/nixos/hosts/customdesktop/disko/drive-sdd.nix
#
{
  disko.devices = {

    #--------------------------------------------------------------------------
    #disk.sdh = {
    disk."A16T" = { # the name here will also be use in partitions name
      #device = "/dev/sdh";
      device = "/dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T";
      type = "disk";
      #wipe = true; # To ensure it clears the disk before formatting
      content = {
        type = "gpt";
        partitions = {

          boot_bios = {
            size = "1M";
            #size = "1MiB";
            #type = "bios_grub";
            type = "EF02";
          };

          boot_efi = {
            size = "2G"; #"2GiB"; #"1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot1001"; # temp mountpoint. named to avoid conflict with existing /boot and /boot2, for now
            };
          };

          swap = {
            size = "16G";
            #size = "16GiB";
            #type = "8200";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };

          zfs = {
            size = "100%";
            type = "bf01"; # Solaris /usr & Apple ZFS

            #
            content = {
              type = "zfs";
              pool = "Riyadh2"; # Name of the ZFS pool
            };
            # OR
            # Do not format here, ZFS will handle this
          };

        };
      };
    };
    #--------------------------------------------------------------------------

  }; # End disko.devices = { ... };
}

