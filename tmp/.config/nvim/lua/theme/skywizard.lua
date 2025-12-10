-- ~/.config/nvim/lua/theme/skywizard.lua

vim.cmd("hi clear")
vim.o.background = "dark"
vim.g.colors_name = "skywizard"

local hl = vim.api.nvim_set_hl

-- Base UI
--hl(0, "Normal",        { fg = "#aaaaaa", bg = "#000000" })
hl(0, "Normal",        { fg = "LightGrey", bg = "Black" })
--hl(0, "LineNr",        { fg = "#444444", bg = "#000000" })
hl(0, "LineNr",        { fg = "#525252", bg = "#333333" })
hl(0, "CursorLine",    { bg = "#1a1a1a" })
hl(0, "CursorLineNr",  { fg = "#ffcc66", bg = "#1a1a1a", bold = true })
hl(0, "ColorColumn",   { bg = "#111111" })

-- Syntax groups (exact color codes from Ariff's HTML Vim)
--hl(0, "Comment",       { fg = "#666666", italic = true })   -- // comment
--hl(0, "Comment",       { fg = "#80a0ff", italic = true })   -- // comment
--hl(0, "Comment",       { fg = "#444444", italic = true })   -- // comment
--hl(0, "Comment",       { fg = "#333333", italic = true })   -- // comment
hl(0, "Comment",       { fg = "#2a2a2a", italic = true })   -- // comment
--hl(0, "Comment",       { fg = "#1a1a1a", italic = true })   -- // comment

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

