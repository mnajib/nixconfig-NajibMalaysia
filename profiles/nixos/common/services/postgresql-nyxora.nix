{ lib, pkgs, config, ... }:
let
  postgresql_port = 5432; # Default: 5432
  postgresql_user = "postgres"; #"";
  postgresql_group = "postgres"; #"";
  postgresql_userId = 71; # 71 is the default. can pick any unused UID/GID (≥100 is safe for system users you define)
  postgresql_groupId = 71; # 71 is the default. can pick any unused UID/GID (≥100 is safe for system users you define)
  postgresql_dataDir = "/MyTank/services/postgresql"; # Default: "";

  #airbyte_user      = "airbyte";
  #airbyte_group     = "airbyte";       # optional, if you want a dedicated group
  #airbyte_userId    = 200;             # pick a stable unused UID
  #airbyte_groupId   = 200;             # pick a stable unused GID
  #
  # By default, Airbyte state lives in ~/.airbyte and Docker volumes under /var/lib/docker/volumes.
  # Use below command
  #   abctl deploy --data-dir /MyTank/services/airbyte
  # to control where Airbyte stores its configs and logs; but Docker itself still keeps container layers in /var/lib/docker.
  airbyte_dataDir   = "/MyTank/services/airbyte"; # abctl deploy --data-dir /MyTank/services/airbyte
  #
  airbytedb        = "airbytedb";
  airbytedb_user      = "airbyteuser";
  airbytedb_password  = "myverystrongpassword";
in
{

  fileSystems."/MyTank/services" = {
    device = "MyTank/services";
    fsType = "zfs";
  };
  #
  # Separate dataset → reproducible snapshots/backups. Keeps each service isolated.
  # sudo chown -R postgres:postgres /MyTank/services/postgresql
  #
  #fileSystems."/MyTank/services/postgresql" = {
  #fileSystems.${postgresql_dataDir} = {
  #  device = "MyTank/services/postgresql";
  #  fsType = "zfs";
  #};

  users.users.${postgresql_user} = {
    isSystemUser = true;
    uid = postgresql_userId;
    group = "${postgresql_group}";
    home = "${postgresql_dataDir}"; # "/var/lib/postgresql"
    createHome = true;
  };
  users.groups.${postgresql_group} = {
    gid = postgresql_groupId;
    #members = [
    #  "${postgresql_user}"
    #];
  };

  # Declare Airbyte DB user/group explicitly
  #users.groups.${airbyte_group} = {
  #  gid = airbyte_groupId;
  #};
  #users.users.${airbyte_user} = {
  #  isSystemUser = true;
  #  uid          = airbyte_userId;
  #  group        = airbyte_group;
  #  description  = "Airbyte replication user";
  #  #home         = "/var/lib/airbyte";
  #  home         = "${airbyte_dataDir}";
  #};

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;

    #user = "${forgejo_user}";
    #group = "${forgejo_group}";

    dataDir = "${postgresql_dataDir}";

    settings = {
      port = postgresql_port;
    }; # End services.postgresql.settings

    #secrets = {
    #  metrics = {
    #    TOKEN = "/run/keys/forgejo-metrics-token";
    #  };
    #  camo = {
    #    HMAC_KEY = "/run/keys/forgejo-camo-hmac";
    #  };
    #  service = {
    #    HCAPTCHA_SECRET = "/run/keys/forgejo-hcaptcha-secret";
    #    HCAPTCHA_SITEKEY = "/run/keys/forgejo-hcaptcha-sitekey";
    #  };
    #};

    #mailerPasswordFile = config.age.secrets.forgejo-mailer-password.path;

    authentication = ''
      # Allow Airbyte user from local network
      host ${airbytedb} ${airbytedb_user} 0.0.0.0/0 md5
    '';

    # Create Airbyte DB + user
    initialScript = pkgs.writeText "init.sql" ''
      CREATE USER ${airbytedb_user} WITH PASSWORD '${airbytedb_password}';
      CREATE DATABASE ${airbytedb} OWNER ${airbytedb_user};
    '';

  }; # End services.forgejo

  #age.secrets.forgejo-mailer-password = {
  #  file = ../secrets/forgejo-mailer-password.age;
  #  mode = "400";
  #  owner = "forgejo";
  #};

  # Need to mount the my zfs storage first
  systemd.services.postgresql = {
    after = [
      "MyTank-services.mount"
      "zfs-mount.service"
      #"mnt-data.automount"
    ];

    # Explicit requires → PostgreSQL won’t even try to start if the mount isn’t there.
    requires = [
      "MyTank-services.mount"
      #"MyTank-services-postgresql.mount"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      postgresql_port
    ];
    allowedUDPPorts = [
      #...
    ];
  };

  # Optional: systemd unit to run abctl automatically
  #systemd.services.airbyte = {
  #  description = "Airbyte deployment via abctl";
  #  after       = [ "docker.service" ];
  #  requires    = [ "docker.service" ];
  #  serviceConfig = {
  #    User = airbyte_user;
  #    Group = airbyte_group;
  #    ExecStart = "${pkgs.abctl}/bin/abctl deploy --data-dir ${airbyte_dataDir}";
  #    Restart = "always";
  #  };
  #  wantedBy = [ "multi-user.target" ];
  #};

  # for airbyte, as nixos provide abctl to control airbyte docker, airbyte in nixos run as docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;   # optional: cleans up old images/containers
    rootless = {
      enable = false;          # run as root (simpler for services like Airbyte)
    };
  };

  environment.systemPackages = with pkgs; [
    abctl # airbyte control: Airbyte's CLI for managing local Airbyte (docker?) installations
  ];

}
