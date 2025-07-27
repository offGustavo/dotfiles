-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

--------------------------------------------
-- AUTOCOMDS                              --
--------------------------------------------

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    -- vim.opt_local.spell = false
    -- vim.opt_local.conceallevel = 3
    vim.opt_local.wrap = false
  end,
})

-- vim.api.nvim_create_autocmd("ColorScheme", {
--   group = vim.api.nvim_create_augroup("wezterm_colorscheme", { clear = true }),
--   callback = function(args)
--     local colorschemes = {
--       ["tokyonight-day"] = "Tokyo Night Day",
--       ["tokyonight-storm"] = "Tokyo Night Storm",
--       ["tokyonight-night"] = "Tokyo Night",
--       ["tokyonight"] = "Tokyo Night",
--       ["catppuccin-frappe"] = "Catppuccin Frappe",
--       ["catppuccin-latte"] = "Catppuccin Latte",
--       ["catppuccin-macchiato"] = "Catppuccin Macchiato",
--       ["catppuccin-mocha"] = "Catppuccin Mocha",
--       ["gruvbox"] = "GruvboxDark",
--       -- add more color schemes here ...
--     }
--     local colorscheme = colorschemes[args.match]
--     if not colorscheme then
--       return
--     end
--     -- Write the colorscheme to a file
--     local filename = vim.fn.expand("$XDG_CONFIG_HOME/wezterm/colorscheme")
--     assert(type(filename) == "string")
--     local file = io.open(filename, "w")
--     assert(file)
--     file:write(colorscheme)
--     file:close()
--     vim.notify("Setting WezTerm color scheme to " .. colorscheme, vim.log.levels.INFO)
--   end,
-- })
--

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local colorscheme = vim.g.colors_name or "default"
    local file = io.open(vim.fn.stdpath("config") .. "/theme", "w")
    if file then
      file:write(colorscheme)
      file:close()
    end
  end,
})
