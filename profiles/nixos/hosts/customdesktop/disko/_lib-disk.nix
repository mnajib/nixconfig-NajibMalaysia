# Reusable GPT layout for one disk
{ lib, ... }:
let
  mkDisk = {
    device,
    efiMount,
    bootMount,
    makeZfs ? false,
    poolName ? "Riyadh3",
    #format ? "true",
    swapSize ? "16GiB",
    bootSize ? "2GiB",
    espSize ? "512MiB",
  }:
    {
      type = "disk";
      inherit device;
      content = {
        type = "gpt";
        partitions = [

          # 1 MiB BIOS boot gap for GRUB core.img
          { name = "bios-boot"; start = "1MiB"; end = "2MiB"; type = "EF02"; }

          # 512 MiB UEFI ESP
          {
            name = "esp"; start = "2MiB"; end = "514MiB"; type = "EF00";
            content = {
              type = "filesystem"; format = "vfat";
              mountpoint = efiMount; mountOptions = [ "umask=0077" ];
            };
          }

          # 2 GiB /boot (Btrfs)
          {
            name = "boot"; start = "514MiB"; end = "2562MiB";
            content = {
              type = "filesystem"; format = "btrfs";
              mountpoint = bootMount; mountOptions = [ "noatime" "compress=zstd" ];
            };
          }

          # 16 GiB swap
          {
            name = "swap"; start = "2562MiB"; end = "18962MiB";
            content = { type = "swap"; };
          }

          # ZFS root
          (
            if makeZfs then
              {
                name = "zfs"; start = "18962MiB"; end = "100%";
                content = { type = "zfs"; pool = poolName; };
              }
            else
              {
                name = "zfs"; start = "18962MiB"; end = "100%";
                # leave empty; we'll zpool attach this later
              }
          )

        ];
      };
    };
in {
  options.diskoLib.mkDisk = lib.mkOption {
    type = lib.types.anything;
    default = mkDisk;
    description = "Function to create the standard GPT+ESP+BIOS+/boot+swap+ZFS layout.";
  };
}

