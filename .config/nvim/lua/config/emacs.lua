vim.cmd([[
  cmap <C-a> <home>
  cmap <C-e> <end>
  cmap <C-f> <right>
  cmap <C-b> <left>
  cmap <M-f> <C-right>
  cmap <M-b> <C-left>
  cmap <C-d> <del>
  cmap <C-o> <C-f>

  "" Emacs shit
  "nmap <M-x> :

  " imap <C-a> <home>
  " imap <C-e> <end>
  " imap <C-f> <right>
  " imap <C-b> <left>
  " imap <M-f> <C-right>
  " imap <M-b> <C-left>
  " imap <C-d> <del>
  " imap <M-d> <C-o>de
]])

-- Emacs Binds
vim.keymap.set("n", "<C-Down>", "}", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Up>", "{", { noremap = true, silent = true })
vim.keymap.set("i", "<M-S-.>", "<C-o>G", { noremap = true, silent = true })
vim.keymap.set("i", "<M-S-,>", "<C-o>gg", { noremap = true, silent = true })
vim.keymap.set({ "n", "x" }, "<M-S-.>", "G", { noremap = true, silent = true })
vim.keymap.set({ "n", "x" }, "<M-S-,>", "gg", { noremap = true, silent = true })
vim.keymap.set({ "n", "x" }, "<M-x>", ":")

