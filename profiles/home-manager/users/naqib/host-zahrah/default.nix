# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  hostname = "zahrah";
  #lazyvim = pkgs.lazygit.lazylvimPackages.lazylvim;
in
{
  # You can import other home-manager modules here
  imports = [
    ../default.nix
  ];

  home.packages = with pkgs; [
    neovim # then need to manually install(configure) lazyvim plugin from github
    #lazyvim
  ];

  #services.home-manager.extraConfig = ''
  #  programs.lazylvim = {
    #    enable = true;
    #  package = pkgs.lazylvim;
    #  settings = ''
    #  '';
  #};
  #'';

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
