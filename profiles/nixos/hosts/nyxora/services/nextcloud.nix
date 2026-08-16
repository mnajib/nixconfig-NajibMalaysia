{ config, pkgs, lib, ... }:

let

  #nextcloudDataDir = "/var/lib/nextcloud";        # Default
  #nextcloudDataDir = "/var/lib/nextcloud/data";  # Primary app data
  nextcloudDataDir = "/MyTank/services/nextcloud";        # Default

  #externalNfsMount = "/mnt/nfs-shared";           # External NFS payload
  #externalNfsMount = "/mnt/nfsshare2";           # External NFS payload

in
{
  # ---------------------------------------------------------------------------
  # 1. Primary Data Storage (ZFS)
  # ---------------------------------------------------------------------------
  boot.supportedFilesystems = [ "zfs" "nfs" ];

  # Local ZFS Dataset for Nextcloud's core application data
  # Replace 'rpool/data/nextcloud' with your actual pool/dataset path
  fileSystems."${nextcloudDataDir}" = {
    #device = "rpool/data/nextcloud";
    device = "MyTank/services/nextcloud";
    fsType = "zfs";
    options = [ "noatime" ];
  };

  # ---------------------------------------------------------------------------
  # 2. Existing External NFS Mount
  # ---------------------------------------------------------------------------
  # Mount the external NFS share to the NixOS host
  #fileSystems."${externalNfsMount}" = {
  #  device = "nfs.localdomain:/nfsshare2";
  #  fsType = "nfs";
  #  options = [
  #    "nfsvers=4.2"
  #    "rw"
  #    "hard"
  #    "intr"
  #    "noatime"
  #    "x-systemd.automount"
  #    "x-systemd.idle-timeout=60"
  #  ];
  #};

  # ---------------------------------------------------------------------------
  # 3. Database (PostgreSQL)
  # ---------------------------------------------------------------------------
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };

  # ---------------------------------------------------------------------------
  # 4. Nextcloud Service Configuration
  # ---------------------------------------------------------------------------
  environment.etc."nextcloud-admin-pass".text = "ChangeMeNow123!";

  services.nextcloud = {
    enable = true;
    #package = pkgs.nextcloud30;
    package = pkgs.nextcloud34;
    hostName = "nextcloud.localdomain";

    # Point Nextcloud core data to the ZFS dataset
    #dataDir = nextcloudDataDir;
    home = nextcloudDataDir;

    # Declaratively enable the External Storage application
    #extraAppsEnable = true;
    #extraApps = {
    #  inherit (config.services.nextcloud.package.packages.apps) files_external;
    #};

    config = {
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      adminuser = "admin";
      adminpassFile = "/etc/nextcloud-admin-pass";
    };

    settings = {
      default_phone_region = "MY";
      log_type = "systemd";
    };

    configureRedis = true;
  };

  # ---------------------------------------------------------------------------
  # 5. Systemd Ordering and Service Dependencies
  # ---------------------------------------------------------------------------
  # Ensure Nextcloud setup waits for both ZFS and NFS mounts
  systemd.services.nextcloud-setup = {
    #requires = [ "var-lib-nextcloud-data.mount" "mnt-nfs\\x2dshared.mount" ];
    #after = [ "var-lib-nextcloud-data.mount" "mnt-nfs\\x2dshared.mount" "postgresql.service" ];
    #
    #requires = [ "var-lib-nextcloud-data.mount" "mnt-nfsshare2.mount" ];
    #after = [ "var-lib-nextcloud-data.mount" "mnt-nfsshare2.mount" "postgresql.service" ];
    #
    requires = [ "MyTank-services-nextcloud.mount" "mnt-nfsshare2.mount" ];
    after = [ "MyTank-services-nextcloud.mount" "mnt-nfsshare2.mount" "postgresql.service" ];
  };

  # Ensure PHP-FPM waits for both mounts before serving requests
  systemd.services.phpfpm-nextcloud = {
    #requires = [ "var-lib-nextcloud-data.mount" "mnt-nfs\\x2dshared.mount" ];
    #after = [ "var-lib-nextcloud-data.mount" "mnt-nfs\\x2dshared.mount" ];
    #
    #requires = [ "var-lib-nextcloud-data.mount" "mnt-nfsshare2.mount" ];
    #after = [ "var-lib-nextcloud-data.mount" "mnt-nfsshare2.mount" ];
    #
    requires = [ "MyTank-services-nextcloud.mount" "mnt-nfsshare2.mount" ];
    after = [ "MyTank-services-nextcloud.mount" "mnt-nfsshare2.mount" "postgresql.service" ];
  };

  # ---------------------------------------------------------------------------
  # 6. Web Server (Nginx)
  # ---------------------------------------------------------------------------
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."nextcloud.localdomain" = {
      forceSSL = false; # Remember to update this if you configure HTTPS
    };
  };
}
