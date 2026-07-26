# ./profiles/home-manager/users/najib/nyxora/default.nix
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

    #(./. + "/${commonDir}/neovim")
    #(./. + "/${commonDir}/ai.nix")

    (fromCommon "repo-bootstrap.nix")
  ];

  programs.repo-bootstrap.enable = true;
  programs.repo-bootstrap.basePath = "~/src";

  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/src/nixconfig-NajibMalaysia";
  };

  /*
  nixpkgs.config = {
    allowUnfree = true;
  };
  */

  home.packages = with pkgs; [
    #vscode

    # Install the compiled output from your external flake directly into your path
    inputs.my-nvim.packages.${pkgs.system}.default

    inputs.my-emacs.packages.${pkgs.system}.default

  ];

  #programs.neovim = {
  #  enable = true;
  #  # Point the module to your custom input
  #  package = inputs.my-nvim.packages.${pkgs.system}.default;
  #};

  # This forces your Home Manager bin directory to the start of your $PATH
  #home.sessionVariables = {
  #  PATH = "$HOME/.nix-profile/bin:/etc/profiles/per-user/najib/bin:$PATH";
  #};
  #
  # XXX: In your home-manager bash/zsh alias definition:
  home.shellAliases = {
    nvim = "${inputs.my-nvim.packages.${pkgs.system}.default}/bin/nvim";
  };

  # Optional: Set environment variables to make it your primary system default
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  #home.stateVersion = "22.05";
  #home.stateVersion = "24.11";
  home.stateVersion = "${stateVersion}";
}
