#
# References:
#   https://jacobneplokh.com/how-to-setup-nextcloud-on-nixos/
#
# Notes:
#   journalctl -u nextcloud-setup
#
#   To forced re-run installer and will lost any state:
#   rm -rf /var/lib/nextcloud
#
#

{ config, pkgs, lib, ... }:
{
  fileSystems."/var/lib/nextcloud" = {
    device = "/home/nextcloud/homedir";
    options = [ "bind" "x-systemd.automount" "noauto" ];
  };

  services.nextcloud = {
    enable = true;

    #home = "/home/nextcloud/homedir"; # XXX: Error: Configuration was not read or initialized correctly, not overwritting /home/nextcloud/homedir/config/config.php
    #home = "/var/lib/nextcloud"; # Default
    #home = "/home/nextcloud"; # Default: "/var/lib/nextcloud"
    #datadir = "/home/nextcloud/datadir";
    #datadir = "/home/nextcloud/data";
    #datadir = "/home/nextcloud/homedir/data";

    # NOTE: Nextcloud doesn't support upgrades across multiple major versions
    # (i.e. an upgrade from 16 is possible to 17, but not 16 to 18).
    #package = pkgs.nextcloud25;
    #package = pkgs.nextcloud26;
    package = pkgs.nextcloud27;

    #extraApps = with pkgs.nextcloud25Packages.apps; {
    #  #inherit mail news contacts calendar tasks;
    #  inherit news contacts calendar tasks;
    #};
    #
    extraAppsEnable = true;

    autoUpdateApps.enable = true;

    hostName = "customdesktop";
    #hostName = "customdesktop.localdomain";

    #https = true;
    #nginx.enable = true;

    #database.createLocally = true;

    config = {
      dbtype = "sqlite";
      #dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbname = "nextcloud";
      dbuser = "nextcloud";
      #dbpassFile = "/home/nextcloud/dbpass";
      dbpassFile = "${pkgs.writeText "adminpass" "test123"}";

      adminuser = "root";
      #adminuser = "nextcloud";
      #adminpassFile = "/home/nextcloud/adminpass";
      adminpassFile = "${pkgs.writeText "adminpass" "test123"}";

      #extraTrustedDomains = [
      #  "192.168.1"
      #];

    };

    logLevel = 2; # 0 debug ,1 info, 2 warn, 3 error, 4 fatal
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
