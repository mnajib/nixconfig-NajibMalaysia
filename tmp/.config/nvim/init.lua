-- ~/.config/nvim/init.lua

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd("syntax enable")
vim.cmd("colorscheme desert") -- you can try 'default', 'elflord', etc.

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

-- Load SkyWizard colorscheme
require("theme.skywizard")
-- require("theme.NajibMalaysia")


-- 1. Show invisible characters
vim.opt.list = true
vim.opt.listchars = {
  trail = "█",
  tab = ">-",
  extends = "»",
  precedes = "«",
  nbsp = "•"
}

-- 2. Highlight them in blue
vim.api.nvim_set_hl(0, "Whitespace", { fg = "Blue", bold = true })
vim.api.nvim_set_hl(0, "NonText", { fg = "Blue", bold = true })


-- Set color column at 40, 60, and 80
vim.opt.colorcolumn = { 40, 60, 80 }

-- Highlight the color column
vim.api.nvim_set_hl(0, "ColorColumn", {
  bg = "#111111"
})


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

