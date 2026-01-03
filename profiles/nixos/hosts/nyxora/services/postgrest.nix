{ config, pkgs, ... }:

{
  services.postgrest = {
    enable = true;

    settings = {

      #----------------------------------------------------
      # PostgREST <-> Database
      #----------------------------------------------------
      #
      # postgresql://[userspec@][hostspec][/dbname][?paramspec]
      #   where userspec is:
      #     user[:password]
      #   and hostspec is:
      #     [host][:port][,...]
      #   and paramspec is:
      #     name=value[&...]
      #
      # postgresql://user:password@localhost/sekolahdb
      #db-uri = "postgresql://authenticator@/sekolahdb?connect_timeout=10"; # Tell PostgREST to connects no RostgreSQL via TCP
      #db-uri = "postgresql://sekolah:sekolah123@localhost:5432/sekolahdb"; # Tell PostgREST to connects no RostgreSQL via TCP
      #db-uri = "postgresql://authenticator@/sekolahdb?host=/run/postgresql"; # Tell PostgREST to connects no RostgreSQL via Unix socket
      #db-uri = "postgresql://sekolah@/sekolahdb?host=/run/postgresql"; # Tell PostgREST to connects no RostgreSQL via Unix socket
      #db-uri = "postgresql:///sekolahdb?host=/run/postgresql"; # Tell PostgREST to connects no RostgreSQL via Unix socket
      #db-uri = "postgres:///mydb";
      #db-uri = "postgres:///sekolahdb";
      db-uri = {
        host = "localhost";
        dbname = "sekolahdb";
      };

      db-schema = "public"; # This tells PostgREST where/which "folder" (schema) inside your database contains the tables you want to turn into an API.

      #db-anon-role = "web_anon"; # This thell PostgREST who/which "database user" it should "pretend" to be when a request comes in from the internet without any login credentiols (anonymous).
      db-anon-role = "anon";

      #----------------------------------------------------
      # You/Client <-> PostgREST
      #----------------------------------------------------
      # PostgREST serve/listen on
      # The postgrest process is listening on for http requests
      #server-host = "127.0.0.1";
      #server-host = "!4"; # PostgREST will listen on any IPv4 hostname
      #server-port = 3001;
      #server-unix-socket = null; # PostgREST only will listen to one; TCP (server-port) or socket (server-unix-socket); not both, need to disable one
      # OR
      #server-unix-socket = "..."; # Default use server-unix-socket and not use server-port

    };
  };

  networking.firewall.allowedTCPPorts = [
    3001 # postgrest
    80 # nginx (for http)
    443 # nginx with SSL (for https)
  ];

  # 1. Create the directory with correct permissions so Nginx can enter it
  # 2. Add Nginx to the postgrest group (or vice versa) to allow socket access
  systemd.services.postgrest = {
    serviceConfig = {
      RuntimeDirectory = "postgrest";
      #RuntimeDirectoryMode = "0750"; # Allow group members to access
      #UMask = "0077";               # Ensure the socket created is group-readable
    };
  };

  # Add nginx user to the postgrest group so it can read the socket
  #users.users.nginx.extraGroups = [ "postgrest" ];

  services.nginx.virtualHosts."api.localdomain" = {
    #forceSSL = true;
    #sslCertificate     = "/etc/nixos/secrets/tls/api.home.crt";
    #sslCertificateKey  = "/etc/nixos/secrets/tls/api.home.key";

    addSSL = false;

    locations."/" = {
      proxyPass = "http://unix:/run/postgrest/postgrest.sock:/";

      extraConfig = ''
        # Family-only network
        allow 192.168.0.0/24;
        allow 192.168.1.0/24;
        allow 127.0.0.1;
        deny all;
      '';
    };
  };

}

