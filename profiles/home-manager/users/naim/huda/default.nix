# profiles/home-manager/users/naim/huda/default.nix
#
# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  username = "naim";
  hostname = "huda";
  commonDir = "../../../common";
  stateVersion = "25.05"; #"25.11"
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

    #--------------------------------------------------------------------------
    # NOTE
    #--------------------------------------------------------------------------
    #
    # To test:
    #   cd ~/src/nixconfig-NajibMalaysia
    #   nh os test . -- --override-input mc-project path:/home/naqib/src/minecraft-infra
    #
    # To switch:
    #   cd ~/src/nixconfig-NajibMalaysia
    #   nix flake update mc-project
    #   nh os switch .
    #
    inputs.mc-project.homeModules.minecraft-client
    #mc-project.homeModules.minecraft-client

  ];

  #programs.repo-bootstrap.enable = true;
  programs.repo-bootstrap.basePath = lib.mkForce "~/src";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    #neovim # then need to manually install(configure) lazyvim plugin from github
    #lazyvim
    #gtk-pipe-viewer # CLI youtube client
    vscode

    inputs.my-nvim.packages.${pkgs.system}.default
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

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
