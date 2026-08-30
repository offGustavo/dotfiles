-- vim.cmd([[
-- let g:markdown_syntax_conceal = 0
-- let g:markdown_recommended_style = 0
-- let g:markdown_folding = 1
-- ]])

vim.lsp.enable("marksman")

map { 
  -- TODO: Modificar esse atalho e adicionar uma função para fazer o "toggle" do TODO
  {  "i", "<M-i><M-l>", "- [ ] ", buf = 0 },
  {  "i", "<M-i><M-1>", "# TODO: ", buf = 0 },
  {  "i", "<M-i><M-2>", "## TODO: ", buf = 0 },
  {  "i", "<M-i><M-3>", "### TODO: ", buf = 0 },
  {  "i", "<M-i><M-4>", "#### TODO: ", buf = 0 },
  {  "i", "<M-i><M-5>", "##### TODO: ", buf = 0 }
}
