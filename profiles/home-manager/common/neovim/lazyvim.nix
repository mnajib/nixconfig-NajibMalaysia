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

    extraPackages = [
      pkgs.fd
      pkgs.lazygit
    ];

    # Custom vimrc lines
    extraConfig = builtins.readFile ../../src/.config/nvim/init.vim;

    #extraLuaPackages = [];

    extraLuaConfig = builtins.readFile ../../src/.config/nvim/init.lua;

    # Use Nix Package search engine to find even more plugins:
    # https://search.nixos.org/packages
    plugins = with pkgs.vimPlugins; [
      ##nvim-lspconfig
      #nvim-treesitter.withAllGrammars
      #plenary-nvim
      #gruvbox
      vim-gruvbox8
      #gruvbox-material
      #mini-nvim
      #nvim-tree-lua
      #vim-illuminate
      #vim-numbertoggle
      #yankring
      #vim-nix

      #{
      #  plugin = vim-startify;
      #  config = "let g:startify_change_to_vcs_root = 0";
      #  extraConfig = ''
      #    #...
      #  '';
      #}

      {
        plugin = LazyVim;
      }

    ]; # End programs.neovim.plugins

  }; # End progroms.neovim

} # End let ... in { ... }
