# File: /etc/nixos/modules/disko-sdcard.nix
#
# Wipe, partition, format, and mount the MicroSD card via Disko using the declarative layout:
#   sudo nix run github:nix-community/disko -- --mode disko disko-sdcard.nix
#
# Confirm that the partitions are correctly mounted to /mnt and /mnt/boot:
#   lsblk -pf /dev/sdf
#
# Run the generation command to capture the exact Disko-created partition UUIDs into your target host folder:
#   sudo mkdir -p /mnt/etc/nixos/hosts
#   sudo nixos-generate-config --root /mnt --no-filesystems
#

{
  disko.devices = {
    disk = {
      sdcard = {
        # Fact: Uses stable disk-by-id path instead of volatile /dev/sdf
        device = "/dev/disk/by-id/usb-Generic_STORAGE_DEVICE_000000000563-0:4";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # Fact: Raspberry Pi bootloader requires a dedicated FAT32 boot partition
            boot = {
              size = "512M";
              type = "EF00"; # EFI System / Boot
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            # Fact: Primary NixOS root partition taking the remaining card capacity
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                # Suggestion: noatime prevents unnecessary write cycles to extend SD card lifespan
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
    };
  };
}
