{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    barrier
  ];

  networking.firewall.allowedTCPPorts = [ 24800];
  #networking.firewall.allowedUDPPorts = [];
}
