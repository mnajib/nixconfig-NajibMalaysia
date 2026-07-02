{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.nix-colors.homeManagerModule            # Preserved from your config
  ];

  colorscheme = lib.mkDefault inputs.nix-colors.colorSchemes.dracula;

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # 1. Native Global Options (Replaces your raw vim.opt lines)
    opts = {
      termguicolors = true;
      background = "dark";
      compatible = false;
      ruler = true;
      wrap = false;
      backup = false;
      writebackup = false;
      swapfile = false;

      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      autoindent = true;

      sidescroll = 1;
      showmode = true;
      laststatus = 2;
      modeline = true;

      backspace = [ "indent" "eol" "start" ];
      statusline = "%F %m%r%h%w (%{&ff}) [Line:%l (%p%%) / Column:%v]";

      # Show invisible characters configuration
      list = true;
      listchars = {
        trail = "█";
        tab = ">-";
        extends = "»";
        precedes = "«";
        nbsp = "•";
      };
    };

    # 2. Central Menu System (which-key)
    plugins.which-key = {
      enable = true;
      settings = {
        preset = "classic";
        win.border = "single";
      };
    };

    # 3. Syntax Highlighting (Treesitter)
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        ensure_installed = [ "nix" "lua" "haskell" "java" "typescript" "bash" "cmake" ];
      };
    };

    # 4. Pure Declarative LSPs (No more manual extraPackages listing!)
    plugins.lsp = {
      enable = true;
      servers = {
        nil_ls.enable = true;       # Nix
        hls = {
          enable = true;            # Haskell
          installGhc = false;
        };
        ts_ls.enable = true;        # TypeScript
        lua_ls.enable = true;       # Lua
        bashls.enable = true;       # Bash
        cmake.enable = true;        # CMake
        nginx_as.enable = true;     # Nginx
      };
    };

    # 5. Additional Plugins from your list
    plugins.vimwiki = {
      enable = true;
    };





    # Text Search & Treesitter Syntax
    plugins.telescope.enable = true;
    treesitter = {
      enable = true;
      settings.ensure_installed = [ "nix" "lua" "haskell" "java" "typescript" ];
    };

    # Vimwiki from your current module
    plugins.vimwiki.enable = true;

    # Indent Blankline Setup
    plugins.indent-blankline = {
      enable = true;
      settings = {
        indent.char = "│";
        scope.enabled = true;
      };
    };

    # Orgmode Setup
    plugins.orgmode = {
      enable = true;
      settings = {
        org_agenda_files = [ "~/Dropbox/org/*" "~/my-orgs/**/*" ];
        org_default_notes_file = "~/Dropbox/org/refile.org";
      };
    };

    # Native LSP Server configurations
    plugins.lsp = {
      enable = true;
      servers = {
        nil_ls.enable = true;
        hls = { enable = true; installGhc = false; };
        ts_ls.enable = true;
        lua_ls.enable = true;
      };
    };





    # 6. Keymaps (Your functional F1-F4 shortcuts, labeled for the which-key menu)
    keymaps = [
      # F1: Close buffer/editor
      { mode = "i"; key = "<F1>"; action = "<Esc>:q<CR>"; options.desc = "Quit Editor"; }
      { mode = "n"; key = "<F1>"; action = ":q<CR>";     options.desc = "Quit Editor"; }
      { mode = "i"; key = "<S-F1>"; action = "<Esc>:q!<CR>"; options.desc = "Force Quit"; }
      { mode = "n"; key = "<S-F1>"; action = ":q!<CR>";     options.desc = "Force Quit"; }

      # F2: Save
      { mode = "i"; key = "<F2>"; action = "<Esc>:w<CR>"; options.desc = "Save File"; }
      { mode = "n"; key = "<F2>"; action = ":w<CR>";     options.desc = "Save File"; }

      # F3: Save and Quit
      { mode = "i"; key = "<F3>"; action = "<Esc>:wq<CR>"; options.desc = "Save and Quit"; }
      { mode = "n"; key = "<F3>"; action = ":wq<CR>";     options.desc = "Save and Quit"; }
    ];

    # For your complex F4 syntax toggle function, we use raw Lua execution
    extraConfigLua = ''
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
      end, { desc = "Toggle Syntax Highlighting" })

      vim.g.synon = 1
      vim.cmd("syntax on")

      -- Safely require your custom local theme directory if symlinked
      pcall(require, "theme.skywizard")
    '';
  };

  # Kept to ensure your custom theme scripts continue loading perfectly
  #home.file.".config/nvim/lua" = {
  #  source = configPath + "/lua";
  #  recursive = true;
  #};
  # Keeps your existing local custom theme directories mirrored safely
  home.file.".config/nvim/lua" = {
    source = ../../src/.config/nvim/lua;
    recursive = true;
  };

}
