{ pkgs, inputs, ... }:

{
  # Imports the Nixvim Home Manager module (make sure inputs.nixvim is added to your flake)
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # 1. Global Editor Options (Replaces raw Lua vim.opt)
    opts = {
      number = true;         # Show line numbers
      relativenumber = true; # Relative line numbers
      shiftwidth = 2;        # Size of an indent
      tabstop = 2;           # Number of spaces tabs count for
      expandtab = true;      # Use spaces instead of tabs
    };

    globals.mapleader = " "; # Set space as leader key

    # 2. Purely Managed Themes
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    # 3. Declarative Plugins
    # Nixvim automatically downloads, registers, and loads these from the Nix store.
    plugins = {

      # Enable the central menu engine
      which-key = {
        enable = true;

        # Optional: fine-tune the look and feel
        settings = {
          preset = "classic"; # Clean, traditional popup look
          win = {
            border = "single"; # Clean border lines for the menu box
          };
        };
      };

      # File tree navigation
      neo-tree.enable = true;

      # Statusline
      lualine.enable = true;

      # Telescope for fuzzy finding
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = {
            action = "find_files";
            settings.desc = "Find Project Files"; # This label appears in the menu
          };
          "<leader>fg" = {
            action = "live_grep";
            settings.desc = "Grep Text in Project"; # This label appears in the menu
          };
        };
      };

      # Treesitter handles high-performance, predictable syntax highlighting.
      # Nix paths compile parsers at system build time, not runtime!
      treesitter = {
        enable = true;
        settings.ensure_installed = [ "nix" "lua" "haskell" "java" ];
      };

      # Native LSP (Language Server Protocol) integration
      # Nixvim injects the language servers into Neovim's PATH automatically.
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true; # Nix language server
          hls = {
            enable = true;      # Haskell Language Server
            installGhc = false; # Best practice: let your local shell handle GHC
          };
        };
      };
    };

    # Custom keymaps can also be explicitly registered with labels for the menu
    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "Toggle File Explorer";
      }
    ];

  }; # End programs.nixvim = { ... };

}
