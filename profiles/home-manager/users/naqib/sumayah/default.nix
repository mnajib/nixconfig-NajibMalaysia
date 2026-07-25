# profiles/home-manager/users/naqib/sumayah/default.nix
#
# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{
  inputs, outputs, lib, config, pkgs,
  #my-nvim,
  ...
}:
let
  username = "naqib";
  hostname = "sumayah";
  commonDir = "../../../common";
  stateVersion = "25.05";
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

  programs.repo-bootstrap.enable = true;
  programs.repo-bootstrap.basePath = "~/src";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    #neovim # then need to manually install(configure) lazyvim plugin from github
    #lazyvim
    inputs.my-nvim.packages.${pkgs.system}.default
    #my-nvim

    gtk-pipe-viewer # CLI youtube client
  ];

  #programs.neovim = {
  #  enable = true;
  #  package = inputs.my-nvim.packages.${pkgs.system}.default;
  #};

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
