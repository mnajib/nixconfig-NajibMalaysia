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
vim.keymap.set("n", "<leader>r", ":ReloadConfig<CR>", { noremap = true, silent = true })
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
    -- vim.cmd("colorscheme gruvbox8")  -- Example: 256-color theme
    vim.cmd("colorscheme default")
  elseif term == "linux" then
    vim.opt.termguicolors = false  -- Fallback to basic 16 colors
    vim.cmd("colorscheme default") -- Example: ANSI theme
    -- vim.cmd("colorscheme gruvbox8") -- Example: ANSI theme
  else
    print("Unknown TERM: " .. term .. ", defaulting to ANSI colors.")
    vim.opt.termguicolors = false
    vim.cmd("colorscheme default")
    -- vim.cmd("colorscheme gruvbox8")
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
