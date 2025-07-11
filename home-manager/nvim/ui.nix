{ pkgs, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    # UI
    vim-illuminate
    vim-numbertoggle
    # vim-markology
    {
      plugin = vim-fugitive;
      type = "viml";
      config = /* vim */ ''
        nmap <space>G :Git<CR>
      '';
    }
    {
      plugin = nvim-bqf;
      type = "lua";
      config = /* lua */ ''
        require('bqf').setup{}
      '';
    }
    {
      plugin = alpha-nvim;
      type = "lua";
      config = /* lua */ ''
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
              "                                                     ",
              "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
              "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
              "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
              "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
              "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
              "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
              "                                                     ",
        }
        dashboard.section.header.opts.hl = "Title"

        dashboard.section.buttons.val = {
            dashboard.button( "n", "󰈔 New file" , ":enew<CR>"),
            dashboard.button( "e", " Explore", ":Explore<CR>"),
            dashboard.button( "g", " Git summary", ":Git | :only<CR>"),
            dashboard.button( "s", " Notes", ":e ~/Documents/Notes<CR>"),
            dashboard.button( "c", "  Nix config flake" , ":e ~/Documents/NixConfig/flake.nix<CR>"),
        }

        alpha.setup(dashboard.opts)
        vim.keymap.set("n", "<space>h", ":Alpha<CR>", { desc = "Open home dashboard" })
      '';
    }
    {
      plugin = bufferline-nvim;
      type = "lua";
      config = /* lua */ ''
        require('bufferline').setup{}
      '';
    }
    {
      plugin = scope-nvim;
      type = "lua";
      config = /* lua */ ''
        require('scope').setup{}
      '';
    }
    {
      plugin = which-key-nvim;
      type = "lua";
      config = /* lua */ ''
        require('which-key').setup{}
      '';
    }
    {
      plugin = range-highlight-nvim;
      type = "lua";
      config = /* lua */ ''
        require('range-highlight').setup{}
      '';
    }

#----------------------------------------------------------
# Not using this because in this configuration, i have problem
# where regex replacement preview not display correctly
#----------------------------------------------------------
#    {
#      plugin = indent-blankline-nvim;
#      type = "lua";
#      config = /* lua */ ''
#        --local highlight = {
#        --  "CursorColumn",
#        --  "Whitespace",
#        --}
#        require('ibl').setup{
#          indent = {
#            --highlight = {"IndentBlankLine"},
#            --highlight = {"CursorColumn"},
#            highlight = {"IndentBlankLineIndent"},
#            --char = {"┆"}
#            --char = {"╎"}
#            --char = {"▏"}
#            --char = "┊",
#            char = "",
#          },
#          whitespace = {
#            --highlight = {"IndentBlankLine"},
#            --highlight = {"IndentBlankLineWhitespace"},
#            remove_blankline_trail = true,
#          },
#          scope = {
#            enabled = false,
#            --highlight = {"IndentBlankLineScope"},
#            char = "┊",
#          },
#          debounce = 100,
#        }
#      '';
#    }
#----------------------------------------------------------

    {
      plugin = nvim-web-devicons;
      type = "lua";
      config = /* lua */ ''
        require('nvim-web-devicons').setup{}
      '';
    }
    {
      plugin = gitsigns-nvim;
      type = "lua";
      config = /* lua */ ''
        require('gitsigns').setup{
          signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
          },
        }
      '';
    }
    {
      plugin = nvim-colorizer-lua;
      type = "lua";
      config = /* lua */ ''
        require('colorizer').setup{}
      '';
    }
    {
      plugin = fidget-nvim;
      type = "lua";
      config = /* lua */ ''
        require('fidget').setup{
          --text = {
          --  spinner = "dots",
          --},
        }
      '';
    }
  ];
}
