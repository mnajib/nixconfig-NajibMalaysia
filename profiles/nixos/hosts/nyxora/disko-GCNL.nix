# disko-config.nix
{
  disko.devices = {

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
            size = "1M";
            type = "bios_grub";
          };
          boot_efi = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot3"; # temp mountpoint. named to avoid conflict with existing /boot and /boot2, for now
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
        };
      };
    };
    #--------------------------------------------------------------------------

  }; # End disko.devices = { ... };
}

