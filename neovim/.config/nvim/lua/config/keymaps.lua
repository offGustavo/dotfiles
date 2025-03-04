-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "v" }, "n", "nzz", { silent = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "Nzz", { silent = true, desc = "Previous Search Result" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, desc = "Half Scroll Down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true, desc = "Half Scroll Up" })
vim.keymap.set("n", "<C-f>", "<C-f>zz", { silent = true, desc = "Scroll Down" })
vim.keymap.set("n", "<C-b>", "<C-b>zz", { silent = true, desc = "Scroll Up" })

-- Terminal
---- Normal Mode to Terminal
vim.keymap.set("n", "<leader>tt", "<Cmd>terminal<CR>", { silent = true, desc = "New Buffer Terminal" })
vim.keymap.set("n", "<leader>tj", function()
  Snacks.terminal()
end, { silent = true, desc = "Terminal" })

vim.keymap.set({ "n", "t" }, "<A-/>", function()
  Snacks.terminal()
end, { silent = true, desc = "New Small Terminal" })
vim.keymap.set("t", "<A-n>", "<Cmd>terminal<CR>", { silent = true, desc = "New Terminal in Terminal Mode" })
vim.keymap.set("n", "<leader>tv", "<Cmd>vertical terminal<CR>", { silent = true, desc = "Vertical Terminal" })
vim.keymap.set("n", "<leader>ts", "<Cmd>horizontal terminal<CR>", { silent = true, desc = "Horizontal Terminal" })

---- Terminal Mode to Normal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true, desc = "Go To Normal Mode in Terminal" })
vim.keymap.set("t", "<A-p>", "<C-\\><C-n>:", { desc = "Go To Command Mode in Terminal" })
vim.keymap.set("t", "<C-o>", "<C-\\><C-o>", { desc = "Go To Command Mode in Terminal" })

---- Move in windows on Terminal Mode
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l")

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
vim.keymap.set("n", "<leader>bp", vim.cmd.bp, { silent = false, desc = "Next Buffer" })
vim.keymap.set("n", "<C-w>n", vim.cmd.bn, { silent = false, desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>wn", vim.cmd.bn, { silent = false, desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>bn", vim.cmd.bn, { silent = false, desc = "Previous Buffer" })

vim.keymap.set("n", "<leader>;", ":<c-f>", { silent = true, desc = "Vi Command Mode" })

vim.keymap.set("n", "<S-Esc>", "<Cmd>Neotree close<Cr>", { silent = true, desc = "Close Neotree" })

-- Diagnostic keymaps (quickstart keymaps)
vim.keymap.set("n", "<leader>qf", vim.diagnostic.setloclist, { desc = "Open Diagnostic Quickfix List" })
vim.keymap.set("n", "<leader>qw", "<Cmd>wq!<Cr>", { desc = "Save and Quit" })
vim.keymap.set("n", "<leader>qn", "<Cmd>cnext<Cr>", { desc = "Open Next in Quickfix List" })
vim.keymap.set("n", "<leader>qp", "<Cmd>cprev<Cr>", { desc = "Open Previous in Quickfix List" })
vim.keymap.set("n", "<leader>qo", "<Cmd>copen<Cr>", { desc = "Open Quickfix List" })
vim.keymap.set("n", "<leader>qc", "<Cmd>cclose<Cr>", { desc = "Close Quickfix List" })

--- Primeagen
vim.keymap.set(
  "n",
  "<leader>s/",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Substitute Current Word" }
)

-- vim.keymap.set("n", "<leader>fa", "<Cmd> FzfLua builtin <Cr>", { desc = "Fzf All Pickers" })

vim.keymap.set("n", "<leader>pa", function()
  Snacks.picker()
end, { desc = "Snacks All Pickers" })

vim.keymap.set("n", "<leader>pz", function()
  Snacks.picker.zoxide()
end, { desc = "Snacks Picker Zoxide" })

vim.keymap.set("n", "<leader>pe", function()
  Snacks.picker.explorer()
end, { desc = "Snacks Picker Explorer" })

vim.keymap.set("n", "<leader>pf", function()
  Snacks.picker.files()
end, { desc = "Snacks Picker Files" })

vim.keymap.set("n", "<leader>pg", function()
  Snacks.picker.git_files()
end, { desc = "Snacks Picker Git Files" })

vim.keymap.set("n", "<leader>pi", function()
  Snacks.picker.icons()
end, { desc = "Snacks Picker Icons" })

vim.keymap.set("n", "<leader>pb", function()
  Snacks.picker.buffers()
end, { desc = "Snacks Picker Buffers" })

vim.keymap.set({ "n", "i" }, "<A-o>", "<Cmd>FzfLua files<Cr>", { silent = true, desc = "File File Picker" })
vim.keymap.set({ "n", "i" }, "<A-i>", "<Cmd>FzfLua live_grep<Cr>", { silent = true, desc = "Fzf Live Grep" })
vim.keymap.set({ "n", "i" }, "<A-u>", "<Cmd>FzfLua buffers<Cr>", { silent = true, desc = "Fzf Buffers" })

-- VS CODE CONFI
if vim.g.vscode then
  vim.keymap.set("n", "<leader>,", "<Cmd>call VSCodeNotify('workbench.action.showAllEditors')<CR>")
  vim.keymap.set("n", "<leader>e", "<Cmd>call VSCodeNotify('workbench.view.explorer')<CR>")
  vim.keymap.set("n", "<leader><Cr>", "<Cmd>call VSCodeNotify('workbench.view.explorer')<CR>")
  vim.keymap.set("n", "<leader>tt", "<Cmd>call VSCodeNotify('workbench.action.createTerminalEditor')<CR>")
  vim.keymap.set("n", "<leader>/", "<Cmd>call VSCodeNotify('workbench.action.quickTextSearch')<CR>")
else
  vim.keymap.set("n", "<leader><space>", function()
    Snacks.picker.files({
      hidden = true,
    })
  end, { desc = "Snacks Picker Files" })

  vim.keymap.set("n", "<leader>/", function()
    Snacks.picker.grep({
      hidden = true,
    })
  end, { desc = "Snacks Picker Grep" })
end

vim.keymap.set("x", "<leader><S-p>", '"_dP', { desc = "Past Without Copy" })

vim.keymap.set("n", "<leader>fx", ":!chmod +x %<Cr>", { desc = "Make File Executable" })

vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

vim.keymap.set("n", "<leader>un", function()
  if vim.o.signcolumn == "no" then
    vim.o.signcolumn = "yes"
    vim.opt.number = true
    vim.opt.relativenumber = true
  else
    vim.o.signcolumn = "no"
    vim.opt.number = false
    vim.opt.relativenumber = false
  end
end, { silent = true, desc = "Toggle Relative Line Number and Sign Column" })
