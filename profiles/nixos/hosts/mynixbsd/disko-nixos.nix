# File: hosts/mynixhost/disko-current.nix
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda"; # Ubah ke /dev/nvme0n1 jika menggunakan SSD NVMe
        content = {
          type = "gpt";
          partitions = {
            # Partition Boot / MBR / ESP jika wujud
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "fmask=0077" "dmask=0077" ];
              };
            };
            # Partition Root berdasarkan hardware-configuration.nix
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            # Partition Swap berdasarkan hardware-configuration.nix
            swap = {
              size = "8G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
          };
        };
      };
    };
  };
}
