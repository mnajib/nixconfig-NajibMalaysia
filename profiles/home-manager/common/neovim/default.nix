#
# Ref:
#   - https://github.com/nix-community/nixvim
#     - https://nix-community.github.io/nixvim/
#   - https://github.com/nix-community/kickstart-nix.nvim
#     - https://github.com/mnajib/neovim-config-NajibMalaysia?tab=readme-ov-file
#   - https://nix.dev/tutorials/nix-language
#

{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}:
let
  #color = pkgs.writeText "color.vim" (import ./theme.nix config.colorscheme);
  inherit (inputs.nix-colors) colorSchemes;
  #inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) colorschemeFromPicture nixWallpaperFromScheme;

  configPath = ../../src/.config/nvim;
in
{

  imports = [
    inputs.nix-colors.homeManagerModule
  ];

  colorscheme = lib.mkDefault colorSchemes.dracula;

  #home.packages = with pkgs; [
    #gcc
  #];

  programs.neovim = {
    enable = true;

    defaultEditor = true;
    #viAlias = true;
    #vimAlias = true;
    #vimdiffAlias = true;
    #withNodeJs = true;  # optional: for plugins that use Node.js

    extraPackages = with pkgs; [
      gcc
      gnumake
      ripgrep
      xclip xsel

      #nerdfonts
      nerd-fonts._0xproto
      nerd-fonts.jetbrains-mono
      nerd-fonts.droid-sans-mono

      typescript-language-server
      vim-language-server
      lua-language-server
      nginx-language-server
      matlab-language-server
      lua-language-server
      typescript-language-server
      haskell-language-server
      yaml-language-server
      dot-language-server
      bash-language-server
      autotools-language-server
      cmake-language-server
      arduino-language-server
      nixd nil
      shfmt
      #packer
      lua
      luarocks-nix
      fd
      lazygit
      go
      python312Packages.pip
    ];

    # Custom vimrc lines
    #extraConfig = builtins.readFile ../../src/.config/nvim/init.vim;

    #extraLuaPackages = [];

    # Custom lua lines
    #extraLuaConfig = builtins.readFile ../../src/.config/nvim/init.lua;

    # Use Nix Package search engine to find even more plugins:
    # https://search.nixos.org/packages
    plugins = with pkgs.vimPlugins; [
      ##nvim-lspconfig
      #nvim-treesitter.withAllGrammars
      #plenary-nvim
      #gruvbox
      vim-gruvbox8
      #gruvbox-material
      #gruvbox-material-nvim
      #mini-nvim
      #nvim-tree-lua
      #vim-illuminate
      #vim-numbertoggle
      #yankring
      #vim-nix
      #vim-godot
      #orgmode

      #{
      #  plugin = vim-startify;
      #  config = "let g:startify_change_to_vcs_root = 0";
      #  extraConfig = ''
      #    #...
      #  '';
      #}

      #{
      #  plugin = indent-blankline-nvim;
      #  type = "lua";
      #  config = /* lua */ ''
      #    require('ibl').setup() -- {
      #      -- indent = {
      #      --  char = "|"
      #      -- },
      #      -- scope = {
      #      --   enabled = false
      #      -- },
      #    -- }
      #  '';
      #  #extraConfig = ''
      #  #  require("ibl").setup()
      #  #'';
      #}

      #{
      #  plugin = orgmode;
      #  config = "require('orgmode').setup()";
      #  #config = /* lua */ ''
      #  #  -- Setup orgmode
      #  #  require('orgmode').setup({
      #  #    org_agenda_files = '~/orgfiles/**/*',
      #  #    org_default_notes_file = '~/orgfiles/refile.org',
      #  #  })
      #  #'';
      #  config = ''
      #      lua << EOF
      #      require('orgmode').setup({
      #        org_agenda_files = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
      #        org_default_notes_file = '~/Dropbox/org/refile.org',
      #      })
      #      EOF
      #    '';
      #}

      #{
      #  plugin = LazyVim;
      #}

    ]; # End programs.neovim.plugins

  }; # End programs.neovim


  home.file.".config/nvim/init.lua" = {
    #source = "${configPath}/init.lua";
    source = configPath + "/init.lua";
  };

  # Recursively copy the lua/ directory with all its files
  home.file.".config/nvim/lua" = {
    #source = "${configPath}/lua";
    source = configPath + "/lua";
    recursive = true;
  };



} # End let ... in { ... }
