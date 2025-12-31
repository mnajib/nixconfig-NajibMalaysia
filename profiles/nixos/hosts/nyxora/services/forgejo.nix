{ lib, pkgs, config, ... }:
let
  forgejo_port = 3000; # port OR socket
  forgejo_socket = "/run/forgejo/forgejo.sock";

  forgejo_user = "forgejo"; #"git";
  forgejo_group = "forgejo"; #"git";
  forgejo_uid = 984;
  forgejo_gid = 981;

  forgejo_stateDir = "/MyTank/services/forgejo"; # "/mnt/data/forgejo";
in
{
  fileSystems."/MyTank/services" = {
    device = "MyTank/services";
    fsType = "zfs";
  };

  #users.users.git = {
  users.users.${forgejo_user} = {
    isSystemUser = true;
    #uid = 984;
    uid = forgejo_uid;
    #group = "git";
    #group = "forgejo";
    group = forgejo_group;
    #home = "/var/lib/forgejo";
    home = "/MyTank/services/forgejo";
    createHome = true;
  };
  #users.groups.git = {};
  users.groups = {
    ${forgejo_group} = {
      #gid = 981;
      gid = forgejo_gid;
      #members = [
      #  ${forgejo_group}
      #];
    };
  };

  services.forgejo = {
    enable = true;

    user = forgejo_user;
    group = forgejo_group;

    stateDir = forgejo_stateDir;

    database.type = "sqlite3";

    settings = {
      server = {
        #DOMAIN = "${config.networking.hostName}";
        DOMAIN = "git.localdomain";
        SSH_DOMAIN = "git.localdomain";

        # You need to specify this to remove the port from URLs in the web UI.
        #ROOT_URL = "https://${srv.DOMAIN}/";
        #ROOT_URL = "https://git.localdomain/"; # for external users
        ROOT_URL = "http://git.localdomain/"; # for external users
        #LOCAL_ROOT_URL = "http://localhost:3000/"; # for internal prosess ??? Default to ROOT_URL

        PROTOCOL = "http+unix"; #"http";
        HTTP_ADDR = "/run/forgejo/forgejo.sock";
        #
        #PROTOCOL = "http"; #"http";
        #HTTP_ADDR = "127.0.0.1";
        #HTTP_PORT = forgejo_port;
      };

      #service = {
      #  DISABLE_REGISTRATION = true;
      #};

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

  networking.firewall = {
    allowedTCPPorts = [
      forgejo_port
      #3000
    ];
    allowedUDPPorts = [
      #...
    ];
  };

  services.nginx.virtualHosts."git.localdomain" = {
    #forceSSL = true;
    #sslCertificate     = "/etc/nixos/secrets/tls/git.home.crt";
    #sslCertificateKey  = "/etc/nixos/secrets/tls/git.home.key";
    #
    addSSL = false;

    locations."/" = {
      #proxyPass = "http://127.0.0.1:3000";
      #proxyWebsockets = true;
      proxyPass = "http://unix:/run/forgejo/forgejo.sock";
    };
  };

}
