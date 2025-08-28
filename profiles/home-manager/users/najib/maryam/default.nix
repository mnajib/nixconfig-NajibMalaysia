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

  # !!! This will overrides the whole 'programs.repo-bootstrap config imported from 'common/repo-bootstrap.nix' !!!
  #programs.repo-bootstrap = {
  #  enable = true;
  #  basePath = "~/src";
  #};
  #
  # Instead of overriding (which erases repos), extend settings here
  #programs.repo-bootstrap = lib.mkMerge [
  #  # Host-specific overrides
  #  {
  #    enable = true;
  #    basePath = "~/src";
  #    #autoFetch = true; # example override
  #    #linkEnable = false; # example override
  #  }
  #
  #  # Keep everything imported from common/repo-bootstrap.nix
  #  config.programs.repo-bootstrap
  #];
  #
  # Instead of setting 'programs.repo-bootstrap' in maryam/default.nix, just import your 'common/repo-bootstrap.nix' and then »
  # 'repos' comes from 'common/repo-bootstrap.nix'; 'enable' and 'basePath' are overridden, but only those keys, not the whole»
  programs.repo-bootstrap.enable = true;
  programs.repo-bootstrap.basePath = "~/src";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "${stateVersion}"; #"22.05";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    #...
  ];
}
