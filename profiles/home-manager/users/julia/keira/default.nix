# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
#let
#  name = "Juliani Jaffar";
#  email = "jung_jue@yahoo.com";
#in
{
  # You can import other home-manager modules here
  imports = [
    #../../default.nix
    ../default.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  #home.stateVersion = "22.11";
  home.stateVersion = "24.05";
}
