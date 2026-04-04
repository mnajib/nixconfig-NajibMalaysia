{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        #device = "/dev/nvme1n1"; # Adjust if your drive path is different
        device = "/dev/disk/by-id/nvme-Netac_NVMe_SSD_250GB_AA20251120250G076005";
        content = {
          type = "gpt";
          partitions = {

            # 1. Separate Boot Partition
            boot = {
              size = "2G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/boot";
              };
            };

            # 2. EFI Partition
            bootefi = {
              #size = "512M";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
                mountOptions = [ "umask=0077" ];
              };
            };

            # 3. Encrypted Main Partition
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                # passwordFile = "/tmp/secret.key"; # Optional: for automated installs
                settings.allowDiscards = true;
                content = {

                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Force overwrite
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "16G";
                    };
                  };

                };
              };
            };

          };
        };
      }; # End of disko.devices.disk.main = { ... }
    }; # End of disko.devices.disk = { ... }
  }; # End of disko.devices = { ... }
}
