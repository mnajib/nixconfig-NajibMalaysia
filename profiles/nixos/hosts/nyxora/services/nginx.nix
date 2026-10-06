# profiles/nixos/hosts/nyxora/services/nginx.nix

{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    clientMaxBodySize = "50m";

    # Catch-all default server block to prevent accidental routing to PostgREST
    virtualHosts."default" = {
      default = true;
      rejectSSL = true;
      extraConfig = ''
        return 404;
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [
    80 # http
    443 # https
  ];
  networking.firewall.allowedUDPPorts = [
    443 # HTTP/3 (QUIC). HTTP/3 Need SSL/TLS
  ];
}
