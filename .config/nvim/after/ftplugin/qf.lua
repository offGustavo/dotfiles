-- Some settings.
vim.wo.nu = true
vim.wo.rnu = true

-- vim.cmd([[set statusline=%t%{exists('w:quickfix_title')? ' '.w:quickfix_title : ''} %=%-15(%l,%c%V%) %P]])

-- -- TODO: add a build_quickfix_statusline
-- vim.wo.statusline = '%{%(nvim_get_current_win()==#g:actual_curwin || &laststatus==3) ? v:lua.fish.build_statusline() : v:lua.Fish.build_statusline_inactive()%}'

-- Add the cfilter plugin.
vim.cmd.packadd 'cfilter'

vim.keymap.set("n", "<C-j>", "<Cmd>cnext<Cr><Cmd>cope<Cr>", { buffer = true })
vim.keymap.set("n", "<C-k>", "<Cmd>cprev<Cr><Cmd>cope<Cr>", { buffer = true })
-- vim.keymap.set("n", "<C-K>", "<Cmd>cprev<Cr><Cmd>cope<Cr>")
-- vim.keymap.set("n", "<C-J>", "<Cmd>cnext<Cr><Cmd>cope<Cr>")
