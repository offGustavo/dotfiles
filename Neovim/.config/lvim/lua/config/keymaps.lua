vim.keymap.set({'n', "v", "i" }, '<C-s>', vim.cmd.write)

vim.keymap.set("n", "<leader>w", "<C-w>")

vim.keymap.set('v', '<S-k>', ":m '<-2<CR>gv=gv", { silent = true, desc = 'Move Line Up' })
vim.keymap.set('v', '<S-j>', ":m '>+1<CR>gv=gv", { silent = true, desc = 'Move Line Down' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { silent = true, desc = 'Go To Normal Mode in Terminal' })

vim.keymap.set('n', '<leader>qo', vim.cmd.copen, { desc = 'QuickFix Open', silent = true })
vim.keymap.set('n', '<leader>qc', vim.cmd.cclose, { desc = 'QuickFix Close', silent = true })

vim.keymap.set('n', '<leader>qq', vim.cmd.quit, { desc = 'Quit', silent = true })
vim.keymap.set('n', '<leader>qQ', ":qa!<Cr>", { desc = 'Force Quit All', silent = true })
vim.keymap.set('n', '<leader>qr', vim.cmd.restart, { desc = 'Restart', silent = true })

vim.keymap.set("n", "<leader>fc", ":cd ~/.config/lvim<Cr>:find ")

vim.keymap.set('n', '<leader>bb', ':b #<Cr>', { desc = 'Alternative Buffer', silent = true })
vim.keymap.set("n", "<leader>bd", ":bd!<Cr>")
vim.keymap.set('n', '<leader>,', ':ls<Cr>:b! ')
vim.keymap.set('n', '<leader>z', ':cd ')

vim.keymap.set('n', '<leader><Cr>', ':Ex<Cr>')
vim.keymap.set('n', '<leader><space>', ':find ')


vim.keymap.set("n", "<leader>he", ":marks<Cr>")
vim.keymap.set("n", "<leader>h1", "m1")
vim.keymap.set("n", "<leader>h2", "m2")
vim.keymap.set("n", "<leader>h3", "m3")
vim.keymap.set("n", "<leader>h4", "m4")
vim.keymap.set("n", "<leader>h5", "m5")
vim.keymap.set("n", "<leader>h6", "m6")
vim.keymap.set("n", "<leader>h7", "m7")
vim.keymap.set("n", "<leader>h8", "m8")
vim.keymap.set("n", "<leader>h9", "m9")
vim.keymap.set("n", "<leader>h0", "m0")

vim.keymap.set("n", "<leader>1", " `1")
vim.keymap.set("n", "<leader>2", " `2")
vim.keymap.set("n", "<leader>3", " `3")
vim.keymap.set("n", "<leader>4", " `4")
vim.keymap.set("n", "<leader>5", " `5")
vim.keymap.set("n", "<leader>6", " `6")
vim.keymap.set("n", "<leader>7", " `7")
vim.keymap.set("n", "<leader>8", " `8")
vim.keymap.set("n", "<leader>9", " `9")
vim.keymap.set("n", "<leader>0", " `0")
