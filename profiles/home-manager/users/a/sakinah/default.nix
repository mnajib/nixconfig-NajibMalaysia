# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  username = "a";
  hostname = "sakinah";
  commonDir = "../../../common";
  stateVersion = "26.05";
in
{
  # You can import other home-manager modules here
  imports = let
    # For simple modules (no params)
    fromCommon = name: ./. + "/${toString commonDir}/${name}";

    # For modules that take params
    fromCommonWithParams = name: params: import (./. + "/${toString commonDir}/${name}") params;
  in [
    ../default.nix

    #(fromCommon "neovim")
    (fromCommon "repo-bootstrap.nix")
  ];

  programs.repo-bootstrap.enable = true;
  programs.repo-bootstrap.basePath = "~/src";

  #----------------------------------------------------------
  # disable stylix on specifix programs
  #
  #stylix.targets.nixvim.enable = false;
  #wayland.windowManager.hyprland.settings.general."col.active_border" = lib.mkForce "rgb(${config.stylix.base16Scheme.base0E})";
  #----------------------------------------------------------

  home.packages = with pkgs; [
    #neovim # then need to manually install(configure) lazyvim plugin from github

    #gcc
    #clang clang-tools clang-manpages
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  #home.stateVersion = "22.05";
  home.stateVersion = "${stateVersion}";
}
