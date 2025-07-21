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

  #programs.neovim = {
  #  enable = true;
  #
  #  defaultEditor = true;
  #  #viAlias = true;
  #  #vimAlias = true;
  #  #vimdiffAlias = true;
  #
  #  extraPackages = [];
  #
  #  # Custom vimrc lines
  #  #extraConfig = builtins.readFile ../src/.config/nvim/init.vim;
  #  extraConfig = ''
  #    set nocompatible            " disable compatibility to old-time vi
  #  '';
  #
  #  plugins = with pkgs.vimPlugins; [
  #    ##nvim-lspconfig
  #    #{
  #    #  plugin = vim-startify;
  #    #  config = "let g:startify_change_to_vcs_root = 0";
  #    #  extraConfig = ''
  #    #    #...
  #    #  '';
  #    #}
  #  ]; # End programs.neovim.plugins
  #
  #}; # End progroms.neovim

} # End let ... in { ... }
