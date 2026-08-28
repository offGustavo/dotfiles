-- vim.cmd([[
-- let g:markdown_syntax_conceal = 0
-- let g:markdown_recommended_style = 0
-- let g:markdown_folding = 1
-- ]])

vim.lsp.enable("marksman")

map {
  { "<M-i><M-t>", "- [ ] ", mode = "i", buf = 0 }
}
