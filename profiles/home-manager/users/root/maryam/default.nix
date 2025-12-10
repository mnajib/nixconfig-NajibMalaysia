# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  username = "root";
  hostname = "maryam";
  email = "root@zahrah.localdomain";
  commonDir = "../../../common";
in
{
  # You can import other home-manager modules here
  imports = [
    ../default.nix

    #(./. + "/${commonDir}/helix")
    (./. + "/${commonDir}/neovim")
  ];

  programs.git = lib.mkForce {
    userName = "${username}";
    userEmail = "${email}";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05"; #"24.11";
}
