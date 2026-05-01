{ config, pkgs, ... }:

let
  # 1. Path Definitions from your sketch
  # High-speed ZFS for Database/Cache
  baseStateDir = "/MyTank/services/immich";

  # The managed library for new uploads
  uploadDir    = "/MyTank/services/immich/photos/upload";

  # The legacy archive (External Library)
  monitorDir   = "/mnt/data/nfs/share/DATA/11 Else/MediaArchive";

in {
  # 2. Filesystem Persistence
  # Ensure the bind mount for the legacy archive is defined
  fileSystems."/MyTank/services/immich/photos/monitor" = {
    device = monitorDir;
    fsType = "none";
    options = [ "bind" "ro" ]; # 'ro' for safety as an external library
  };

  # 3. Directory Initialization
  # Creates the directory skeleton before the service starts
  systemd.tmpfiles.rules = [
    "d ${baseStateDir} 0750 immich immich -"
    "d ${uploadDir} 0750 immich immich -"
    "d ${baseStateDir}/photos/monitor 0750 immich immich -"
  ];

  # 4. Immich Service Configuration
  services.immich = {
    enable = true;
    host = "0.0.0.0"; # Accessibility for family devices
    port = 2283;

    # Core data location mapped to your ZFS state dataset
    mediaLocation = baseStateDir;

    # Built-in DB management
    database.enable = true;

    # AI/Machine Learning components
    machine-learning.enable = true;
  };

  # 5. Infrastructure Integration
  networking.firewall.allowedTCPPorts = [ 2283 ];
  environment.systemPackages = [ pkgs.immich-cli ];

  # Grant service access to your user-owned files on NFS
  users.users.immich.extraGroups = [ "users" ];
}
