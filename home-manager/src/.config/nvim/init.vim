set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching
set ignorecase              " case insensitive
set mouse=v                 " middle-click paste with
set hlsearch                " highlight search
set incsearch               " incremental search
set wildmode=longest,list   " get bash-like tab completions
set termguicolors           " enabling true color

set background=dark
highlight Normal ctermbg=black ctermfg=lightgrey guibg=black guifg=lightgrey

set number                  " add line numbers
"highlight LineNr ctermfg=11 guifg=Yellow ctermbg=DarkGrey guibg=DarkGrey
highlight LineNr ctermfg=11 guifg=Yellow ctermbg=237 guibg=#100c08

filetype plugin indent on   " allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on

" set an 80 column border for good coding style
"set colorcolumn=80
set colorcolumn=40,60,80
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
