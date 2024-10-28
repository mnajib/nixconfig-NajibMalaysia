{
  config,
  pkgs,
  #inputs,
  #lib,
  #outputs,
  ... }:
let
  #color = pkgs.writeText "color.vim" (import ./theme.nix config.colorscheme);
in
{

  home.packages = with pkgs; [
    #gcc
  ];

  programs.helix.enable = true;
  #programs.helix.defaultEditor = true;

  programs.helix.extraPackages = with pkgs; [
    marksman
    helix-gpt
    #evil-helix
    vim-language-server
    haskell-language-server
    bash-language-server
  ];

  programs.helix.ignores = [];

  programs.helix.languages = {};

  programs.helix.settings = {};

  programs.helix.themes = {};

} # End let ... in { ... }
