# disko-config.nix

#
# To read more about disko:
#   https://github.com/nix-community/disko/blob/master/docs/quickstart.md
#
# To download the example config:
#   curl https://raw.githubusercontent.com/nix-community/disko/master/example/hybrid.nix -o /tmp/disko-config.nix
#
# To apply the config to the drive(s):
#   sudo nix \
#     --experimental-features "nix-command flakes" \
#     run github:nix-community/disko -- \
#     --mode disko /tmp/disko-config.nix
#
# To generate initial NixOS configuration
# but without config to mount the filesystems, because the filesystems is already configured (mount) by disko's nixosModule.
#
{
  #disko.devices = {

    #--------------------------------------------------------------------------
    #disk.sdh = {
    disk.GCNL = {
      #device = "/dev/sdh";
      device = "/dev/disk/by-id/ata-ST3500413AS_Z2ALGCNL";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {

          boot_bios = {
            size = "2M"; #"1M";
            #type = "bios_grub";
            type = "EF02"; # use MBR
          };

          boot_efi = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot1003"; # temp mountpoint. named to avoid conflict with existing /boot and /boot2, for now
              mountOptions = [ "umask=0077" ];
            };
          };

          swap = {
            size = "8G";
            type = "8200";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };

          zfs = {
            size = "100%";
            type = "bf01"; # Solaris /usr & Apple ZFS
            # Do not format here, ZFS will handle this
          };

        }; # End partitions = { ... };
      }; # End content = { ... };
    }; # End disk.GCNL = { ... };
    #--------------------------------------------------------------------------

  #}; # End disko.devices = { ... };
}

