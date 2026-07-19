# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  username = "naqib";
  hostname = "huda";
  commonDir = "../../../common";
  stateVersion = "25.11";
  #lazyvim = pkgs.lazygit.lazylvimPackages.lazylvim;
in
{
  # You can import other home-manager modules here
  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
    fromCommonWithParams = name: params: import ( ./. + "/${toString commonDir}/${name}" ) params;
  in [
    ../default.nix

    #(fromCommon "neovim")
    (fromCommon "repo-bootstrap.nix")
  ];

  programs.repo-bootstrap.basePath = lib.mkForce "~/Projects";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    #neovim # then need to manually install(configure) lazyvim plugin from github
    #lazyvim
    inputs.my-nvim.packages.${pkgs.system}.default

    gtk-pipe-viewer # CLI youtube client
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
  home.stateVersion = "${stateVersion}";
}
