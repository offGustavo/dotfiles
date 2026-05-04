-- Set tabline
vim.o.tabline = "%!v:lua.require('forge.tabline').build_tabline()"

-- :tcd shortcut
vim.keymap.set("n", "<leader><Tab>z", ":tcd ", { desc = "Tab Cd" })

vim.keymap.set("n", "<leader><Tab><Tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })

vim.keymap.set("n", "<leader><Tab>c", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><Tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })

vim.keymap.set("n", "]<S-Tab>", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "[<S-Tab>", "<cmd>tabfirst<cr>", { desc = "First Tab" })

vim.keymap.set("n", "]<Tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "[<Tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

vim.keymap.set("n", "<C-S-PageUp>", "<cmd>tabmove -1<cr>")
vim.keymap.set("n", "<C-S-PageDown>", "<cmd>tabmove +1<cr>")
