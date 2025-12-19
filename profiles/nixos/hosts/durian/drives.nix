# profiles/nixos/hosts/customdesktop/drives.nix
rec {
  ## Riyadh drives
  #driveRiyadh1 = "ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0JD0ZC";
  #driveRiyadh2 = "ata-WDC_WD10SPCX-75KHST0_WXU1AA60XS04";
  #driveRiyadh3 = "ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T";

  ## Garden drives
  #driveGarden1 = "ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0WN54C";
  #driveGarden2 = "ata-WDC_WD10SPCX-75KHST0_WXA1AA61VDLL";
  #driveGarden3 = "ata-WDC_WD10SPZX-00Z10T0_WD-WXK2A80LH7PC";
  #driveGarden4 = "ata-TOSHIBA_DT01ACA1000_626YTCBQCT";
  #driveGarden5 = "ata-WDC_WD1002FB9YZ-09H1JL1_WD-WC81Y7821691";

  # Riyadh drives
  driveRiyadh1 = { type = "by-id";    value = "ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0JD0ZC"; };
  driveRiyadh2 = { type = "by-id";    value = "ata-WDC_WD10SPCX-75KHST0_WXU1AA60XS04"; };
  driveRiyadh3 = { type = "by-id";    value = "ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T"; };

  # Garden drives
  driveGarden1 = { type = "by-id";    value = "ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0WN54C"; };
  driveGarden2 = { type = "by-id";    value = "ata-WDC_WD10SPCX-75KHST0_WXA1AA61VDLL"; };
  driveGarden3 = { type = "by-id";    value = "ata-WDC_WD10SPZX-00Z10T0_WD-WXK2A80LH7PC"; };
  driveGarden4 = { type = "by-id";    value = "ata-TOSHIBA_DT01ACA1000_626YTCBQCT"; };
  driveGarden5 = { type = "by-id";    value = "ata-WDC_WD1002FB9YZ-09H1JL1_WD-WC81Y7821691"; };

  #driveTitan1 = { type = "by-uuid"; value = "..." };
  #driveTitan2 = { type = "by-uuid"; value = "..." };

  #swapRiyadh1 = { type = "by-uuid";   value = ""; };
  #swapRiyadh2 = { type = "by-uuid";   value = ""; };
  #swapRiyadh3 = { type = "by-uuid";   value = ""; };

  swapRiyadh1 = { type = "by-id"; value = "ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0JD0ZC-part1"; };
  swapRiyadh2 = { type = "by-id"; value = "ata-WDC_WD10SPCX-75KHST0_WXU1AA60XS04-part1"; };
  swapRiyadh3 = { type = "by-id"; value = "ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T-part4"; };

  #bootRiyadh1 = { type = "by-id"; value = "ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0JD0ZC-part1"; };
  #bootRiyadh2 = { type = "by-id"; value = "ata-WDC_WD10SPCX-75KHST0_WXU1AA60XS04-part1"; };
  #bootRiyadh3 = { type = "by-id"; value = "ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T-part2"; };

  # Grouped lists (referencing variables)
  # Usage example:
  #   map drivePath riyadhDrives
  # will returns a list of strings like:
  #   [
  #     "/dev/disk/by-id/ata-HUA722010CLA330_..."
  #     "/dev/disk/by-id/ata-WDC_WD10SPCX-..."
  #     "/dev/disk/by-id/ata-WDC_WD10EZEX-..."
  #   ]

  riyadhDrives = [
    driveRiyadh1
    driveRiyadh2
    driveRiyadh3
  ];

  gardenDrives = [
    driveGarden1
    driveGarden2
    driveGarden3
    driveGarden4
    driveGarden5
  ];

  #
  # Helper to resolve full path
  #
  # Example usage:
  #   drivePath driveRiyadh3
  #
  #drivePath = name: "/dev/disk/by-id/${name}";
  drivePath = drv:
    "/dev/disk/${drv.type}/${drv.value}";

  #
  # REPL-friendly helper: resolve a list of drives to full paths
  #
  # Usage example:
  #   nix repl
  #   > lf ./profiles/nixos/hosts/customdesktop/drives.nix
  #   > resolveDrives riyadhDrives
  #   > drivePath driveRiyadh2
  #
  # drives group
  resolveDrives = driveList: map drivePath driveList;
}

