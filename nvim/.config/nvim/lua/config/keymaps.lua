-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

        -- stylua: ignore
        ---@type vim.
vim.keymap.set({ "n", "v" }, "n", "nzz", { silent = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "Nzz", { silent = true, desc = "Previous Search Result" })
vim.keymap.set("n", "<c-d>", "<c-d>zz", { silent = true, desc = "Half Scroll Down" })
vim.keymap.set("n", "<c-u>", "<c-u>zz", { silent = true, desc = "Half Scroll Up" })
vim.keymap.set("n", "<c-f>", "<c-f>zz", { silent = true, desc = "Scroll Down" })
vim.keymap.set("n", "<c-b>", "<c-b>zz", { silent = true, desc = "Scroll Up" })

-- Terminal
---- Normal Mode to Terminal
vim.keymap.set("n", "<leader>tt", "<cmd>terminal<CR>", { silent = true, desc = "New Buffer Terminal" })
vim.keymap.set("n", "<leader>tj", function()
  Snacks.terminal()
end, { silent = true, desc = "New Small Terminal" })
vim.keymap.set("t", "<A-n>", "<cmd>terminal<CR>", { silent = true, desc = "New Terminal in Terminal Mode" })
vim.keymap.set("n", "<leader>tv", "<cmd>vertical terminal<CR>", { silent = true, desc = "Vertical Terminal" })
vim.keymap.set("t", "<A-p> c", "<cmd>horizontal terminal<CR>", { silent = true, desc = "Normal Mode in Terminal" })
vim.keymap.set("n", "<leader>ts", "<cmd>horizontal terminal<CR>", { silent = true, desc = "Horizontal Terminal" })

---- Terminal Mode to Normal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true, desc = "Go To Normal Mode in Terminal" })
-- vim.keymap.set("t", "<A-p>", "<C-\\><C-n>: ", { silent = true, desc = "Go To Command Mode in Terminal" })
-- vim.keymap.set("t", "<C-o>", "<C-\\><C-o>", { silent = true, desc = "Go To Command Mode in Terminal" })

---- Move in windows on Terminal Mode
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><cmd>TmuxNavigateLeft<cr>")
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><cmd>TmuxNavigateDown<cr>")
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><cmd>TmuxNavigateUp<cr>")
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><cmd>TmuxNavigateRight<cr>")

-- Close Window
vim.keymap.set("n", "<leader>wc", "<Cmd>close<Cr>")
-- Move Lines Up/Down
--
vim.keymap.set("v", "<S-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move Line Up" })
vim.keymap.set("v", "<S-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move Line Down" })

-- Emacs Keybinds in Insert Mode
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>")
vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>")
vim.keymap.set({ "i", "c" }, "<C-p>", "<Up>")
vim.keymap.set({ "i", "c" }, "<C-n>", "<Down>")
vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>")
vim.keymap.set({ "i", "c" }, "<C-e>", "<End>")
vim.keymap.set({ "i", "c" }, "<A-b>", "<C-Left>")
vim.keymap.set({ "i", "c" }, "<A-f>", "<C-Right>")
vim.keymap.set({ "i", "c" }, "<A-d>", "<C-o>dw")
vim.keymap.set({ "i", "c" }, "<C-k>", "<Esc>lDa")
vim.keymap.set({ "i", "c" }, "<C-u>", "<Esc>d0xi")
vim.keymap.set({ "i", "c" }, "<C-x><C-s>", "<Esc>:w<CR>a")

-- Buffer Movement
vim.keymap.set("n", "<C-w>p", vim.cmd.bp, { silent = false, desc = "Next Buffer" })
vim.keymap.set("n", "<leader>wp", vim.cmd.bp, { silent = false, desc = "Next Buffer" })
vim.keymap.set("n", "<C-w>n", vim.cmd.bn, { silent = false, desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>wn", vim.cmd.bn, { silent = false, desc = "Previous Buffer" })

--
vim.keymap.set("n", "<leader>;", ":<c-f>", { silent = true, desc = "Vi Command Mode" })

vim.keymap.set("n", "<S-Esc>", "<Cmd>Neotree close", { silent = true, desc = "Close Neotree" })

if vim.g.vscode then
  -- VS CODE CONFI
  vim.keymap.set("n", "<leader>,", "<Cmd>call VSCodeNotify('workbench.action.showAllEditors')<CR>")
  vim.keymap.set("n", "<leader>e", "<Cmd>call VSCodeNotify('workbench.view.explorer')<CR>")
  vim.keymap.set("n", "<leader>tt", "<Cmd>call VSCodeNotify('workbench.action.createTerminalEditor')<CR>")
end
