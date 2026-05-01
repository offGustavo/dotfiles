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

-- FIXME: remove some keybinds
-- free <leader>p
vim.keymap.set("n", "<M-w>", '"', { desc = 'Alias to "' })
vim.keymap.set("i", "<M-w>", '<C-r>', { desc = 'Alias to "' })

vim.keymap.set({ "n", "x" }, "<leader>+", '"+', { desc = "System Register" })
vim.keymap.set({ "n", "x" }, "<leader>_", '"_', { desc = "Black Hole Register" })

vim.keymap.set({ "n" }, "<leader>p", '"+p', { desc = "Paste from system register" })
vim.keymap.set("x", "<leader>p", '"_dP') -- Paste without overwriting the default register

vim.keymap.set({ "n", "x" }, "<C-s-v>", '"+p', { desc = "Paste from system register" })
vim.keymap.set("i", "<C-s-v>", '<C-r>+', { desc = "Paste from system register" })

vim.keymap.set({ "n", "x" }, "<C-S-c>", '"+y', { desc = "Yank to system register" })
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to system register" })
vim.keymap.set({ "n", "x" }, "<D-c>", '"+y', { desc = "Yank to system register" })
vim.keymap.set({ "n", "x" }, "<D-c>", '"+y', { desc = "Yank to system register" })
vim.keymap.set({ "n" }, "<C-S-c><C-S-c>", '"+yy', { desc = "Yank to system register" })

vim.keymap.set({ "n", "x" }, "<leader>x", '"+d', { desc = "Cut to system register" })

-- Copy Entire Buffer
vim.keymap.set("n", "gA", "<Cmd>%y +<Cr>", { silent = true, desc = "Yank entire file to System" })
vim.keymap.set("n", "g<M-a>", "<Cmd>%y<Cr>", { silent = true, desc = "Yank entire file" })

-- vim.schedule(function()
-- 	vim.o.clipboard = "unnamed,unnamedplus"
-- end)
