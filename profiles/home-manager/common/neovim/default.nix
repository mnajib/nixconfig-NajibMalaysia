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
    viAlias = true;
    vimAlias = true;
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

    extraConfig = ''
      lua << EOF
        -- ~/.config/nvim/init.lua

        require("nvim-treesitter.configs").setup {
          highlight = { enable = true },
        }

        -- Enable italics for terminal (place at top of file)
        --vim.cmd([[
        --  let &t_ZH = "\e[3m"
        --  let &t_ZR = "\e[23m"
        --]])
        --
        --vim.o.t_ZH = "\27[3m"
        --vim.o.t_ZR = "\27[23m"

        vim.opt.termguicolors = true
        vim.opt.background = "dark"
        vim.cmd("syntax enable")

        -- Can try 'default', 'elflord', etc.
        --vim.cmd("colorscheme desert")
        vim.cmd("colorscheme default")

        vim.opt.compatible = false
        vim.opt.ruler = true
        vim.opt.wrap = false
        vim.opt.backspace = { 'indent', 'eol', 'start' }
        vim.opt.backup = false
        vim.opt.writebackup = false
        vim.opt.swapfile = false

        --vim.opt.tabstop = 8
        --vim.opt.shiftwidth = 2
        --vim.opt.autoindent = true
        --
        vim.opt.tabstop = 2           -- number of columns occupied by a tab
        vim.opt.softtabstop = 2           -- see multiple spaces as tabstops so <BS> does the right thing
        vim.opt.shiftwidth = 2            -- width for autoindents
        vim.opt.expandtab = true               -- converts tabs to white space
        vim.opt.autoindent = true              --indent a new line the same amount as the line just typed

        vim.opt.sidescroll = 1
        vim.opt.showmode = true
        vim.opt.ttyfast = true
        vim.opt.visualbell = true
        vim.opt.laststatus = 2
        vim.opt.statusline = "%F %m%r%h%w (%{&ff}) [Line:%l (%p%%) / Column:%v]"
        vim.opt.modeline = true
        vim.opt.background = "dark"
        --vim.opt.number = true

        -- GUI specific (optional)
        if vim.fn.has("gui_running") == 1 then
          vim.opt.lines = 30
          vim.opt.columns = 80
          vim.opt.mousehide = true
          vim.opt.guifont = "LucidaTypeWriter:h10"
          vim.opt.guioptions = vim.opt.guioptions - 'T'
        end

        -- ----------------------------------------------------------------------------
        -- Show invisible characters
        vim.opt.list = true
        vim.opt.listchars = {
          trail = "█",
          tab = ">-",
          extends = "»",
          precedes = "«",
          nbsp = "•"
        }

        -- ----------------------------------------------------------------------------
        -- Load SkyWizard colorscheme
        require("theme.skywizard")
        -- require("theme.skywizardb")
        -- require("theme.NajibMalaysia")

        -- ----------------------------------------------------------------------------
        -- Optional keymaps (can be moved to separate Lua module)
        vim.keymap.set('i', '<F1>', '<Esc>:q<CR>')
        vim.keymap.set('n', '<F1>', ':q<CR>')
        vim.keymap.set('i', '<S-F1>', '<Esc>:q!<CR>')
        vim.keymap.set('n', '<S-F1>', ':q!<CR>')
        vim.keymap.set('i', '<F2>', '<Esc>:w<CR>')
        vim.keymap.set('n', '<F2>', ':w<CR>')
        vim.keymap.set('i', '<F3>', '<Esc>:wq<CR>')
        vim.keymap.set('n', '<F3>', ':wq<CR>')
        vim.keymap.set('n', '<F4>', function()
          if vim.g.synon == 1 then
            vim.cmd("syntax off")
            vim.g.synon = 0
            print("Syntax: OFF")
          else
            vim.cmd("syntax on")
            vim.g.synon = 1
            print("Syntax: ON")
          end
        end)
        vim.g.synon = 1
        vim.cmd("syntax on")

      EOF
    '';

    #extraLuaPackages = [];

    # Custom lua lines
    #extraLuaConfig = builtins.readFile ../../src/.config/nvim/init.lua;

    # Use Nix Package search engine to find even more plugins:
    # https://search.nixos.org/packages
    plugins = with pkgs.vimPlugins; [
      ##nvim-lspconfig
      #nvim-treesitter
      nvim-treesitter.withAllGrammars
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

  #home.file.".config/nvim/init.lua" = {
  #  #source = "${configPath}/init.lua";
  #  source = configPath + "/init.lua";
  #};

  # Recursively copy the lua/ directory with all its files
  home.file.".config/nvim/lua" = {
    #source = "${configPath}/lua";
    source = configPath + "/lua";
    recursive = true;
  };



} # End let ... in { ... }
