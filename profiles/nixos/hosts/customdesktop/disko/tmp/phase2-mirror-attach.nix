#
# Run:
#   sudo nix run github:nix-community/disko -- --mode disko ./phase2-mirror-attach.nix
#
# This will partition the disks — but won’t attach them to the pool. You do that manually:
#   sudo zpool attach Riyadh3 \
#     /dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T \
#     /dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJB17T
#
#   sudo zpool attach Riyadh3 \
#     /dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T \
#     /dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJC18T


{ lib }:

{
  disk."B17T" = {
    type = "disk";
    device = "/dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJB17T";
    content = {
      type = "gpt";
      partitions = {
        zfs = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "Riyadh3";
            # This will be ignored by Disko CLI — you’ll attach manually
          };
        };
      };
    };
  };

  disk."C18T" = {
    type = "disk";
    device = "/dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJC18T";
    content = {
      type = "gpt";
      partitions = {
        zfs = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "Riyadh3";
          };
        };
      };
    };
  };
}

