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
  # Airbyte service ports
  #airbyte_ui_port   = 8000; # Web UI
  #airbyte_api_port  = 8001; # API
  #airbyte_debug_port = 8002; # optional debug/metrics
  #
  # By default, Airbyte state lives in ~/.airbyte and Docker volumes under /var/lib/docker/volumes.
  # Use below command
  #   abctl deploy --data-dir /MyTank/services/airbyte
  # to control where Airbyte stores its configs and logs; but Docker itself still keeps container layers in /var/lib/docker.
  #airbyte_dataDir   = "/MyTank/services/airbyte"; # abctl deploy --data-dir /MyTank/services/airbyte
  #
  #airbytedb        = "airbytedb";
  #airbytedb_user      = "airbyteuser";
  #airbytedb_password  = "myverystrongpassword";
in
{

  fileSystems."/MyTank/services" = {
    device = "MyTank/services";
    fsType = "zfs";
  };
  #
  # Separate dataset → reproducible snapshots/backups. Keeps each service isolated.
  #   sudo zfs create MyTank/services/airbyte
  #   sudo zfs set mountpoint=/MyTank/services/airbyte MyTank/services/airbyte
  #   sudo chown -R postgres:postgres /MyTank/services/postgresql
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
  #users.users.najib.extraGroups = [ "docker" ];

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
    enableTCPIP = true; # Required to enable networking beyond Unix sockets
    package = pkgs.postgresql_16;

    #user = "${forgejo_user}";
    #group = "${forgejo_group}";

    dataDir = "${postgresql_dataDir}";

    settings = {
      #listen_addresses = '*';
      listen_addresses = lib.mkForce "127.0.0.1, 192.168.0.11";
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

    #authentication = ''
    #  # Allow Airbyte user from local network
    #  host ${airbytedb} ${airbytedb_user} 0.0.0.0/0 md5
    #'';

    # Create Airbyte DB + user
    #initialScript = pkgs.writeText "init.sql" ''
    #  CREATE USER ${airbytedb_user} WITH PASSWORD '${airbytedb_password}';
    #  CREATE DATABASE ${airbytedb} OWNER ${airbytedb_user};
    #'';

    # Create databases
    ensureDatabases = [
      "sekolahdb"
      "testdb"
    ];

    # Create users
    ensureUsers = [
      #{ name = "admin"; }
      {
        name = "sekolah";
        #password = "sekolah123";
      }
      { name = "pengetua"; }
      { name = "guru"; }
      { name = "tester"; }
    ];

    # To set password
    #   sudo -u postgres psql
    #   ALTER USER sekolah WITH PASSWORD 'your_new_password_here';

     # Set up ownership and permissions
    initialScript = pkgs.writeText "init-pg.sql" ''
      -- XXX: Set/reset test password
      -- ALTER USER sekolah WITH PASSWORD 'sekolah123';

      -- Assign ownership
      ALTER DATABASE sekolah OWNER TO sekolah;
      ALTER DATABASE sekolahdb OWNER TO sekolah;
      ALTER DATABASE test OWNER TO tester;
      ALTER DATABASE testdb OWNER TO tester;

      -- Grant access to multiple users
      GRANT CONNECT ON DATABASE sekolah TO sekolah, guru, pengetua;
      GRANT CONNECT ON DATABASE sekolahdb TO sekolah, guru, pengetua;
      GRANT CONNECT ON DATABASE test TO tester;
      GRANT CONNECT ON DATABASE testdb TO tester;

      -- Schema and table privileges
      \connect sekolah
      GRANT USAGE ON SCHEMA public TO sekolah, guru, pengetua;
      GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO sekolah, guru;
      GRANT SELECT ON ALL TABLES IN SCHEMA public TO pengetua, sekolah;

      \connect test
      GRANT USAGE ON SCHEMA public TO sekolah, pengetua;
      GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO tester;
      GRANT SELECT ON ALL TABLES IN SCHEMA public TO pengetua, sekolah;
    '';

    # Local trust authentication (for development)
    # Uses trust for local dev (no password); use md5 for production
    authentication = pkgs.lib.mkOverride 10 ''
      # TYPE    DATABASE        USER              ADDRESS           METHOD
      local     all             all                                 trust
      #host      all             all               127.0.0.0.1/8     trust

      #host      sekolah         sekolah           192.168.0.0/24    md5
      #host      all             all               192.168.0.12/24   md5
      host      all             all               192.168.0.12/24   md5
    '';

    #authentication = pkgs.lib.mkOverride 10 ''
    #  # TYPE  DATABASE        USER            ADDRESS                 METHOD
    #  local   all             all                                     trust
    #  host    all             all             127.0.0.1/32            trust
    #  host    all             all             192.168.1.0/24          md5
    #'';

    #authentication = pkgs.lib.mkOverride 10 ''
    #  # TYPE  DATABASE        USER            METHOD
    #  local   all             all             md5
    #  host    all             all     127.0.0.1/32    md5
    #  host    all             all     ::1/128         md5
    #'';

  }; # End services.postgresql

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

  # Ensures predictable ingress networking
  networking.nftables.enable = true;
  #
  networking.firewall = {
    allowedTCPPorts = [
      postgresql_port

      #airbyte_ui_port
      #airbyte_api_port
      #airbyte_debug_port

      # 80 443 8000 8443 30080 30443     # Required for Docker → kind → ingress routing
    ];
    allowedUDPPorts = [
      #...
    ];
  };

  # Required for Docker 27+ and kind
  #boot.kernelParams = [ "systemd.unified_cgroup_hierarchy=1" ];

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
  #virtualisation.docker = {
  #  enable = true;
  #  enableOnBoot = true;
  #  enableNvidia = false;
  #  autoPrune.enable = true;   # optional: cleans up old images/containers
  #  rootless = {
  #    enable = false;          # run as root (simpler for services like Airbyte)
  #  };
  #
  #  # Required for kind on NixOS
  #  #extraOptions = ''
  #  #  --iptables=true
  #  #'';
  #  #  #--log-level=error
  #};

  #environment.systemPackages = with pkgs; [
  #  abctl # airbyte control: Airbyte's CLI for managing local Airbyte (docker?) installations
  #];

}
