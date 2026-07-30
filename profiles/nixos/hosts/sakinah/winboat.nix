# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    winboat libvirt docker freerdp
    pciutils
  ];

  virtualisation.docker.enable = true;

  #users.users.a.extraGroups = [
  #  "wheel" "docker" "kvm" "networkmanager"
  #];
  users.users.najib.extraGroups = [
    "wheel" "docker" "kvm" "networkmanager"
  ];
  users.users.naqib.extraGroups = [
    "wheel" "docker" "kvm" "networkmanager"
  ];

  networking.firewall = {
    allowedTCPPorts = [
      3389 7148 8006 # Open the ports required for Docker container-host communication. For WinBoat
    ];
  };

}

