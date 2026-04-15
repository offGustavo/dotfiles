" Name:        tokyonight_minimal.vim
" Description: A minimal TokyoNight variant with dark blue background,
"              green strings, orange numbers, and purple keywords
" Maintainer:  Your Name
" Last Change: 2026-04-10

set background=dark
hi clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "tokyonight_minimal"

" Core palette from TokyoNight (Night variant for darkest blue)
" Background: #1a1b26 (TokyoNight Night) [citation:1]
" Strings:    #9ece6a (TokyoNight Green) [citation:1]
" Numbers:    #ff9e64 (TokyoNight Orange) [citation:1]
" Keywords:   #9d7cd8 (TokyoNight Purple) [citation:1]
" Foreground: #c0caf5 (TokyoNight foreground) [citation:1]

" ========================
" Base Editor Settings
" ========================
hi Normal        guifg=#c0caf5 guibg=#1a1b26
hi NonText       guifg=#565f89 guibg=#1a1b26
hi Cursor        guifg=#1a1b26 guibg=#c0caf5
hi CursorLine    guibg=#1f2335
hi CursorLineNr  guifg=#9ece6a gui=bold
hi LineNr        guifg=#565f89 guibg=#1a1b26
hi CursorColumn  guibg=#1f2335
hi ColorColumn   guibg=#1f2335
hi SignColumn    guibg=#1a1b26 guifg=#c0caf5
hi StatusLine    guifg=#c0caf5 guibg=#1f2335 gui=bold
hi StatusLineNC  guifg=#565f89 guibg=#1f2335
hi VertSplit     guifg=#1f2335 guibg=#1a1b26
hi TabLine       guifg=#565f89 guibg=#1a1b26
hi TabLineSel    guifg=#9ece6a guibg=#1a1b26 gui=bold
hi TabLineFill   guibg=#1a1b26
hi Visual        guibg=#2d3f6e
hi VisualNOS     guibg=#2d3f6e
hi MatchParen    guifg=#1a1b26 guibg=#7dcfff gui=bold
hi Folded        guifg=#565f89 guibg=#1a1b26
hi FoldColumn    guifg=#565f89 guibg=#1a1b26
hi Pmenu         guifg=#c0caf5 guibg=#1f2335
hi PmenuSel      guifg=#1a1b26 guibg=#7aa2f7
hi PmenuSbar     guibg=#1f2335
hi PmenuThumb    guibg=#565f89
hi Search        guifg=#1a1b26 guibg=#e0af68
hi IncSearch     guifg=#1a1b26 guibg=#ff9e64
hi WildMenu      guifg=#1a1b26 guibg=#7aa2f7

" ========================
" Syntax Highlighting
" ========================
hi Comment       guifg=#565f89 gui=italic
hi Constant      guifg=#9ece6a
hi String        guifg=#9ece6a
hi Character     guifg=#9ece6a
hi Number        guifg=#ff9e64
hi Boolean       guifg=#ff9e64
hi Float         guifg=#ff9e64

hi Identifier    guifg=#c0caf5
hi Function      guifg=#7aa2f7

hi Statement     guifg=#9d7cd8
hi Conditional   guifg=#9d7cd8
hi Repeat        guifg=#9d7cd8
hi Label         guifg=#9d7cd8
hi Operator      guifg=#89b4fa
hi Keyword       guifg=#9d7cd8
hi Exception     guifg=#9d7cd8

hi PreProc       guifg=#7dcfff
hi Include       guifg=#7dcfff
hi Define        guifg=#7dcfff
hi Macro         guifg=#7dcfff
hi PreCondit     guifg=#7dcfff

hi Type          guifg=#73daca
hi StorageClass  guifg=#9d7cd8
hi Structure     guifg=#73daca
hi Typedef       guifg=#73daca

hi Special       guifg=#bb9af7
hi SpecialChar   guifg=#bb9af7
hi Tag           guifg=#bb9af7
hi Delimiter     guifg=#89b4fa
hi SpecialComment guifg=#565f89
hi Debug         guifg=#f7768e

hi Underlined    guifg=#7aa2f7 gui=underline
hi Ignore        guifg=#1a1b26
hi Error         guifg=#f7768e guibg=#1a1b26
hi Todo          guifg=#e0af68 guibg=#1a1b26 gui=bold

" ========================
" Diff Colors
" ========================
hi DiffAdd       guifg=#9ece6a guibg=#2b485a
hi DiffChange    guifg=#c0caf5 guibg=#272d43
hi DiffDelete    guifg=#f7768e guibg=#52313f
hi DiffText      guifg=#7aa2f7 guibg=#2b485a gui=bold

