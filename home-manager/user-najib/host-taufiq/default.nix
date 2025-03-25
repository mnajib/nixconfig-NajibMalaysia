# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
#let
#  hostname = "nyxora";
#in
{
  # You can import other home-manager modules here
  imports = [
    ../default.nix

    #../../stylix.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  #home.stateVersion = "22.05";
  home.stateVersion = "24.11";
}
