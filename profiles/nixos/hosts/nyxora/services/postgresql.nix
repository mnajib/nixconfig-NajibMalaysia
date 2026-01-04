{ lib, pkgs, config, ... }:
let
  postgresql_port = 5432; # Default: 5432
  postgresql_user = "postgres"; #"";
  postgresql_group = "postgres"; #"";
  postgresql_userId = 71; # 71 is the default. can pick any unused UID/GID (≥100 is safe for system users you define)
  postgresql_groupId = 71; # 71 is the default. can pick any unused UID/GID (≥100 is safe for system users you define)
  postgresql_dataDir = "/MyTank/services/postgresql"; # Default: "";
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

  services.postgresql = {
    enable = true;
    enableTCPIP = true; # Required to enable networking beyond Unix sockets
    package = pkgs.postgresql_16;

    dataDir = "${postgresql_dataDir}";

    settings = {
      #listen_addresses = '*';
      listen_addresses = lib.mkForce "127.0.0.1, 192.168.0.11";
      port = postgresql_port;

      #unix_socket_directories = "/run/postgresql";
      #unix_socket_group = "${postgresql_group}";
      #unix_socket_permissions = 0777;
    }; # End services.postgresql.settings

    # Create databases
    ensureDatabases = [
      "sekolah"
      "sekolahdb"
      "testdb"
    ];

    # Create users
    ensureUsers = [
      #{ name = "admin"; }
      {
        name = "sekolah";
        #password = "sekolah123";
        ensureDBOwnership = true; # Make postgres user "sekolah" as owner of postgres database "sekolah"
      }
      { name = "pengetua"; }
      { name = "guru"; }
      { name = "tester"; }
      {
        name = "authenticator"; # Role PostgREST uses to connect
      }
    ];

    # To set password
    #   sudo -u postgres psql
    #   ALTER USER sekolah WITH PASSWORD 'your_new_password_here';

    # To apply grants.sql
    #   psql -d sekolah -f grants.sql

    # Set up ownership and permissions
    # will run once, as superuser.
    # PostgreSQL has a data directory (PGDATA)
    # If that directory does not exist yet, PostgreSQL must initialize it
    # During that initialization → initialScript is executed once
    initialScript = pkgs.writeText "init-pg.sql" ''
      -- ==================================================
      -- Ownership
      -- ==================================================

      ALTER DATABASE sekolah   OWNER TO sekolah;
      ALTER DATABASE sekolahdb OWNER TO sekolah;
      -- ALTER DATABASE test      OWNER TO tester;
      ALTER DATABASE testdb    OWNER TO tester;

      -- ==================================================
      -- Connection privileges
      -- ==================================================

      GRANT CONNECT ON DATABASE sekolah   TO sekolah, guru, pengetua;
      GRANT CONNECT ON DATABASE sekolahdb TO sekolah, guru, pengetua;
      -- GRANT CONNECT ON DATABASE test      TO tester;
      GRANT CONNECT ON DATABASE testdb    TO tester;

      -- ==================================================
      -- Schema ownership & base access
      -- ==================================================

      -- Always be explicit
      ALTER SCHEMA public OWNER TO sekolah;

      GRANT USAGE ON SCHEMA public TO sekolah, guru, pengetua;

      -- ==================================================
      -- Table privileges (existing tables)
      -- ==================================================

      GRANT SELECT, INSERT, UPDATE, DELETE
        ON ALL TABLES IN SCHEMA public
        TO sekolah, guru;

      GRANT SELECT
        ON ALL TABLES IN SCHEMA public
        TO pengetua;

      -- ==================================================
      -- Future tables (VERY IMPORTANT)
      -- ==================================================

      ALTER DEFAULT PRIVILEGES IN SCHEMA public
        GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES
        TO sekolah, guru;

      ALTER DEFAULT PRIVILEGES IN SCHEMA public
        GRANT SELECT ON TABLES
        TO pengetua;

      -- ==================================================
      -- Sequences (SERIAL / IDENTITY)
      -- ==================================================

      GRANT USAGE, SELECT
        ON ALL SEQUENCES IN SCHEMA public
        TO sekolah, guru;

      ALTER DEFAULT PRIVILEGES IN SCHEMA public
        GRANT USAGE, SELECT ON SEQUENCES
        TO sekolah, guru;

      -- ==================================================
      -- PostgREST
      -- ==================================================
      CREATE ROLE web_anon NOLOGIN;
      GRANT USAGE ON SCHEMA public TO web_anon;
      GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.murid TO web_anon;
      GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO web_anon;
      GRANT web_anon TO postgrest;
    '';

    # Local trust authentication (for development)
    # Uses trust for local dev (no password); use md5 for production
    authentication = pkgs.lib.mkOverride 10 ''
      # --------- --------------- ----------------- ----------------- --------
      # TYPE      DATABASE        USER              ADDRESS           METHOD
      # --------- --------------- ----------------- ----------------- --------

      local       all             all                                 trust

      host        all             all               ::1/128           trust
      host        all             all               127.0.0.1/32      trust

      host        all             all               127.0.0.1/8       scram-sha-256

      host        all             all               192.168.0.12/32   scram-sha-256       # allow only the specific IP
      host        sekolah         sekolah           192.168.0.0/24    scram-sha-256       # allow the entire 192.168.0.0 network
    '';

  }; # End services.postgresql

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

}
