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

    ../../neovim
    ../../helix
  ];

  home.packages = with pkgs; [
    #neovim
    #gcc
    #gnumake
    #ripgrep
    #xclip xsel
    #nerdfonts
    #typescript-language-server
    #vim-language-server
    #lua-language-server
    #haskell-language-server
    #dot-language-server
    #bash-language-server
    #shfmt
    #packer
    #lua
    #luarocks-nix
    #fd
    #lazygit
    #go
    #python312Packages.pip
  ];

  #programs.nixvim {
  #  enable = true;
  #  package = pkgs.nixvim; # use the overlaid nixvim package
  #};

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
