{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    #barrier
    #input-leap
    deskflow
  ];

  networking.firewall.allowedTCPPorts = [ 24800 ];
  networking.firewall.allowedUDPPorts = [ 24800 ];
}
