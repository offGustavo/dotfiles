vim.schedule(function()
  vim.cmd.packadd("vim-fugitive")
	vim.keymap.set("n", "<M-S-g>", "<Cmd>Git<Cr>", { desc = "Git" })
end)
