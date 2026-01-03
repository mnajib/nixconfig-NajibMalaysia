{ lib, pkgs, config, ... }:
let
  postgresql_port = 5432; # Default: 5432
  postgresql_user = "postgres"; #"";
  postgresql_group = "postgres"; #"";
  postgresql_userId = 71; # 71 is the default. can pick any unused UID/GID (≥100 is safe for system users you define)
  postgresql_groupId = 71; # 71 is the default. can pick any unused UID/GID (≥100 is safe for system users you define)
  postgresql_dataDir = "/MyTank/services/postgresql"; # Default: "";

  # To login pgadmin web interfacea (http://nyxora:5050)
  pgadmin_port = 5050; # Default 5050
  pgadmin_user = "mnajib@gmail.com";
  pgadmin_password = "thisismysecurepassword";
in
{

  # Ensures predictable ingress networking
  networking.nftables.enable = true;
  #
  networking.firewall = {
    allowedTCPPorts = [
      #postgresql_port
      # 80 443 8000 8443 30080 30443     # Required for Docker → kind → ingress routing
    ];
    allowedUDPPorts = [
      #...
    ];
  };

  #environment.systemPackages = with pkgs; [
  #];


  # -------------------------------------------------------
  # pgadmin
  # -------------------------------------------------------
  # create secret file at runtime (not in /nix/store)
  environment.etc."pgadmin/initial-password".text = "${pgadmin_password}"; #"ChangMeStrong123!";
  environment.etc."pgadmin/initial-password".mode = "0600";

  services.pgadmin = {
    enable = true;
    #listenAddress = "127.0.0.1";
    port = pgadmin_port; # 5050; # Default: 5050
    openFirewall = true;

    # for pgadmin login
    initialEmail = "${pgadmin_user}"; # "mnajib@gmail.com";
    initialPasswordFile = "/etc/pgadmin/initial-password";

    settings = {
      SERVER_MODE = true;
      DEFAULT_SERVER = "0.0.0.0";
      DEFAULT_SERVER_PORT = pgadmin_port; #5050;

      PROXY_X_FOR_COUNT = 1;
      PROXY_X_PROTO_COUNT = 1;
      PROXY_X_HOST_COUNT = 1;
      PROXY_X_PREFIX_COUNT = 1;
    };

  };

  # -------------------------------------------------------
  # nginx
  # -------------------------------------------------------
  services.nginx.enable = true;
  services.nginx.virtualHosts."pgadmin.localdomain" = {
    #forceSSL = true;
    #sslCertificate     = "/etc/nixos/secrets/tls/api.home.crt";
    #sslCertificateKey  = "/etc/nixos/secrets/tls/api.home.key";

    addSSL = false;

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString pgadmin_port}";
      proxyWebsockets = true;

      extraConfig = ''
        # Family-only network
        allow 192.168.0.0/24;
        allow 192.168.1.0/24;
        allow 127.0.0.1;
        deny all;

        # Flask routing
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        # Logging, CSRF
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        # HTTPS detection
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_buffering off;
      '';
    };
  };

}
