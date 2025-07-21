#
# Notes:
#   ...
#
#

{ config, pkgs, lib, ... }:

{

  services.netdata = {
    enable = true;

    config = {
      global = {
        # Uncomment to reduce memory to 32 MB.
        #"page cache size" = 32;

        # Update interval
        "update every" = 15;
      };

      # Machine Learning
      ml = {
        "enabled" = "yes";
      };
    };

    #logLevel = 2; # 0 debug ,1 info, 2 warn, 3 error, 4 fatal
  };

  # Firewall
  networking.firewall.allowedTCPPorts = [ 19999 ]; # 80 443

  # Cerficate - Let's Encrypt
  #security.acme = {
  #  acceptTerms = true;
  #  defaults.email = "najib@customdesktop.localdomain";
  #};

  #services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
  #services.nginx = {
  #  enable = true;
  #  recommendedGzipSettings = true;
  #  recommendedOptimisation = true;
  #  recommendedProxySettings = true;
  #  recommendedTlsSettings = true;
  #
  #  virtualHosts."customdesktop.localdomain" = {
  #  #virtualHosts."customdesktop" = {
  #    forceSSL = true;
  #    enableACME = true;
  #  };
  #};

}
