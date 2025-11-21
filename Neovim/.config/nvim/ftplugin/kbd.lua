-- vim.g.lisp_rainbow = 1

vim.cmd([[
  " Ensure syntax highlighting is enabled
  syntax enable
  " Force load Lisp syntax rules
  runtime! syntax/lisp.vim

  " ============
  " Funções Kanata
  " ============

  " Desabilita sintaxe padrão que captura átomos após (
  syntax clear lispAtom

  " Captura qualquer função no formato (word
  " Usa lookbehind para capturar apenas o nome da função após o (
  syntax match kanataFunc /\v\(@<=[A-Za-z0-9_-]+/ containedin=lispExpr,lispList

  " Aplica highlight
  highlight def link kanataFunc LispFunc

  " ============
  " Aliases Kanata
  " ============

  " Captura aliases como @nav, @something, @nav; etc.
  " Exclui aliases que estão dentro de comentários usando containedin=ALLBUT
  syntax match kanataAlias /@[A-Za-z0-9_\-;.,/]\+/ containedin=ALLBUT,lispComment

  " Aplica highlight para aliases
  highlight def link kanataAlias Define

  " ===============
  " Kanata Comments
  " ===============
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
