# profiles/nixos/hosts/nyxora/services/tailscale.nix
#
# NOTE:
#   sudo nixos-rebuild switch
#   sudo tailscale up
#

{ config, pkgs, ... }: {

  # 1. Enable IP Forwarding for both IPv4 and IPv6
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Enable the Tailscale service daemon
  services.tailscale = {
    enable = true;
    #package = pkgs.tailscale;
    useRoutingFeatures = "both";
    openFirewall = true;
  };

  # Explicitly add the package to environment.systemPackages
  # so the 'tailscale' CLI tool is accessible in your shell
  environment.systemPackages = [
    #pkgs.tailscale
  ];

  # Configure UDP GRO forwarding optimization on eno1
  systemd.services.tailscale-gro-optimization = {
    description = "Optimize UDP GRO forwarding for Tailscale exit node on eno1";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/bin/ethtool -K eno1 rx-udp-gro-forwarding on rx-gro-list on";
      RemainAfterExit = true;
    };
  };

  # Configure the firewall to play nice with Tailscale
  networking.firewall = {
    enable = true;
 
    # Always trust the tailscale interface to allow internal traffic
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
 
    # Allow the Tailscale UDP port for direct peer-to-peer connections
    allowedUDPPorts = [ config.services.tailscale.port ];

    # Required for exit nodes: permits masquerading/NAT so outside traffic 
    # hitting nyxora can be routed out to the open internet.
    #checkReversePath = "loose";
  };

}
