# profiles/nixos/hosts/printer2/raspberrypi2b.nix

{ config, pkgs, lib, ... }:

{

  # Fact: Explicitly declares the hardware architecture for Nixpkgs cross-evaluation
  nixpkgs.hostPlatform = "armv7l-linux";

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  hardware.enableRedistributableFirmware = true;

}
