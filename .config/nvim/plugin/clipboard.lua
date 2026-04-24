vim.api.nvim_create_autocmd({ "VimEnter", "VimResume", "UIEnter" }, {
	group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
	callback = function()
		if vim.api.nvim_ui_send then
			vim.api.nvim_ui_send("\x1b]1337;SetUserVar=in_editor=MQo\007")
		else
			io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\007")
		end
	end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
	group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
	callback = function()
		if vim.api.nvim_ui_send then
			vim.api.nvim_ui_send("\x1b]1337;SetUserVar=in_editor=MQo\007")
		else
			io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
		end
	end,
})

-- TODO: Define what keybind i will use for this
vim.keymap.set("n", "<M-w>", '"+')
vim.keymap.set({ "n", "x" }, "<leader>+", '"+')
vim.keymap.set({ "n", "x" }, "<leader>_", '"_')

vim.keymap.set({ "n" }, "<leader>p", '"+p', { desc = "Paste from System" })
vim.keymap.set("x", "<leader>p", '"_dP') -- Paste without overwriting the default register

vim.keymap.set({ "n", "x" }, "<C-s-v>", '"+p', { desc = "Paste from System" })
vim.keymap.set("i", "<C-s-v>", '<C-r>+', { desc = "Paste from System" })

vim.keymap.set({ "n", "x" }, "<C-S-c>", '"+y', { desc = "Yank to System" })
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to System" })
vim.keymap.set({ "n", "x" }, "<D-c>", '"+y', { desc = "Yank to System" })
vim.keymap.set({ "n", "x" }, "<D-c>", '"+y', { desc = "Yank to System" })
vim.keymap.set({ "n" }, "<C-S-c><C-S-c>", '"+yy', { desc = "Yank to System" })

-- vim.schedule(function()
-- 	vim.o.clipboard = "unnamed,unnamedplus"
-- end)
