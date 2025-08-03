{ lib, pkgs, config, ... }:
let
  forgejo_port = 3000;
  forgejo_user = "forgejo"; #"git";
  forgejo_group = "forgejo"; #"git";
  #forgejo_stateDir = "/MyTank/services/forgejo";
  forgejo_stateDir = "/mnt/data/forgejo";
in
{
  #users.users.git = {
  #users.users.forgejo = {
  users.users.forgejo_user = {
    isSystemUser = true;
    #group = "git";
    #group = "forgejo";
    group = forgejo_group;
    #home = "/var/lib/forgejo";
    #home = "/MyTank/services/forgejo";
    home = forgejo_stateDir;
    createHome = true;
  };
  #users.groups.git = {};
  #users.groups.forgejo = {};
  users.groups.forgejo_group = {};

  services.forgejo = {
    enable = true;

    user = forgejo_user;
    group = forgejo_group;

    stateDir = forgejo_stateDir;

    database.type = "sqlite3";

    settings = {
      server = {
        DOMAIN = "${config.networking.hostName}";
        # You need to specify this to remove the port from URLs in the web UI.
        #ROOT_URL = "https://${srv.DOMAIN}/";
        #HTTP_PORT = port_number;
      };

    }; # End services.forgejo.settings

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

  networking.firewall = {
    allowedTCPPorts = [
      forgejo_port
      #3000
    ];
    allowedUDPPorts = [
      #...
    ];
  };
}
