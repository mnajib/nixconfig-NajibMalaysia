# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  hostName = "khawlah";
  userName = "naqib";
  stateVersion = "22.05";
in
{
  # You can import other home-manager modules here
  imports = [
    ../default.nix

    #../../neovim
  ];

  #xdg.portal.enable = true;

  #----------------------------------------------------------
  # disable stylix on specifix programs
  #
  #stylix.targets.nixvim.enable = false;
  #wayland.windowManager.hyprland.settings.general."col.active_border" = lib.mkForce "rgb(${config.stylix.base16Scheme.base0E})";
  #----------------------------------------------------------

  home.packages = with pkgs; [
    #neovim # then need to manually install(configure) lazyvim plugin from github
    inputs.my-nvim.packages.${pkgs.system}.default
    inputs.my-emacs.packages.${pkgs.system}.default

    gcc
    #clang clang-tools clang-manpages
    superfile
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "${stateVersion}"; # 22.05";
}
