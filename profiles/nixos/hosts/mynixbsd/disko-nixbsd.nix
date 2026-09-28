# File: profiles/nixos/hosts/mynixbsd/disko-nixbsd.nix
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda"; # Salar mengikut cakera sasaran anda
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # BIOS boot partition untuk MBR/GRUB compatibility
            };
            ESP = {
              name = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "fmask=0077" "dmask=0077" ];
              };
            };
            swap = {
              name = "swap";
              size = "8G";
              type = "516E7CB1-6ECF-11D6-8FF8-00022D09712B"; # FreeBSD swap partition GUID
              content = {
                type = "swap";
                discardPolicy = "both";
              };
            };
            root = {
              name = "root";
              size = "100%";
              type = "516E7CB4-6ECF-11D6-8FF8-00022D09712B"; # FreeBSD UFS partition GUID
              content = {
                type = "filesystem";
                format = "ufs";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
