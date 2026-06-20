-- ~/.config/nvim/lua/theme/skywizard.lua
--
-- Modified to adapt Ariff Abdullah's (SkyWizard) layout structure into
-- a high-contrast, minimalist Gemini dark UI color palette.
--
-- Current list of applied settings can be displayed using command ':hi' in neovim.

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
  Hi("Search",                          { bg = "#2d2d30", fg = "#ffffff" })

  -- Command-line completion
  Hi("WildMenu",                        { fg = "Black", bg = "#FABC3F" })

  -- UI elements
  Hi("Visual",                          { bg = "#1b354d" }) -- Clean slate blue selection
  Hi("CursorLine",                      { bg = "#0c0c0c" })
  Hi("StatusLine",                      { reverse = true, bold = true })
  Hi("StatusLineNC",                    { reverse = true })

  -- Diagnostics (Gemini style functional tones)
  Hi("DiagnosticError",                 { fg = "#ff5f5f" })
  Hi("DiagnosticWarn",                  { fg = "#FABC3F" })
  Hi("DiagnosticInfo",                  { fg = "#5AB2FF" })
  Hi("DiagnosticHint",                  { fg = "#a0a0a0" })

  -- Base UI (Pure Gemini Slate Black Canvas)
  Hi( "Normal",                         { fg = "#E3E3E3", bg = "#000000" }) -- Off-white text on pitch black
  Hi( "CursorLine",                     { bg = "#0c0c0c" })

  -- Dark grey layout gutters to blend seamlessly into the black backdrop
  Hi( "LineNr",                         { fg = "#444444", bg = "#080808" })
  Hi( "CursorLineNr",                   { fg = "#FABC3F", bg = "#0c0c0c", bold = true })

  -- Subdued vertical column markers
  Hi( "ColorColumn",                    { bg = "#0a0a0a" })

  -- Muted mid-tone gray for clean, non-distracting comments
  Hi( "Comment",                        { fg = "#686D76", italic = true })

  -- Gemini Neon Pink / Magenta Palette (Data Literals)
  Hi( "String",                         { fg = "#FF64B4" })                  -- "hello"
  Hi( "Constant",                       { fg = "#FF64B4" })                  -- TRUE, FALSE
  Hi( "Character",                      { fg = "#FF64B4" })
  Hi( "Number",                         { fg = "#FF64B4" })                  -- 123
  Hi( "Boolean",                        { fg = "#FF64B4" })
  Hi( "Float",                          { fg = "#FF64B4" })

  -- Gemini Neon Yellow Palette (Execution & Control flow)
  Hi( "Function",                       { fg = "#FABC3F" })                  -- do_something()
  Hi( "Identifier",                     { fg = "#E3E3E3" })                  -- $foo (Keep standard text color for clarity)
  Hi( "Statement",                      { fg = "#FABC3F", bold = true })
  Hi( "Keyword",                        { fg = "#FABC3F", bold = true })     -- def, end, return

  -- Gemini Electric Blue Palette (Types and Structural Nodes)
  Hi( "Type",                           { fg = "#5AB2FF", bold = true })     -- class, module, Int, Date

  -- Delimiters & Special Characters (Subdued blue/grey variant to avoid clutter)
  Hi( "Tag",                            { fg = "#5AB2FF" })
  Hi( "Special",                        { fg = "#a0a0a0" })                  -- special chars
  Hi( "SpecialChar",                    { fg = "#FF64B4" })
  Hi( "Delimiter",                      { fg = "#8a8a8a" })                  -- brackets, parens, commas
  Hi( "SpecialComment",                 { fg = "#686D76" })
  Hi( "Debug",                          { fg = "#ff5f5f" })

  -- Preprocessor commands
  Hi( "PreProc",                        { fg = "#5AB2FF" })

  -- Error States
  Hi( "WarningMsg",                     { fg = "#FABC3F" })
  Hi( "ErrorMsg",                       { fg = "#ffffff", bg = "#ff5f5f" })
  Hi( "Error",                          { fg = "#ffffff", bg = "#ff5f5f" })
  Hi( "Todo",                           { fg = "#000000", bg = "#FABC3F" })

  Hi( "Title",                          { fg = "#5AB2FF", bold = true })

  -- Cursor
  Hi( "Cursor",                         { fg = "#000000", bg = "#E3E3E3" })

  Hi("Folded",                          { fg = "#5AB2FF", bg = "#0c0c0c" })
  Hi("FoldColumn",                      { fg = "#444444", bg = "#080808" })

  -- Show invisible characters (Subdued to dark gray so they don't fight the syntax colors)
  vim.opt.list = true
  vim.opt.listchars = {
    trail = "·",
    tab = "» ",
    extends = "»",
    precedes = "«",
    nbsp = "•"
  }
  Hi( "Whitespace",                     { fg = "#262626" })
  Hi( "NonText",                        { fg = "#262626" })

  -- Color column configuration
  vim.opt.colorcolumn = { 40, 60, 80 }
  Hi( "ColorColumn",                    { bg = "#0a0a0a" })

-- end


-- return M
