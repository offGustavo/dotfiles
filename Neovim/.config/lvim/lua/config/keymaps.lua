vim.keymap.set('n', '<leader><Cr>', ':Ex<Cr>')

vim.keymap.set('v', '<S-k>', ":m '<-2<CR>gv=gv", { silent = true, desc = 'Move Line Up' })
vim.keymap.set('v', '<S-j>', ":m '>+1<CR>gv=gv", { silent = true, desc = 'Move Line Down' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { silent = true, desc = 'Go To Normal Mode in Terminal' })

vim.keymap.set('n', '<leader>qo', vim.cmd.copen, { desc = 'QuickFix Open', silent = true })
vim.keymap.set('n', '<leader>qc', vim.cmd.cclose, { desc = 'QuickFix Close', silent = true })

vim.keymap.set('n', '<leader>bb', ':b #<Cr>', { desc = 'Alternative Buffer', silent = true })
