-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- TODO: Remove when lazyvim make a buitin alternative
-- Clear search, multicursors and stop snippet on escape
vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")

  if vim.fn.mode() == "n" then
    local mc_ns = vim.api.nvim_create_namespace("nvim.multicursor")
    vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
  end

  LazyVim.cmp.actions.snippet_stop()
  return "<esc>"
end, { expr = true, desc = "Escape, Reset Multicursors and Clear hlsearch" })

-- Remove Lazy Default's
vim.keymap.del("n", "H")
vim.keymap.del("n", "L")
