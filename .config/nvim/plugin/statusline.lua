-- FIXME: Quero usar o laststatus = 0, mas o nome do arquivo não fica salvo per janela
vim.o.laststatus = 3
vim.o.showmode = false

-- vim.opt.fillchars:append({
--   stl = "-",
--   stlnc = "-"
-- })

-- set statusline=%<%f\ %h%w%m%r\ %{%\ v:lua.require('vim._core.util').term_exitcode()\ %}%=%{%\ luaeval('(package.loaded[''vim.ui'']\ and\ vim.api.nvim_get_current_win()\ ==\ tonumber(vim.g.actual_curwin\ or\ -1)\ and\ vim.ui.progress_status())\ or\ ''''\ ')%}%{%\ &showcmdloc\ ==\ 'statusline'\ ?\ '%-10.S\ '\ :\ ''\ %}%{%\ exists('b:keymap_name')\ ?\ '<'..b:keymap_name..'>\ '\ :\ ''\ %}%{%\ &busy\ >\ 0\ ?\ '◐\ '\ :\ ''\ %}%{%\ luaeval('(package.loaded[''vim.diagnostic'']\ and\ next(vim.diagnostic.count())\ and\ vim.diagnostic.status()\ ..\ ''\ '')\ or\ ''''\ ')\ %}%{%\ &ruler\ ?\ (\ &rulerformat\ ==\ ''\ ?\ '%-14.(%l,%c%V%)\ %P'\ :\ &rulerformat\ )\ :\ ''\ %}
vim.o.statusline = "%!v:lua.require('fish.statusline').build_statusline()"

-- From mini.statusline
-- -- Set statusline globally and dynamically decide which content to use
-- vim.go.statusline =
-- 	[[ %{%(nvim_get_current_win()==#g:actual_curwin || &laststatus==3) ? v:lua.require('fish.statusline').build_statusline() : v:lua.require('fish.statusline').build_statusline_inactive()%} ]]
