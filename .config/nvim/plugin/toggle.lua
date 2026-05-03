-- Toggle
vim.keymap.set("n", "<C-a>", function()
	require("forge.toggle").increase()
end)
vim.keymap.set("n", "<C-x>", function()
	require("forge.toggle").decrease()
end)

-- FIXME: fix toggle
vim.keymap.set("n", "<leader>tt", function()
	require("forge.toggle").toggle()
end, { desc = "Toggle Value" })
