-- ~/.config/nvim/lua/theme/skywizard.lua
--
-- I try to follow colour scheme that used (and maybe also originally created) by Ariff Abdullah (aka SkyWizard)
-- as I not found where did I save the vimrc file personally gaved by him to me.
--
-- Current list of applied setting can be displayed using command ':hi' in neovim.

-- ----------------------------------------------------------------------------
vim.cmd("hi clear")
vim.o.background = "dark"
vim.g.colors_name = "skywizard"

local hl = vim.api.nvim_set_hl

-- ----------------------------------------------------------------------------
-- Base UI
--hl(0, "Normal",        { fg = "#aaaaaa", bg = "#000000" })
hl(0, "Normal",        { fg = "LightGrey", bg = "Black" })
hl(0, "CursorLine",    { bg = "#1a1a1a" })

--hl(0, "LineNr",        { fg = "#444444", bg = "#000000" })
--hl(0, "LineNr",        { fg = "#525252", bg = "#333333" })
hl(0, "LineNr",        { fg = "#696969", bg = "#333333" })
hl(0, "CursorLineNr",  { fg = "#ffcc66", bg = "#1a1a1a", bold = true })

hl(0, "ColorColumn",   { bg = "#111111" })

-- Syntax groups (exact color codes from Ariff's HTML Vim)
-- brighter
--hl(0, "Comment",       { fg = "#666666", italic = true })   -- // comment
--hl(0, "Comment",       { fg = "#80a0ff", italic = true })   -- // comment
--hl(0, "Comment",       { fg = "#80a0ff", italic = true })   -- // comment
--hl(0, "Comment",       { fg = "#777777", italic = true })   -- // comment
--hl(0, "Comment",       { fg = "#666666", italic = true })   -- // comment
--hl(0, "Comment",       { fg = "#555555", italic = true })   -- // comment
hl(0, "Comment",       { fg = "#4a4a4a", italic = true })   -- // comment
--hl(0, "Comment",       { fg = "#444444", italic = true })   -- // comment
--hl(0, "Comment",       { fg = "#333333", italic = true })   -- // comment
--hl(0, "Comment",       { fg = "#2a2a2a", italic = true })   -- // comment
--hl(0, "Comment",       { fg = "#1a1a1a", italic = true })   -- // comment
-- darker

-- oren --> merah cair ?
hl(0, "String",        { fg = "#ffa0a0" })                  -- "hello"
hl(0, "Constant",      { fg = "#ffa0a0" })                  -- TRUE, FALSE
hl(0, "Character",     { fg = "#ffa0a0" })
hl(0, "Number",        { fg = "#ffa0a0" })                  -- 123
hl(0, "Boolean",        { fg = "#ffa0a0" })
hl(0, "Float",        { fg = "#ffa0a0" })

--hl(0, "Function",      { fg = "#81a2be" })                  -- do_something()
hl(0, "Function",      { fg = "#40ffff" })                  -- do_something()
--hl(0, "Identifier",    { fg = "#f99157" })                  -- $foo
hl(0, "Identifier",    { fg = "#40ffff" })                  -- $foo

-- Kuning
hl(0, "Statement",       { fg = "#ffff60", bold = true })
hl(0, "Keyword",       { fg = "#ffff60", bold = true })     -- def, end, return

-- Oren --> Coklat
hl(0, "Tag",       { fg = "Orange" })
--hl(0, "Special",       { fg = "#f99157" })                  -- special chars
hl(0, "Special",       { fg = "Orange" })                  -- special chars
hl(0, "SpecialChar",       { fg = "Orange" })
hl(0, "Delimiter",       { fg = "Orange" })
hl(0, "SpecialComment",       { fg = "Orange" })
hl(0, "Debug",       { fg = "Orange" })

-- Hijau
--hl(0, "Type",          { fg = "#b294bb" })                  -- class, module, etc.
hl(0, "Type",          { fg = "#60ff60", bold = true })                  -- class, module, etc.

-- ungu
hl(0, "PreProc",       { fg = "#ff80ff" })

hl(0, "Error",          { fg = "White", bg = "Red" })
hl(0, "Todo",          { fg = "Blue", bg = "Yellow" })

-- Cursor
 hl(0, "Cursor",        { fg = "#000000", bg = "#cccccc" })
--hl(0, "Cursor",        { fg = "#000000", bg = "#ffffff" })
-- hl(0, "Cursor", { fg = "Black", bg = "Yellow" })
-- hl(0, "lCursor", { fg = "White", bg = "Red" })

-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- Set color column at 40, 60, and 80
vim.opt.colorcolumn = { 40, 60, 80 }

-- Highlight the color column
vim.api.nvim_set_hl(0, "ColorColumn", {
  bg = "#111111"
})

-- ----------------------------------------------------------------------------
