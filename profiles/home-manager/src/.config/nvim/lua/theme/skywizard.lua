-- ~/.config/nvim/lua/theme/skywizard.lua
--
-- I try to follow colour scheme that used (and maybe also originally created) by Ariff Abdullah (aka SkyWizard)
-- as I not found where did I save the vimrc file personally gaved by him to me.
--
-- Current list of applied setting can be displayed using command ':hi' in neovim.

-- ----------------------------------------------------------------------------
local M = {}

local function Hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- function M.setup()
  --vim.cmd("hi clear")
  vim.o.background = "dark"
  vim.g.colors_name = "skywizard"

  -- Search related
  Hi("IncSearch",                       { reverse = true })
  Hi("Search",                          { bg = "#444444", fg = "#ffffff" })

  -- Command-line completion
  Hi("WildMenu",                        { fg = "Black", bg = "Yellow" })

  -- UI elements
  Hi("Visual",                          { bg = "#285577" })
  Hi("CursorLine",                      { bg = "#1c1c1c" })
  --Hi("StatusLine",                      { fg = "#ffffff", bg = "#005f87", bold = true })
  --Hi("StatusLineNC",                    { fg = "#aaaaaa", bg = "#262626" })
  Hi("StatusLine",                      { reverse = true, bold = true })
  Hi("StatusLineNC",                    { reverse = true })

  -- Diagnostics (if you want to override LSP colors)
  Hi("DiagnosticError",                 { fg = "#ff5f5f" })
  Hi("DiagnosticWarn",                  { fg = "#ffaf00" })
  Hi("DiagnosticInfo",                  { fg = "#5fafff" })
  Hi("DiagnosticHint",                  { fg = "#5fff5f" })

  -- Base UI
  Hi( "Normal",                         { fg = "LightGrey", bg = "Black" })
  Hi( "CursorLine",                     { bg = "#1a1a1a" })

  Hi( "LineNr",                         { fg = "#696969", bg = "#333333" })
  Hi( "CursorLineNr",                   { fg = "#ffcc66", bg = "#1a1a1a", bold = true })

  Hi( "ColorColumn",                    { bg = "#111111" })

  Hi( "Comment",                        { fg = "#444444", italic = true })

  -- oren --> merah cair ?
  Hi( "String",                         { fg = "#ffa0a0" })                  -- "hello"
  Hi( "Constant",                       { fg = "#ffa0a0" })                  -- TRUE, FALSE
  Hi( "Character",                      { fg = "#ffa0a0" })
  Hi( "Number",                         { fg = "#ffa0a0" })                  -- 123
  Hi( "Boolean",                        { fg = "#ffa0a0" })
  Hi( "Float",                          { fg = "#ffa0a0" })

  --hl(0, "Function",                   { fg = "#81a2be" })                  -- do_something()
  Hi( "Function",                       { fg = "#40ffff" })                  -- do_something()
  --hl(0, "Identifier",                 { fg = "#f99157" })                  -- $foo
  Hi( "Identifier",                     { fg = "#40ffff" })                  -- $foo

  -- Kuning
  Hi( "Statement",                      { fg = "#ffff60", bold = true })
  Hi( "Keyword",                        { fg = "#ffff60", bold = true })     -- def, end, return

  -- Oren --> Coklat
  Hi( "Tag",                            { fg = "Orange" })
  --hl(0, "Special",                    { fg = "#f99157" })                  -- special chars
  Hi( "Special",                        { fg = "Orange" })                  -- special chars
  Hi( "SpecialChar",                    { fg = "Orange" })
  Hi( "Delimiter",                      { fg = "Orange" })
  Hi( "SpecialComment",                 { fg = "Orange" })
  Hi( "Debug",                          { fg = "Orange" })

  -- Hijau
  Hi( "Type",                           { fg = "#60ff60", bold = true })                  -- class, module, etc.

  -- ungu
  Hi( "PreProc",                        { fg = "#ff80ff" })

  Hi( "WarningMsg",                     { fg = "Red" })
  Hi( "ErrorMsg",                       { fg = "White", bg = "Red" })
  Hi( "Error",                          { fg = "White", bg = "Red" })
  Hi( "Todo",                           { fg = "Blue", bg = "Yellow" })

  -- hl(0, "IncSearch",                 { reverse = true })
  Hi( "Title",                          { fg = "Magenta", bold = true })
  Hi( "WildMenu",                       { fg = "Black", bg = "Yellow" })

  -- Cursor
  Hi( "Cursor",                         { fg = "#000000", bg = "#cccccc" })

  Hi("Folded",                          { fg = "Cyan", bg = "DarkGrey" })
  Hi("FoldColumn",                      { fg = "Cyan", bg = "Grey" })

  -- Show invisible characters
  vim.opt.list = true
  vim.opt.listchars = {
    trail = "█",
    tab = ">-",
    extends = "»",
    precedes = "«",
    nbsp = "•"
  }
  Hi( "Whitespace",                     { fg = "Blue", bold = true })
  Hi( "NonText",                        { fg = "Blue", bold = true })

  -- Color column
  vim.opt.colorcolumn = { 40, 60, 80 }
  Hi( "ColorColumn",                    { bg = "#111111" })

-- end


-- return M
