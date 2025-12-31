{ config, pkgs, ... }:

{
  services.postgrest = {
    enable = true;

    settings = {

      #----------------------------------------------------
      # PostgREST <-> Database
      #----------------------------------------------------
      db-uri = "postgres://authenticator@/sekolahdb"; # Tell PostgREST to connects no RostgreSQL via Unix socket
      db-schema = "public"; # This tells PostgREST where/which "folder" (schema) inside your database contains the tables you want to turn into an API.
      db-anon-role = "web_anon"; # This thell PostgREST who/which "database user" it should "pretend" to be when a request comes in from the internet without any login credentiols (anonymous).
      #db-uri = "postgres:///mydb";
      #db-uri = "postgres:///sekolahdb";
      #db-anon-role = "anon";

      #----------------------------------------------------
      # You/Client <-> PostgREST
      #----------------------------------------------------
      # Use unix socket, if put Nginx in front of PostgREST
      server-unix-socket = "/run/postgrest/postgrest.sock"; # default
      #server-unix-socket-mode = "660";
      #
      # For direct serve standard web browser
      #server-host = "127.0.0.1";
      #server-port = 3000; # 3000 already use for forgejo
      #server-port = 3001;

    };
  };

  # 1. Create the directory with correct permissions so Nginx can enter it
  # 2. Add Nginx to the postgrest group (or vice versa) to allow socket access
  systemd.services.postgrest = {
    serviceConfig = {
      RuntimeDirectory = "postgrest";
      RuntimeDirectoryMode = "0750"; # Allow group members to access
      UMask = "0007";               # Ensure the socket created is group-readable
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

