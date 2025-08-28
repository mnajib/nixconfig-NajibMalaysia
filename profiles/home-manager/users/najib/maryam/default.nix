# profiles/home-manager/users/najib/maryam/default.nix
#
# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{
  inputs, outputs,
  lib,
  config, pkgs,
  ...
}:
let
  username = "najib";
  hostname = "maryam";
  commonDir = "../../../common";
  stateVersion = "25.05";
in
{
  # You can import other home-manager modules here
  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
    fromCommonWithParams = name: params: import ( ./. + "/${toString commonDir}/${name}" ) params;
  in [
    ../default.nix

    (fromCommon "p2p.nix")

    (fromCommon "neovim")
    #../../neovim/astronvim.nix

    (fromCommon "helix")

    #../../barrier.nix
    #(import ../../barrier.nix { inherit hostname config pkgs lib inputs outputs; }) # Pass hostname and other args

    #(fromCommonWithParams "repo-bootstrap.nix" { basePath = "~/src"; })
    #(fromCommonWithParams "repo-bootstrap.nix" { basePath = "src"; })
    (fromCommon "repo-bootstrap.nix")
  ];

  programs.repo-bootstrap = {
    enable = true;
    basePath = "~/src";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "${stateVersion}"; #"22.05";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    #...
  ];
}
