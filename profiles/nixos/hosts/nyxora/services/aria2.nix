# File: profiles/nixos/hosts/nyxora/services/aria2.nix
#
# sudo systemctl restart aria2.service
# journalctl -u aria2.service -f
#

{ config, pkgs, ... }:

{

  # 1. Enable system-wide aria2 RPC service
  services.aria2 = {
    enable = true;
    downloadDir = "/var/public/downloads"; # Default download directory
    rpcListenPort = 6800;

    # Optional: Set RPC secret token for security
    #rpcSecretFile = "/run/secrets/aria2-rpc-token.txt";
    rpcSecretFile = pkgs.writeText "aria2-rpc-secret" "my-very-not-secure-token";

    # Custom aria2c flags
    settings = {
      "continue" = "true";
      "max-concurrent-downloads" = "5";
      "max-connection-per-server" = "16";
      "min-split-size" = "10M";
      "split" = "16";
      "enable-mmap" = "true";
      "file-allocation" = "falloc";
      "rpc-allow-origin-all" = "true";
      "rpc-listen-all" = "true";
    };
  };

  # 2. Open firewall port for local network RPC access (if accessing from other devices)
  # networking.firewall.allowedTCPPorts = [ 6800 ];

  # 3. Ensure download directory exists with proper permissions
  systemd.tmpfiles.rules = [
    "d /var/public/downloads 0777 aria2 RPC - -"
  ];

  # System-wide packages
  environment.systemPackages = with pkgs; [
    aria2   # CLI tool & RPC daemon
    ariang  # AriaNg web client
  ];

  ## Serve AriaNg static Web UI via Nginx on http://localhost:8080
  # Serve AriaNg static Web UI via Nginx on http://aria2.localdomain
  services.nginx = {
    enable = true;
    virtualHosts."aria2.localdomain" = {

      #listen = [
      #  #{ addr = "127.0.0.1"; port = 8080; }
      #  { addr = "127.0.0.1"; port = 8068; }
      #];

      locations."/" = {
        root = "${pkgs.ariang}/share/ariang";
        index = "index.html";

        #proxyPass = "http://127.0.0.1:6800";
        #proxyWebsockets = true;
      };

      # Reverse proxy /jsonrpc endpoint so AriaNg can communicate with aria2
      locations."/jsonrpc" = {
        proxyPass = "http://127.0.0.1:6800/jsonrpc";
        proxyWebsockets = true;
      };

    };
  };

}
