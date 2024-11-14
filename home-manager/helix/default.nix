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
  programs.helix.defaultEditor = false;

  programs.helix.package = pkgs.helix;
  #programs.helix.package = pkgs.evil-helix;

  programs.helix.extraPackages = with pkgs; [
    marksman
    helix-gpt
    vim-language-server
    haskell-language-server
    bash-language-server
  ];

  programs.helix.ignores = [
    ".build/"
    "!.gitignore"
  ];

  programs.helix.languages = {};

  programs.helix.settings = {
    editor = {
      # export COLORTERM=truecolor
      true-color = true;

      #whitespace.render = "all";
      whitespace.render = {
        space = "all";
        tab = "all";
        nbsp = "none";
        nnbsp = "none";
        newline = "none";
      };
      #whitespace.characters = {
      #  space = "·";
      #  nbsp = "⍽";
      #  nnbsp = "␣";
      #  tab = "→";
      #  newline = "⏎";
      #  tabpad = "·";
      #};

      indent-guides = {
        render = true;
      };

    }; # End programs.helix.editor
  };

  programs.helix.themes = {};

} # End let ... in { ... }
