# File: profiles/nixos/hosts/mynixbsd/disko-nixbsd.nix
{
  # Disable automatic NixOS bootloader/fstab generation for NixBSD compatibility
  disko.enableConfig = false;

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda"; # Salar mengikut cakera sasaran anda
        content = {
          type = "table";
          format = "msdos";
          partitions = [
            {
              name = "swap";
              start = "1MiB";
              end = "8GiB";
              content = {
                type = "swap";
                resumeDevice = false;
              };
            }
            {
              name = "root";
              start = "8GiB";
              end = "100%";
              content = {
                type = "filesystem";
                format = "ufs";
                mountpoint = "/";
              };
            }
          ];
        };
      };
    };
  };
}
