{
  config,
  pkgs,
  #inputs,
  #lib,
  #outputs,
  ... }:
#let
#  #color = pkgs.writeText "color.vim" (import ./theme.nix config.colorscheme);
#in
{

  #home.packages = with pkgs; [
  #  #gcc
  #];

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

  #programs.helix.languages = {};

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

      #keyskeys.normal = {
        #space.space = "file_picker";
        #space.w = ":w";
        #space.q = ":q";
        #esc = [ "collapse_selection" "keep_primary_selection" ];

        # Navigation
        #"h" = "move_down";
        #"t" = "move_up";
        #"d" = "move_left";
        #"n" = "move_right";

        # Editing
        #"i" = "insert_mode";
        #"a" = "append";
        #"x" = "delete_selection";
        #"y" = "yank_selection";
      #};

    }; # End programs.helix.editor
  };

  #programs.helix.themes = {};

} # End let ... in { ... }
