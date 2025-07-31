# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  username = "root";
  hostname = "nyxora";
  commonDir = "../../../common";
  stateVersion = "24.11";
in
{
  # You can import other home-manager modules here
  imports = [
    ../default.nix # common shared for root user on all hosts

    #(./. + "/${commonDir}/neovim")
    #(./. + "/${commonDir}/stylix.nix")
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  #home.stateVersion = "24.11";
  home.stateVersion = "${stateVersion}";
}
