-- ~/.config/nvim/lua/theme/najib-minimal.lua
local hl = vim.api.nvim_set_hl

-- Base UI
hl(0, "Normal",        { fg = "#D8DEE9", bg = "#1E1E1E" }) -- base text
hl(0, "CursorLine",    { bg = "#2A2A2A" })
hl(0, "CursorLineNr",  { fg = "#FFFF00", bg = "#2A2A2A" })
hl(0, "LineNr",        { fg = "#4B5263", bg = "#1E1E1E" })
hl(0, "ColorColumn",   { bg = "#333333" })

-- Syntax
hl(0, "Comment",       { fg = "#5C6370", italic = true })
hl(0, "Keyword",       { fg = "#61AFEF", bold = true })   -- e.g. `if`, `function`
hl(0, "Function",      { fg = "#56B6C2" })                -- user-defined or builtin
hl(0, "Constant",      { fg = "#C678DD" })                -- strings, numbers
hl(0, "String",        { fg = "#98C379" })
hl(0, "Type",          { fg = "#E5C07B" })                -- `int`, `str`, `bool`, etc.
hl(0, "Cursor",        { fg = "#000000", bg = "#FFFF00" }) -- optional

