# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  username = "julia";
  hostname = "keira";
  commonDir = "../../../common";
  stateVersion = "24.05";
  name = "Juliani Jaffar";
  email = "jung_jue@yahoo.com";
  fromCommon = name: ./. + "/${toString commonDir}/${name}";
in
{
  # You can import other home-manager modules here
  imports = [
    #../../default.nix
    ../default.nix

    (fromCommon "niri-desktop")
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  #home.stateVersion = "22.11";
  #home.stateVersion = "24.05";
  home.stateVersion = "${stateVersion}";
}
