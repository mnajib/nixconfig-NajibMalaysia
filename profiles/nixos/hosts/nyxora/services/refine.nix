{
  config,
  pkgs,
  lib,
  ...
}:

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
  refine_root = "/MyTank/services/refine";

  # A helper function to create a Refine service
  mkRefineApp = { name, dev_port, domain }: {
    # Phase-1: only nginx reverse proxy, app build

    #----------------------------------
    # For dev (TCP -> manual dev server
    #----------------------------------
    services.nginx.virtualHosts."dev${domain}" = {
      forceSSL = false;
      enableACME = false;

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString dev_port}";
        proxyWebsockets = true;
      };
    };
    #----------------------------------

    #----------------------------------
    # For staging / prod (static files)
    #----------------------------------
    services.nginx.virtualHosts."${domain}" = {
      #sslCertificate     = "/etc/nixos/secrets/tls/app.home.crt";
      #sslCertificateKey  = "/etc/nixos/secrets/tls/app.home.key";
      #
      #enableACME = true; # Automatic SSL
      enableACME = false;

      forceSSL = false;                 # 'true' to configures Nginx to listen on both ports, but redirects all HTTP traffic to HTTPS automatically. (Recommended for Refine apps).
      addSSL = false;                   # 'true' to configures Nginx listen on both Port 80 (HTTP) and Port 443 (HTTPS).
      onlySSL = false;                  # 'true' to configures Nginx to listen only on Port 443. HTTP requests will simply fail.

      root = "${refine_root}/${name}/dist";

      locations."/" = {
        tryFiles = "$uri $uri/ /index.html";
      };
    };
    #----------------------------------

  }; # End mkRefineApp

  # -----------------------------
  # List of Refine apps
  # -----------------------------
  refineApps = [
    { name = "sijilberhenti";       dev_port = 3003;    domain = "sijilberhenti.localdomain"; }
    #{ name = "app2";               dev_port = 3004;    domain = "app2.localdomain"; }
    #{ name = "app3";               dev_port = 3005;    domain = "app3.localdomain"; }
  ];

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
    shell = pkgs.bash; # ???
  };

  users.groups."${refine_group}" = {
    gid = refine_gid;
    members = [
      "${refine_user}"
      "nginx"
      "najib"
    ];
  };

  # NOTE:
  # Fix directory permissions (need only run one-time)
  #sudo chmod 755 /MyTank
  #sudo chmod 755 /MyTank/services
  #sudo chmod 755 /MyTank/services/refine
  #sudo chmod 755 /MyTank/services/refine/sijilberhenti
  #sudo chmod 755 /MyTank/services/refine/sijilberhenti/dist
  # Verify
  #namei -l /MyTank/services/refine/sijilberhenti/dist/index.html

  # Add nginx user to the postgrest group so it can read the socket
  users.users.nginx.extraGroups = [
    "${refine_user}"
  ];

  services.nginx.enable = true;

  networking.firewall.enable = lib.mkDefault true;
  networking.firewall.allowedTCPPorts = [ 80 443 ]; # HTTP + HTTPS

  environment.systemPackages = with pkgs; [
    nodejs_24
    yarn
  ];

  # Define your apps here in one line each!
  # This executes the logic for app1, app2, etc.
  #imports = [
  #  #(mkRefineService { name = "crm";       port = 3000; domain = "crm.example.com"; })
  #  #(mkRefineService { name = "inventory"; port = 3001; domain = "stock.example.com"; })
  #  #(mkRefineService { name = "billing";   port = 3002; domain = "invoice.example.com"; })
  #  #(mkRefineService { name = "app";       port = 3003; domain = "app.localdomain"; })
  #  (mkRefineService { name = "sijilberhenti";       port = 3003; domain = "sijilberhenti.localdomain"; })
  #];
  #
  # -----------------------------
  # Import each Refine app nginx configuration
  # -----------------------------
  imports = map (app: mkRefineApp app) refineApps;

  #
  # NOTE:
  #
  #   How you actually use this (day-to-day
  #
  #     Dev workflow
  #       #cd /MyTank/services/refine/sijilberhenti
  #       #npm install
  #       #npm run dev -- --port 3003
  #       sudo -u refine -- bash -lc 'cd /MyTank/services/refine/sijilberhenti/ && npm install'
  #       sudo -u refine -- bash -lc 'cd /MyTank/services/refine/sijilberhenti && npm run dev -- --host 127.0.0.1 --port 3003'
  #       #Open 'http://devsijilberhenti.localdomain' via web browser.
  #
  #
  #     Staging / Prod workflow
  #       #npm run build
  #       sudo -u refine -- bash -lc 'cd /MyTank/services/refine/sijilberhenti/ && npm run build'
  #       #Open 'http://sijilberhenti.localdomain' via web browser
  #

}

