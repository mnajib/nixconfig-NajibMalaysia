# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  username = "root";
  hostname = "khadijah";
  stateVersion = "22.05";
in
{
  # You can import other home-manager modules here
  imports = [
    ../default.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = stateVersion;
}
