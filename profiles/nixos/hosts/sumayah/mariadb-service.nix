# profiles/nixos/hosts/nyxora/services/mariadb.nix 

#
# NOTE:
#
# To check service status
#   systemctl status mysql.service
#
# To monitor logs
#   journalctl -f -u mysql.service
#

{ pkgs, lib, ... }:

let
  # --- Toggle Switches ---
  enableRootSetup = true;
  enableAppSetup = false;

  # --- Script Blocks ---

  # The Immediate Fix (Command Line)
  #   initialScript only executes once during the very first database creation.
  #   Updating your Nix file now will not reset the password for your existing database.
  #   To fix your immediate phpMyAdmin login issue, run this one-liner in your
  #   terminal to force the password to be truly empty:
  #     sudo mariadb -u root -e "ALTER USER 'root'@'127.0.0.1' IDENTIFIED BY ''; FLUSH PRIVILEGES;"
  #
  # ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('your_secure_password');
  rootScript = ''
    CREATE USER IF NOT EXISTS 'root'@'127.0.0.1' IDENTIFIED BY "";
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;

    CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY "";
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
  '';

  appScript = ''
    CREATE USER IF NOT EXISTS 'app_user'@'127.0.0.1' IDENTIFIED BY 'app_password';
    CREATE USER IF NOT EXISTS 'app_user'@'localhost' IDENTIFIED BY 'app_password';
    ALTER USER 'app_user'@'127.0.0.1' IDENTIFIED BY 'app_password';
    ALTER USER 'app_user'@'localhost' IDENTIFIED BY 'app_password';
    GRANT ALL PRIVILEGES ON car_service_db.* TO 'app_user'@'127.0.0.1';
    GRANT ALL PRIVILEGES ON car_service_db.* TO 'app_user'@'localhost';

    CREATE USER IF NOT EXISTS 'app2_user'@'127.0.0.1' IDENTIFIED BY 'app2_password';
    CREATE USER IF NOT EXISTS 'app2_user'@'localhost' IDENTIFIED BY 'app2_password';
    ALTER USER 'app2_user'@'127.0.0.1' IDENTIFIED BY 'app2_password';
    ALTER USER 'app2_user'@'localhost' IDENTIFIED BY 'app2_password';
    GRANT ALL PRIVILEGES ON car_service_db.* TO 'app2_user'@'127.0.0.1';
    GRANT ALL PRIVILEGES ON car_service_db.* TO 'app2_user'@'localhost';
  '';

  # 1. Generate the SQL file dynamically in the Nix store
  alwaysRunScript = pkgs.writeText "mariadb-always-run.sql" ''
    ${lib.optionalString enableRootSetup rootScript}
    ${lib.optionalString enableAppSetup appScript}
    FLUSH PRIVILEGES;
  '';

in
{

  # ---------------------------------------------------------------------------
  # Systemd Boot Override: Prevent Auto-Start on System Activation
  # ---------------------------------------------------------------------------
  systemd.services = {
    #nginx.wantedBy = lib.mkForce [ ];
    #postgresql.wantedBy = lib.mkForce [ ];

    # Systemd Boot Override: Prevent Auto-Start on System Activation
    #
    # To start the service
    #   sudo systemctl start mysql
    mysql.wantedBy = lib.mkForce [ ];

    #"phpfpm-app1".wantedBy = lib.mkForce [ ];
    #"phpfpm-app2".wantedBy = lib.mkForce [ ];
  };

  #
  # To test
  #   sudo mariadb -u root -e "SHOW DATABASES;"
  #
  services.mysql = {
    enable = true;

    #package = pkgs.mariadb;
    package = pkgs.mariadb_114; # Lets pin/lock to version 11.4.12

    #
    # NOTE:
    #   No Password Required for Local Admin: To access MariaDB as root, you do not need a password. Simply run:
    #
    #     sudo mariadb -u root
    #

    settings = {
      mysqld = {
        port = 3306;
        bind-address = "127.0.0.1";
        #skip-name-resolve = true;
      };
    };

    #
    # NOTE: A Critical Reminder on initialScript
    # Remember that NixOS explicitly only executes the initialScript file one single time—specifically when the /var/lib/mysql directory is completely empty and being initialized for the very first boot.
    # Changing these boolean toggles later on and running sudo nixos-rebuild switch will update the .sql file in the Nix store, but the database daemon will not execute it again.
    #
    initialScript = pkgs.writeText "mariadb-init.sql" ''
      ${lib.optionalString enableRootSetup rootScript}
      ${lib.optionalString enableAppSetup appScript}
      FLUSH PRIVILEGES;
    '';

    #initialDatabases = [];

    #ensureDatabases = [
    #  "car_service_db"
    #  "car_service_app2_db"
    #  "car_service_app3_db"
    #];

    #ensureUsers = [
    #
    #  {
    #    name = "app_user";
    #    #password = "app_password";
    #    ensurePermissions = {
    #      "car_service_db.*" = "ALL PRIVILEGES";
    #    };
    #  }
    #
    #  {
    #    name = "app2_user";
    #    #password = "app2_password";
    #    ensurePermissions = {
    #      "car_service_app2_db.*" = "ALL PRIVILEGES";
    #    };
    #  }
    #
    #  {
    #    name = "app3_user";
    #    #password = "app3_password";
    #    ensurePermissions = {
    #      "car_service_app3_db.*" = "ALL PRIVILEGES";
    #    };
    #  }
    #
    #];

  }; # End services.mysql = { ... };

  # 2. Hook into systemd to execute the script every time the service starts
  systemd.services.mysql.postStart = lib.mkAfter ''
    # Wait until MariaDB is ready to accept connections
    echo "Waiting for MariaDB to start..."
    while ! ${pkgs.mariadb_114}/bin/mariadb-admin ping --silent; do
      sleep 1
    done

    # Feed the dynamically generated SQL file directly into MariaDB
    #${pkgs.mariadb_114}/bin/mariadb -u root < ${alwaysRunScript}
  '';

}
