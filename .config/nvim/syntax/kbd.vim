" Vim syntax file for Kanata configuration files
" Language: Kanata
" Maintainer: Luiz Melo
" Last Change: (custom)

if exists("b:current_syntax")
  finish
endif

" ============
" Comments
" ============
syntax match kanataComment ";;.*" contains=@Spell
highlight def link kanataComment Comment

" ============
" Aliases (e.g., @nav, @something)
" ============
syntax match kanataAlias /@[A-Za-z0-9_\-;.,/]\+/ containedin=ALLBUT,kanataComment
highlight def link kanataAlias Define
syntax match kanataVar /$[A-Za-z0-9_\-;.,/]\+/ containedin=ALLBUT,kanataComment
highlight def link kanataVar Constant

" ============
" Composite key sequences (e.g., S-RA-, etc.)
" ============
syntax match kanataComp /\v\C((S-|RA-|C-|A-|M-)+)([A-Za-z0-9_]+|.)/ containedin=ALLBUT,kanataComment
highlight def link kanataComp Conditional

" ============
" Parentheses (for visual delimiting)
" ============
syntax region kanataParens matchgroup=Delimiter start="(" end=")" transparent contains=ALL

" ============
" Keywords
" ============
syn iskeyword @,48-57,192-255,-,_ 
syntax keyword kanataKeyword defcfg defsrc deflayer deflayermap
syntax keyword kanataKeyword deflayer defcfg defsrc defchordsv2 defalias
syntax keyword kanataKeyword layer-toggle layer-switch deflocalkeys-win deflocalkeys-linux
syntax keyword kanataKeyword tap-hold tap-dance tap-hold-release tap-hold-press switch fork break
syntax keyword kanataKeyword mwheel-up    mwheel-down  mwheel-left  mwheel-right movemouse-up   
syntax keyword kanataKeyword movemouse-left movemouse-down movemouse-right movemouse-speed movemouse-speed movemouse-speed
highlight def link kanataKeyword Function

syn region	kanataString start=+"+ skip=+\\\\\|\\"+ end=+"+
hi def link kanataString String

syn cluster kanataCommentGroup	contains=Todo,@Spell
syn match   kanataComment		";;.*$"				contains=@lispCommentGroup
hi def link kanataComment Comment
