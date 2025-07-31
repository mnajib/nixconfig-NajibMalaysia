# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{
  lib, config, pkgs,
  inputs, outputs,
  ...
}:
let
  username = "najib";
  hostname = "nyxora";
  commonDir = "../../../common";
  stateVersion = "24.11";
in
{
  # You can import other home-manager modules here
  imports = [
    ../default.nix

    (./. + "/${commonDir}/neovim")
    #(./. + "/${commonDir}/ai.nix")
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  home.packages = with pkgs; [
    vscode
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  #home.stateVersion = "22.05";
  #home.stateVersion = "24.11";
  home.stateVersion = "${stateVersion}";
}
