vim.bo.commentstring = ";;%s"
vim.wo.foldmethod = "indent"
-- Ensure syntax highlighting is enabled
vim.cmd("syntax enable")

-- Force load Lisp syntax rules
vim.cmd("runtime! syntax/lisp.vim")
