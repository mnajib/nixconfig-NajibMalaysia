# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
#let
#  hostname = "khadijah";
#in
{
  # You can import other home-manager modules here
  imports = [
    ../default.nix

    #../../neovim
  ];

  #----------------------------------------------------------
  # disable stylix on specifix programs
  #
  #stylix.targets.nixvim.enable = false;
  #wayland.windowManager.hyprland.settings.general."col.active_border" = lib.mkForce "rgb(${config.stylix.base16Scheme.base0E})";
  #----------------------------------------------------------

  home.packages = with pkgs; [
    neovim # then need to manually install(configure) lazyvim plugin from github

    gcc
    #clang clang-tools clang-manpages
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
