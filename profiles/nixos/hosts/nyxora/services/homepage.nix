# File: profiles/nixos/hosts/nyxora/services/homepage.nix
#
# Directs http://www.localdomain to a Haskell-backed local dashboard.
# Ensure www.localdomain resolves to this host in local DNS/hosts file.
#

{ config, pkgs, ... }:

let
  # Substitute relative "index.html" in Main.hs with absolute store path ${./index.html}
  haskellSource = builtins.replaceStrings
    [ "\"index.html\"" ]
    [ "\"${./index.html}\"" ]
    (builtins.readFile ./Main.hs);

  # Compile Haskell web server executable using GHC with scotty, text, and file-embed
  homepageServer = pkgs.writers.writeHaskellBin "homepage-server" {
    libraries = [
      pkgs.haskellPackages.scotty
      pkgs.haskellPackages.text
      pkgs.haskellPackages.file-embed
    ];
  } haskellSource;
in
{
  # 1. Systemd background service running the Haskell server
  systemd.services.homepage-server = {
    description = "Haskell Local Homepage Dashboard Web Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${homepageServer}/bin/homepage-server";
      Restart = "always";
      DynamicUser = true;
    };
  };

  # 2. Nginx Reverse Proxy pointing www.localdomain -> http://127.0.0.1:8081
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."www.localdomain" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8081";
        proxyWebsockets = true;
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 ];
    allowedUDPPorts = [ 80 ];
  };

}
