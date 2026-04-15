vim.keymap.set("n", "<localleader>ie", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")
vim.keymap.set("n", "<localleader>ia", 'oassert.NoError(err, "")<Esc>F";a')
vim.keymap.set("n", "<localleader>if", 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj')
vim.keymap.set("n", "<localleader>il", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i')
