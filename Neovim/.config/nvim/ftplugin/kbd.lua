vim.cmd([[
  " Ensure syntax highlighting is enabled
  syntax enable
  " Force load Lisp syntax rules
  runtime! syntax/lisp.vim
  " Remove the old comment rule
  syntax clear lispComment
  " Match only ;; comments
  syntax match lispComment ";;.*" contains=@Spell
  " Link to Comment highlight
  " Ensure lispComment is allowed inside all lisp regions
  highlight def link lispComment Comment
  " (including function bodies, lists, etc.)
  syntax cluster lispTop add=lispComment
  syntax cluster lispExpr add=lispComment
]])

-- Set Comments
vim.bo.commentstring = ";; %s"

vim.wo.foldmethod = "indent"
