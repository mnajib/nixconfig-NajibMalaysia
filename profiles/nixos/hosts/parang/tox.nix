{ pkgs, config, ... }:
{
  networking.firewall = {
    # Open port 33445 for both UDP and TCP to allow direct peer connections
    allowedTCPPorts = [ 33445 ];
    allowedUDPPorts = [ 33445 ];
  
    # Optional: If you run multiple clients at once or want a safety buffer 
    # allowedUDPPortRanges = [ { from = 33445; to = 33450; } ];
  };

}
