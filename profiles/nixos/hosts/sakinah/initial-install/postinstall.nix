# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{

  # programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
    #brave

    telegram-desktop
    zapzap whatsie karere # whatsapp

    libreoffice
    miro zathura sioyek meowpdf evince papers

    # winboat libvirt docker freerdp # commented because winboat use unsecure electron version package

    pciutils

    xterm
    sakura
    dmenu rofi

  ];

  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.fluxbox.enable = true;
  services.xserver.windowManager.awesome.enable = true;

  virtualisation.docker.enable = true;
  users.users.a.extraGroups = [
    "wheel" "docker" "kvm" "networkmanager"
  ];

  networking.firewall = {
    enable = true;

    allowedTCPPorts = [
      3389 7148 8006 # Open the ports required for Docker container-host communication. For WinBoat
    ];

  };

}

