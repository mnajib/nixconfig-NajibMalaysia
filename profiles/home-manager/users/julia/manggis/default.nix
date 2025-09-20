# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  user_name = "julia";
  user_fullname = "Juliani Jaffar";
  user_email = "jung_jue@yahoo.com";
  commonDir = "../../../common";
  stateVersion = "24.05";
in
{
  # You can import other home-manager modules here
  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [
    ../default.nix

    #(fromCommon "neovim")
  ];

  home.packages = with pkgs; [
    #
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  #home.stateVersion = "22.11";
  #home.stateVersion = "24.05";
  home.stateVersion = stateVersion;
  #home.stateVersion = "${stateVersion}";
}
