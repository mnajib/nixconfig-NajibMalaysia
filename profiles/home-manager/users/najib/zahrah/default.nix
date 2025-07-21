# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  hostname = "zahrah";
in
{
  # You can import other home-manager modules here
  imports = [
    ../default.nix

    ../../p2p.nix

    ../../neovim
    #../../neovim/astronvim.nix

    ../../helix

    #../../barrier.nix
    (import ../../barrier.nix { inherit hostname config pkgs lib inputs outputs; }) # Pass hostname and other args
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";

  #home.packages = with pkgs; [
    #...
  #];
}
