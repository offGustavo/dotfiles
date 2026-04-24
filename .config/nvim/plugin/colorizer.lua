vim.schedule(function ()
  vim.o.termguicolors = true
  vim.cmd.packadd("nvim-colorizer.lua")

  vim.keymap.set("n", "<leader>utc", ":ColorizerToggle<CR>")
end)
