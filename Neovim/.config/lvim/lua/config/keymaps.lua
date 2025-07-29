-- Emacs Crunch
vim.keymap.set({ 'i', 'c' }, '<C-p>', '<Up>', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<C-n>', '<Down>', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<C-a>', '<Home>', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<C-f>', '<Right>', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<C-b>', '<Left>', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<C-e>', '<End>', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<A-b>', '<C-Left>', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<A-f>', '<C-Right>', { silent = true })
vim.keymap.set('i', '<A-d>', '<C-o>dw', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<C-d>', '<Del>', { silent = true })
vim.keymap.set('i', '<C-k>', '<Esc>lDa', { silent = true })
vim.keymap.set('i', '<C-u>', '<Esc>d0xi', { silent = true })
vim.keymap.set('i', '<A-}>', '<C-o>}', { silent = true })
vim.keymap.set('i', '<A-{>', '<C-o>{', { silent = true })
vim.keymap.set('i', '<A-<>', '<C-o>gg', { silent = true })
vim.keymap.set('i', '<A->>', '<C-o>G', { silent = true })
vim.keymap.set('i', '<C-/>', '<C-o>u', { silent = true })
vim.keymap.set('i', '<C-x><C-s>', '<C-o>:w<CR>', { silent = true })
vim.keymap.set('i', '<C-x><C-c>', '<Esc>:wq<CR>', { silent = true })
vim.keymap.set('c', '<C-o>', '<C-f>', { silent = true })

vim.keymap.set('n', '<leader><Cr>', ':Ex<Cr>')

vim.keymap.set('v', '<S-k>', ":m '<-2<CR>gv=gv", { silent = true, desc = 'Move Line Up' })
vim.keymap.set('v', '<S-j>', ":m '>+1<CR>gv=gv", { silent = true, desc = 'Move Line Down' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { silent = true, desc = 'Go To Normal Mode in Terminal' })

vim.keymap.set('n', '<leader>qo', vim.cmd.copen, { desc = 'QuickFix Open', silent = true })
vim.keymap.set('n', '<leader>qc', vim.cmd.cclose, { desc = 'QuickFix Close', silent = true })

vim.keymap.set('n', '<leader>bb', ':b #<Cr>', { desc = 'Alternative Buffer', silent = true })
