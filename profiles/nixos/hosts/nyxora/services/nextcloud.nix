{ config, pkgs, lib, ... }:

let
  # Local paths
  zfsDatasetPath = "/mnt/zfs-nextcloud";
  nextcloudDataDir = "/var/lib/nextcloud/data";
in
{
  # ---------------------------------------------------------------------------
  # 1. Local ZFS & Filesystem Configuration
  # ---------------------------------------------------------------------------
  boot.supportedFilesystems = [ "zfs" "nfs" ];

  # Local ZFS Dataset Mount Point
  # Replace 'rpool/data/nextcloud' with your actual pool/dataset path
  fileSystems."${zfsDatasetPath}" = {
    device = "rpool/data/nextcloud";
    fsType = "zfs";
    options = [ "noatime" ];
  };

  # ---------------------------------------------------------------------------
  # 2. Local NFS Server Configuration
  # ---------------------------------------------------------------------------
  services.nfs.server = {
    enable = true;
    # Export ZFS dataset strictly to loopback (127.0.0.1)
    exports = ''
      ${zfsDatasetPath} 127.0.0.1(rw,sync,no_subtree_check,no_root_squash)
    '';
  };

  # ---------------------------------------------------------------------------
  # 3. Local Loopback NFS Mount Configuration
  # ---------------------------------------------------------------------------
  fileSystems."${nextcloudDataDir}" = {
    device = "127.0.0.1:${zfsDatasetPath}";
    fsType = "nfs";
    options = [
      "nfsvers=4.2"
      "rw"
      "hard"
      "intr"
      "noatime"
      "x-systemd.automount"
      "x-systemd.idle-timeout=60"
      "x-systemd.requires=nfs-server.service"
      "x-systemd.after=nfs-server.service"
    ];
  };

  # ---------------------------------------------------------------------------
  # 4. Database (PostgreSQL)
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
  # 5. Nextcloud Service Configuration
  # ---------------------------------------------------------------------------
  environment.etc."nextcloud-admin-pass".text = "ChangeMeNow123!";

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "nextcloud.local";
    
    # Nextcloud data points to the loopback NFS mount
    dataDir = nextcloudDataDir;

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
  # 6. Systemd Ordering and Service Dependencies
  # ---------------------------------------------------------------------------
  # Explicitly order NFS server startup after local ZFS mounts
  systemd.services.nfs-server = {
    after = [ "mnt-zfs\\x2dnextcloud.mount" ];
    requires = [ "mnt-zfs\\x2dnextcloud.mount" ];
  };

  # Ensure Nextcloud waits for local loopback NFS mount
  systemd.services.nextcloud-setup = {
    requires = [ "var-lib-nextcloud-data.mount" ];
    after = [ "var-lib-nextcloud-data.mount" "postgresql.service" ];
  };

  systemd.services.phpfpm-nextcloud = {
    requires = [ "var-lib-nextcloud-data.mount" ];
    after = [ "var-lib-nextcloud-data.mount" ];
  };

  # ---------------------------------------------------------------------------
  # 7. Web Server (Nginx)
  # ---------------------------------------------------------------------------
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."nextcloud.local" = {
      forceSSL = false;
    };
  };
}
