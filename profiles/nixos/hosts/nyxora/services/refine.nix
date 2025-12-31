{ config, pkgs, ... }:

let
  #refine_stateDir = "/MyTank/services/refine"; # Need 'mount /MyTank/services' and 'mkdir /MyTank/services/refine'

  #refine_port = 5173; # 3002
  #sijilberhenti_port = 3002; # 3002
  #sijilberhentiv2_port = 3003; # 3002
  #
  # NOTE:
  #
  # Check existing UIDs
  #   cat /etc/passwd | cut -d: -f3 | sort -n
  #
  # Check existing GIDs
  #   cat /etc/group | cut -d: -f3 | sort -n
  #
  refine_user = "refine";
  refine_group = "refine";
  refine_uid = 400;
  refine_gid = 400;

  # A helper function to create a Refine service
  mkRefineService = { name, port, domain }: {
    systemd.services."refine-${name}" = {
      description = "Refine App: ${name}";

      # Start this service after mount the my zfs storage first
      after = [
        "MyTank-services.mount"
        "zfs-mount.service"
        "network.target"
      ];

      wantedBy = [
        #"multi-user.target"
      ];

      # Explicit requires: won’t even try to start if the mount isn’t there.
      requires = [
        "MyTank-services.mount"
      ];

      # This makes 'node' and 'npm' available ONLY to this service
      #path = [ pkgs.nodejs_24 ];

      serviceConfig = {
        User = "refine"; # They can share a system user or have unique ones
        Group = "refine";
        StateDirectory = "refine/${name}"; # XXX
        #WorkingDirectory = "/var/lib/refine/${name}";
        WorkingDirectory = "/MyTank/services/refine/${name}";
        #Environment = "PORT=${toString port}"; # Each app needs a unique port
        #ExecStart = "${pkgs.nodejs}/bin/npm start";
        ExecStart = "${pkgs.nodejs_24}/bin/npm start -- --port ${toString port}";

        #Restart = "always";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    #services.nginx.virtualHosts."app.localdomain" = {
    services.nginx.virtualHosts."${domain}" = {
      #sslCertificate     = "/etc/nixos/secrets/tls/app.home.crt";
      #sslCertificateKey  = "/etc/nixos/secrets/tls/app.home.key";
      #
      #enableACME = true; # Automatic SSL
      enableACME = false;

      forceSSL = false;                 # 'true' to configures Nginx to listen on both ports, but redirects all HTTP traffic to HTTPS automatically. (Recommended for Refine apps).
      addSSL = false;                   # 'true' to configures Nginx listen on both Port 80 (HTTP) and Port 443 (HTTPS).
      onlySSL = false;                  # 'true' to configures Nginx to listen only on Port 443. HTTP requests will simply fail.

      locations."/" = {
        #proxyPass = "http://127.0.0.1:5173"; # Default Vite port
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true; # Necessary for Hot Module Replacement (HMR)
      };
    };

  };
in
{
  fileSystems."/MyTank/services" = {
    device = "MyTank/services";
    fsType = "zfs";
  };

  users.users."${refine_user}" = {
    isSystemUser = true;
    uid = refine_uid;
    group = refine_group;
    #home = "/var/lib/refine";
    home = "/MyTank/services/refine";
    createHome = true;
  };

  users.groups."${refine_group}" = {
    gid = refine_gid;
    members = [
      "${refine_user}"
    ];
  };

  # Add nginx user to the postgrest group so it can read the socket
  users.users.nginx.extraGroups = [
    "${refine_user}"
  ];

  services.nginx.enable = true;

  environment.systemPackages = with pkgs; [
    nodejs_24
  ];

  # Define your apps here in one line each!
  # This executes the logic for app1, app2, etc.
  imports = [
    #(mkRefineService { name = "crm";       port = 3000; domain = "crm.example.com"; })
    #(mkRefineService { name = "inventory"; port = 3001; domain = "stock.example.com"; })
    #(mkRefineService { name = "billing";   port = 3002; domain = "invoice.example.com"; })
    (mkRefineService { name = "app";       port = 3003; domain = "app.localdomain"; })
  ];
}

