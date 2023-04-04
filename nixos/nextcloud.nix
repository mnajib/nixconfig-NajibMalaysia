#
# References:
#   https://jacobneplokh.com/how-to-setup-nextcloud-on-nixos/
#

{ config, pkgs, lib, ... }:
{
  services.nextcloud = {
    enable = true;

    home = "/home/nextcloud/homedir";
    #datadir = "/home/nextcloud/datadir";

    #package = pkgs.nextcloud25;
    #extraApps = with pkgs.nextcloud25Packages.apps; {
    #  inherit mail news contacts;
    #};
    #extraAppsEnable = true;

    autoUpdateApps.enable = true;

    hostName = "customdesktop";

    #https = true;

    #nginx.enable = true;

    config = {
      #dbtype = "pgsql";
      #dbuser = "nextcloud";
      #dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
      #dbname = "nextcloud";
      #adminuser = "root";
      adminuser = "nextcloud";
      adminpassFile = "/home/nextcloud/adminpass";
    };
  };

  #services.postgresql = {
  #  enable = false; #true;
  #  ensureDatabases = [ "nextcloud" ];
  #  ensureUsers = [{
  #    name = "nextcloud";
  #    ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
  #  }];
  #};

  # ensure that postgres is running *before* running the setup
  #systemd.services."nextcloud-setup" = {
  #  requires = ["postgresql.service"];
  #  after = ["postgresql.service"];
  #};

  # Firewall
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Cerficate - Let's Encrypt
  #security.acme = {
  #  acceptTerms = true;
  #  # Replace the email here!
  #  email = "najib@customdesktop";
  #};

  #services.nginx = {
  #};
}
