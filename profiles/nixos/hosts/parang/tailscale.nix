# profiles/nixos/hosts/parang/tailscale.nix

{ pkgs, config, ... }:
{

  # 1. Enable the Tailscale service daemon
  services.tailscale.enable = true;

  # 2. Firewall adjustments
  networking.firewall = {
    
    # Strictly trusted interfaces. 
    # This ensures your NixOS firewall treats your Tailnet as safe.
    trustedInterfaces = [ "tailscale0" ];
    
    # LAPTOP/EXIT NODE TWEAK: 
    # If you intend to use another machine as an "Exit Node" (routing all laptop 
    # internet traffic through it), NixOS's strict reverse path filtering will drop packets.
    # Setting this to "loose" fixes that.
    checkReversePath = "loose";
  };

}
