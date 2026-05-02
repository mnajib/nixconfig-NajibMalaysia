{ config, pkgs, ... }:

#
# Check the service status
#   sudo systemctl list-units "immich*"
#
# Test if the immich service running
#   curl -I http://127.0.0.1:2283
#
# Open from web browser
#   http://immich.localdomain
#

let
  # 1. Path Definitions from your sketch
  #
  # High-speed ZFS for Database/Cache
  baseStateDir = "/MyTank/services/immich";
  #
  # The managed library for new uploads
  uploadDir    = "/MyTank/services/immich/photos/upload";
  #
  # The legacy archive (External Library)
  #monitorDir   = "/mnt/data/nfs/share/DATA/11 Else/MediaArchive";
  #
  # External storage path (OUTSIDE the baseStateDir)
  externalRoot = "/MyTank/services/immich-external";
  monitorPath  = "${externalRoot}/monitor";
  #
  # NFS source
  nfsSource    = "/mnt/data/nfs/share/DATA/11 Else/MediaArchive";

  immichUser = "immich";
  immichGroup = "immich";
  #immichUid = 999;
  #immichGid = 999;

  # Database
  #
  # Because your Immich service is running as the Linux user
  # immich, it can log into the PostgreSQL database named
  # immich without needing a password because the names match.
  #   sudo -u immich psql -d immich
  #
  #dbHost = "";
  #dbPort = "";
  #dbName = "";
  #dbUser = "";
  #dbPass = "";

  # immich service host/domain name
  domain = "immich.localdomain";
  # immich web interface URL
  externalUrl = "http://${domain}";

in {
  # 2. Filesystem Persistence
  # Ensure the bind mount for the legacy archive is defined
  #fileSystems."/MyTank/services/immich/photos/monitor" = {
  #fileSystems."${baseStateDir}/photos/monitor" = {
  fileSystems."${monitorPath}" = {
    device = nfsSource; #monitorDir;
    fsType = "none";
    options = [ "bind" "ro" ]; # 'ro' for safety as an external library
  };

  # 3. Directory Initialization
  # Creates the directory skeleton before the service starts
  # Ensures ZFS paths exist with corroct ownership
  systemd.tmpfiles.rules = [
    "d ${baseStateDir} 0750 ${immichUser} ${immichGroup} -"
    "d ${uploadDir} 0750 ${immichUser} ${immichGroup} -"
    #"d ${baseStateDir}/photos/monitor 0750 ${immichUser} ${immichGroup} -"
    "d ${externalRoot} 0750 ${immichUser} ${immichGroup} -"
    "d ${monitorPath} 0750 ${immichUser} ${immichGroup} -"
  ];

  # 4. Immich Service Configuration
  services.immich = {
    enable = true;
    #host = "0.0.0.0"; # Accessibility for family devices
    host = "127.0.0.1"; # Listen locally since Nginx is the public face
    port = 2283;
    openFirewall = true;

    # Core data location mapped to your ZFS state dataset
    mediaLocation = baseStateDir;

    # Built-in DB management
    database.enable = true;

    # AI/Machine Learning components
    machine-learning.enable = true;

    settings = {
      server = {
        #externalDomain = "http://immich.localdomain";
        externalDomain = externalUrl;
      };
    };
  };

  services.nginx.virtualHosts."immich.localdomain" = {
  #services.nginx.virtualHosts."${domain}" = {
    addSSL = false; # Set to true if set up Let's Encrypt later
    locations."/" = {
      proxyPass = "http://127.0.0.1:2283";
      proxyWebsockets = true; # Critical for real-time updates

      #proxyPass = "http://unix:/run/immich/immich.sock";

      # Recommended for large photo uploads
      extraConfig = ''
        client_max_body_size 50000M;
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
        send_timeout 600s;
      '';
    };
  };

  # 5. Infrastructure Integration
  networking.firewall.allowedTCPPorts = [
    #2283 # Not needed because immich now serve behind nginx
    80 443 # nginx
  ];

  environment.systemPackages = [ pkgs.immich-cli ];

  # Grant service access to your user-owned files on NFS
  users.users.immich.extraGroups = [ "users" ];
}
