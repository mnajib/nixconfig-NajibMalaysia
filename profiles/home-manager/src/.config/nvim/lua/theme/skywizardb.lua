-- skywizardb.lua

-- ----------------------------------------------------------------------------
-- Basic options
-- ----------------------------------------------------------------------------
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.mouse = "a"                  -- enable mouse everywhere
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.wildmode = { "longest", "list" }
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Line numbers
vim.opt.relativenumber = true

-- Syntax & filetype
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Color column
vim.opt.colorcolumn = { 40, 60, 80 }

-- Indentation (Config C: 2 spaces)
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.list = true
vim.opt.listchars = {
  trail = "█",
  tab = ">-",
  extends = "»",
  precedes = "«",
  nbsp = "•",
}

vim.opt.wrap = false
vim.opt.modeline = true
vim.opt.ttyfast = true

-- ----------------------------------------------------------------------------
-- Highlight groups
-- ----------------------------------------------------------------------------
local function Hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Normal text
Hi("Normal", { ctermbg = "black", ctermfg = "lightgrey", bg = "#000000", fg = "#d3d3d3" })

-- Line numbers
Hi("LineNr", { ctermfg = 11, ctermbg = 237, fg = "#525252", bg = "#333333" })

-- Color column
Hi("ColorColumn", { ctermbg = 238, bg = "#111111" })

-- Cursor
Hi("Cursor", { fg = "Black", bg = "Yellow", ctermfg = "Black", ctermbg = "Yellow" })

-- Cursor line & column
Hi("CursorLine", { cterm = {}, ctermbg = "DarkBlue", gui = "NONE", bg = "DarkBlue" })
Hi("CursorColumn", { ctermbg = "DarkBlue", bg = "DarkBlue" })
Hi("CursorLineNr", { cterm = { "underline" }, ctermfg = 11, gui = "bold", fg = "Yellow" })

-- Search
Hi("Search", { cterm = {}, ctermbg = "darkyellow", ctermfg = "black", gui = "NONE", bg = "darkyellow", fg = "black" })

-- MatchParen
Hi("MatchParen", { cterm = {}, ctermbg = "darkblue", ctermfg = "lightblue", gui = "NONE", bg = "darkblue", fg = "lightblue" })

-- Comments
Hi("Comment", { cterm = { "italic" }, ctermbg = "NONE", ctermfg = 238, gui = "italic", bg = "NONE", fg = "#444444" })

-- Optional: indent-blankline plugin highlights (commented out)
-- Hi("IndentBlankLine", { fg = "#444444", bg = "NONE", gui = "NONE" })
-- Hi("IndentBlankLineIndent", { fg = "white", bg = "green" })
-- Hi("IndentBlankLineWhitespace", { fg = "red", bg = "#444444" })
-- Hi("IndentBlankLineScope", { fg = "purple", bg = "blue" })

