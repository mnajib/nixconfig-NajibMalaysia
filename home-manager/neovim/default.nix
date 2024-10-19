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

    extraPackages = [];

    # Custom vimrc lines
    #extraConfig = builtins.readFile ../src/.config/nvim/init.vim;
    extraConfig = ''
      set nocompatible            " disable compatibility to old-time vi
      set showmatch               " show matching
      set ignorecase              " case insensitive
      set mouse=v                 " middle-click paste with
      set hlsearch                " highlight search
      set incsearch               " incremental search
      set wildmode=longest,list   " get bash-like tab completions


      "set termguicolors           " enabling true color; Comment this out for use only ANSI colors
      "------------------------------------------------------------------------------
      " Use different color schemes based on the TERM variable
      "if $TERM == "linux"
      "  " Use a basic color scheme for 16 colors
      "  "set t_Co=8  " Set the number of colors to 8 (basic ANSI)
      "  set termguicolors=false
      "  colorscheme default  " Use the default color scheme
      "else
      "  " Use a color scheme that supports 256 colors
      "  set t_Co=256  " Set the number of colors to 256
      "  set termguicolors=true
      "  colorscheme gruvbox  " Example: Use a 256-color scheme like gruvbox
      "endif
      "------------------------------------------------------------------------------


      set background=dark
      highlight Normal ctermbg=black ctermfg=lightgrey guibg=black guifg=lightgrey

      ""set number                  " add line numbers
      "set relativenumber                  " add line numbers
      ""highlight LineNr ctermfg=11 guifg=Yellow ctermbg=DarkGrey guibg=DarkGrey
      ""highlight LineNr ctermfg=11 guifg=Yellow ctermbg=237 guibg=#100c08
      "highlight LineNr ctermfg=11   ctermbg=237
      "highlight LineNr guifg=#525252 guibg=#333333

      filetype plugin indent on   " allow auto-indenting depending on file type
      syntax on                   " syntax highlighting
      set mouse=a                 " enable mouse click
      set clipboard=unnamedplus   " using system clipboard
      filetype plugin on

      " set an 80 column border for good coding style
      "set colorcolumn=80
      "set colorcolumn=40,60,80 " disable this when use only ANSI colors
      " if using ANSI-16
      "highlight ColorColumn ctermbg=16
      " if using 256 color terminal
      highlight ColorColumn ctermbg=238 guibg=#111111

      " XXX: security risk ???
      set modeline                " to make vim/nvim load setting in file header


      "------------------------------------------------------------------------------
      " Note
      "------------------------------------------------------------------------------
      " To listing cterm's color code:
      "   python ~/bin/cterm-colors.py


      "------------------------------------------------------------------------------
      " Cursor
      "------------------------------------------------------------------------------
      "highlight Cursor guifg=bg guibg=fg
      "highlight Cursor guifg=bg guibg=#626262
      "highlight Cursor guifg=Black guibg=Yellow
      highlight Cursor guifg=Black guibg=Yellow ctermfg=Black ctermbg=Yellow

      "set cursorline              " highlight current cursorline
      "set cursorcolumn

      "highlight CursorLine guibg=#303030
      "highlight CursorLine cterm=NONE ctermbg=242 gui=NONE guibg=Grey40
      "highlight CursorColumn ctermbg=242 guibg=Grey40
      highlight CursorLine cterm=NONE ctermbg=DarkBlue gui=NONE guibg=DarkBlue
      highlight CursorColumn ctermbg=DarkBlue guibg=DarkBlue
      highlight CursorLineNr cterm=underline ctermfg=11 gui=bold guifg=Yellow
      "------------------------------------------------------------------------------


      "------------------------------------------------------------------------------
      " Search hit
      "------------------------------------------------------------------------------
      "highlight Search cterm=NONE ctermbg=darkyellow ctermfg=lightyellow
      "highlight Search gui=NONE guibg=darkyellow guifg=lightyellow
      highlight Search cterm=NONE ctermbg=darkyellow ctermfg=black
      highlight Search gui=NONE guibg=darkyellow guifg=black
      "------------------------------------------------------------------------------


      "------------------------------------------------------------------------------
      " Match parenthesis
      "------------------------------------------------------------------------------
      "highlight MatchParen cterm=none ctermbg=green ctermfg=blue
      "highlight MatchParen cterm=none ctermbg=green ctermfg=blue guibg=NONE guifg=brue gui=bold
      highlight MatchParen cterm=NONE ctermbg=darkblue ctermfg=lightblue
      highlight MatchParen gui=NONE guibg=darkblue guifg=lightblue
      "------------------------------------------------------------------------------


      "------------------------------------------------------------------------------
      " Comments
      "------------------------------------------------------------------------------
      "highlight Comment cterm=italic ctermbg=NONE ctermfg=darkgrey
      "highlight Comment gui=italic guibg=NONE guifg=darkgrey
      highlight Comment cterm=italic ctermbg=NONE ctermfg=238
      highlight Comment gui=italic guibg=NONE guifg=#444444
      "------------------------------------------------------------------------------


      set ttyfast                 " Speed up scrolling in Vim
      "set spell                  " enable spell check (may need to download language package)
      "set noswapfile             " disable creating swap file
      "set backupdir=~/.cache/vim " Directory to store backup files.


      "------------------------------------------------------------------------------
      " indent-blankline
      "------------------------------------------------------------------------------
      "highlight IndentBlankLine               guifg=#444444 guibg=NONE gui=NONE guisp=NONE
      "highlight IndentBlankLineIndent         guifg=white guibg=green gui=NONE guisp=NONE
      "highlight IndentBlankLineWhitespace     guifg=red guibg=#444444 gui=NONE guisp=NONE
      "highlight IndentBlankLineScope          guifg=purple guibg=blue gui=NONE guisp=NONE
      "------------------------------------------------------------------------------


      "------------------------------------------------------------------------------
      " Indent Config A: Use tab(s) for indentation
      "------------------------------------------------------------------------------
      "set tabstop=4              " number of columns occupied by a tab
      "set softtabstop=4          " see multiple spaces as tabstops so <BS> does the right thing
      "set shiftwidth=4           " width for autoindents
      "set autoindent             " indent a new line the same amount as the line just typed
      "set list
      "set listchars=tab:>\ ,trail:-,nbsp:+,space:·,eol:$
      "set noexpandtab
      "------------------------------------------------------------------------------
      " NOTE:
      "     for modeline; 5 first lines in file
      "     Example:
      "     #·vim:·set·noexpandtab·tabstop=4·softtabstop=4·shiftwidth=4·autoindent·list·listchars=tab\:»\·,trail\:█,nbsp\:•: ,space\:·
      "------------------------------------------------------------------------------


      "------------------------------------------------------------------------------
      " Indent Config B: Use 4 spaces for indentation
      "------------------------------------------------------------------------------
      "set tabstop=4              " number of columns occupied by a tab
      "set softtabstop=4          " see multiple spaces as tabstops so <BS> does the right thing
      "set shiftwidth=4           " width for autoindents
      "set expandtab              " converts tabs to white space
      "set autoindent             " indent a new line the same amount as the line just typed
      "set list
      "set listchars=tab:>\ ,trail:-,nbsp:+
      "------------------------------------------------------------------------------


      "------------------------------------------------------------------------------
      " Indent Config C: Use 2 spaces for indentation
      "------------------------------------------------------------------------------
      set tabstop=2               " number of columns occupied by a tab
      set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
      set shiftwidth=2            " width for autoindents
      set expandtab               " converts tabs to white space
      set autoindent              " indent a new line the same amount as the line just typed
      set list
      "set listchars=tab:>-,trail:-,nbsp:+
      "set listchars=nbsp:█,eol:¶,tab:>-,extends:»,precedes:«,trail:•
      "set listchars=trail:█,eol:¶,tab:>-,extends:»,precedes:«,nbsp:•
      set listchars=trail:█,tab:>-,extends:»,precedes:«,nbsp:•
      "------------------------------------------------------------------------------

      set nowrap

      "set title
      "set titlestring=%{hostname()}\ \ %F\ \ %{strftime('%Y%m%dT%H:%M', getftime(expand('%')))}

      "call plug#begin(“~/.vim/plugged”)
      " “ Plugin Section
      " Plug 'dracula/vim'
      " Plug 'ryanoasis/vim-devicons'
      " Plug 'SirVer/ultisnips'
      " Plug 'honza/vim-snippets'
      " Plug 'scrooloose/nerdtree'
      " Plug 'preservim/nerdcommenter'
      " Plug 'mhinz/vim-startify'
      " Plug 'neoclide/coc.nvim', {'branch': 'release'}
      "call plug#end()
    '';

    #extraLuaPackages = [];

    # Custom lua lines
    extraLuaConfig = ''


      -- -----------------------------------------------------------------------
      local function reload_nvim_config()
        -- Clear all loaded Lua modules to force reloading them
        for name, _ in pairs(package.loaded) do
          if name:match("^user") or name:match("^plugins") then  -- Adjust to match your config structure
            package.loaded[name] = nil
          end
        end

        -- Reload the init.lua (or init.vim)
        dofile(vim.env.MYVIMRC)

        print("Neovim configuration reloaded!")
      end

      -- Create a user command to trigger the reload
      vim.api.nvim_create_user_command("ReloadConfig", reload_nvim_config, {})
      -- Now, when you need to reload the config, simply run:
      -- :ReloadConfig

      -- Optionally, can configure keybinding to reload config quickly
      -- vim.keymap.set("n", "<leader>r", ":ReloadConfig<CR>", { noremap = true, silent = true })
      -- Now, pressing <leader>r will reload your Neovim configuration instantly.
      -- -----------------------------------------------------------------------


      -- Enable absolute line numbers for the current line
      vim.wo.number = true

      -- Enable relative line numbers for other lines
      -- vim.wo.relativenumber = true

      -- Set the width of the number column (optional)
      -- vim.wo.numberwidth = 4  -- Adjust as needed for your line numbers


      -- -----------------------------------------------------------------------
      -- To Switch Between 256 Colors and ANSI Colors
      local function set_color_mode()
        -- Detect the TERM environment variable
        local term = vim.env.TERM

        if term:match("256color") then
          vim.opt.termguicolors = true  -- Enable 24-bit colors
          vim.cmd("colorscheme gruvbox")  -- Example: 256-color theme
        elseif term == "linux" then
          vim.opt.termguicolors = false  -- Fallback to basic 16 colors
          vim.cmd("colorscheme default") -- Example: ANSI theme
        else
          print("Unknown TERM: " .. term .. ", defaulting to ANSI colors.")
          vim.opt.termguicolors = false
          vim.cmd("colorscheme default")
        end

      end

      -- Run the function on startup
      set_color_mode()

      -- Optional: Create a command to manually switch color modes
      vim.api.nvim_create_user_command("ReloadColors", set_color_mode, {})
      -- Now, when you nedd to switch color modes, simply run:
      -- :ReloadColors
      -- -----------------------------------------------------------------------


      -- Highlight settings for line numbers
      vim.cmd([[highlight LineNr ctermfg=11 ctermbg=237]])
      vim.cmd([[highlight LineNr guifg=#525252 guibg=#333333]])
    '';

    # Use Nix Package search engine to find even more plugins:
    # https://search.nixos.org/packages
    plugins = with pkgs.vimPlugins; [
      ##nvim-lspconfig
      #nvim-treesitter.withAllGrammars
      #plenary-nvim
      gruvbox
      #gruvbox-material
      #gruvbox-material-nvim
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

    ]; # End programs.neovim.plugins

  }; # End progroms.neovim

} # End let ... in { ... }
