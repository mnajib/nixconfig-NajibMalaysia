{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    barrier
    input-leap
  ];

  networking.firewall.allowedTCPPorts = [ 24800];
  #networking.firewall.allowedUDPPorts = [];
}
