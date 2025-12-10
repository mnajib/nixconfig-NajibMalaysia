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
  imports = let
    # For simple modules (no params)
    fromCommon = name: ./. + "/${toString commonDir}/${name}";

    # For modules that take params
    fromCommonWithParams = name: params: import (./. + "/${toString commonDir}/${name}") params;
  in [
    ../default.nix

    (./. + "/${commonDir}/neovim")
    #(./. + "/${commonDir}/ai.nix")

    (fromCommon "repo-bootstrap.nix")
  ];

  programs.repo-bootstrap.enable = true;
  programs.repo-bootstrap.basePath = "~/src";

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
