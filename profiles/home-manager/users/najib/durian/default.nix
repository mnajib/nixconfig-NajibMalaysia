# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  username = "najib";
  hostname = "durian";
  stateVersion = "25.11";
  commonDir = "../../../common";
in {
  # You can import other home-manager modules here
  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [
    ../default.nix

    (fromCommon "neovim")
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "${stateVersion}";
}
