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
    vim.opt_local.conceallevel = 3
    vim.opt_local.wrap = false
  end,
})

-- vim.api.nvim_create_autocmd("ColorScheme", {
--   callback = function()
--     TmuxTheme.write_tmux_theme()
--   end,
-- })
