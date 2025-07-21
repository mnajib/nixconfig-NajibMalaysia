{ lib, pkgs, config, ... }:
let
  cfg = config.services.forgejo;
  srv = cfg.settings.server;
  port_number = 3001;
in
{
  services.nginx = {
    virtualHosts.${cfg.settings.server.DOMAIN} = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        client_max_body_size 512M;
      '';
      locations."/".proxyPass = "http://localhost:${toString srv.HTTP_PORT}";
    };
  };

  services.forgejo = {
    enable = true;
    database.type = "sqlite3";
    lfs.enable = true; # Enable support for Git Large File Storage

    stateDir = "/mnt/data/forgejo";

    settings = {
      server = {
        DOMAIN = "${config.networking.hostName}";
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "https://${srv.DOMAIN}/";
        HTTP_PORT = port_number;
      };
      service.DISABLE_REGISTRATION = true; # You can temporarily allow registration to create an admin user.

      # Add support for actions, based on act: https://github.com/nektos/act
      #actions = {
      #  ENABLED = true;
      #  DEFAULT_ACTIONS_URL = "github";
      #};

      # Sending emails is completely optional
      # You can send a test email from the web UI at:
      # Profile Picture > Site Administration > Configuration >  Mailer Configuration 
      #mailer = {
      #  ENABLED = true;
      #  SMTP_ADDR = "mail.example.com";
      #  FROM = "noreply@${srv.DOMAIN}";
      #  USER = "noreply@${srv.DOMAIN}";
      #};

    }; # End services.forgejo.settings

    secrets = {
      metrics = {
        TOKEN = "/run/keys/forgejo-metrics-token";
      };
      camo = {
        HMAC_KEY = "/run/keys/forgejo-camo-hmac";
      };
      service = {
        HCAPTCHA_SECRET = "/run/keys/forgejo-hcaptcha-secret";
        HCAPTCHA_SITEKEY = "/run/keys/forgejo-hcaptcha-sitekey";
      };
    };

    #mailerPasswordFile = config.age.secrets.forgejo-mailer-password.path;

  }; # End services.forgejo

  #age.secrets.forgejo-mailer-password = {
  #  file = ../secrets/forgejo-mailer-password.age;
  #  mode = "400";
  #  owner = "forgejo";
  #};

  # Need to mount the my zfs storage first
  systemd.services.forgejo = {
    after = [
      "mnt-data.automount"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    port_number
  ];

}
