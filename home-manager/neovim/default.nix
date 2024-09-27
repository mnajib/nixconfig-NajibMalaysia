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
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    #viAlias = true;
    #vimAlias = true;
    #vimdiffAlias = true;

    # Use Nix Package search engine to find even more plugins:
    # https://search.nixos.org/packages
    plugins = with pkgs.vimPlugins; [
      ##nvim-lspconfig
      #nvim-treesitter.withAllGrammars
      #plenary-nvim
      #gruvbox-material
      #mini-nvim
      #nvim-tree-lua
      #vim-illuminate
      #vim-numbertoggle

      #{
      #plugin = vim-startify;
      #config = "let g:startify_change_to_vcs_root = 0";
      #}

    ]; # End programs.neovim.plugins

    extraConfig = builtins.readFile ../src/.config/nvim/init.vim;
  }; # End progroms.neovim

} # End let ... in { ... }
