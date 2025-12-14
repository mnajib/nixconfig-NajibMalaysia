# profiles/nixos/hosts/nyxora/proxmox.nix
{
  pkgs,
  lib,
  ...
}:
{

  nix.settings.substituters = [
    "https://cache.saumon.network/proxmox-nixos"
  ];
  nix.settings.trusted-public-keys = [
    "proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM="
  ];

  services.proxmox-ve = {
    enable = true;
    #ipAddress = "192.168.0.1";
    ipAddress = "192.168.0.23";
  };

  # look in flake.nix
  #nixpkgs.overlays = [
  #  proxmox-nixos.overlays.${system}
  #];

  #------------------------------------
  # Networking configurations with systemd-networkd

  # Make vmbr0 bridge visible in Proxmox web interface
  services.proxmox-ve.bridges = [ "vmbr0" ];

  # Actually set up the vmbr0 bridge
  systemd.network.networks."10-lan" = {
    matchConfig.Name = [ "ens18" ];
    networkConfig = {
      Bridge = "vmbr0";
    };
  };

  systemd.network.netdevs."vmbr0" = {
    netdevConfig = {
      Name = "vmbr0";
      Kind = "bridge";
    };
  };

  systemd.network.networks."10-lan-bridge" = {
    matchConfig.Name = "vmbr0";
    networkConfig = {
      IPv6AcceptRA = true;
      DHCP = "ipv4";
    };
    linkConfig.RequiredForOnline = "routable";
  };

  #------------------------------------

}
