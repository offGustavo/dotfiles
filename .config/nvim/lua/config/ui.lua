-- vim: foldmethod=marker

-- {{{ foldtext
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99

-- vim.o.foldtext = ""
vim.o.foldtext = "v:lua.require('fish.foldtext').build_fold_text()"

function fish.clean_folded_hi()
  vim.api.nvim_set_hl(0, "Folded", { link = "Comment" })
end

vim.api.nvim_create_autocmd({ "UiEnter", "ColorScheme" }, {
  callback = function()
    fish.clean_folded_hi()
  end
})
--- }}}

--- {{{ statuscolumn
vim.o.foldcolumn = "1"
vim.o.signcolumn = "yes:1"

-- Status column settings
vim.opt.fillchars:append({
	fold = " ",
	foldopen = "",
	foldclose = "",
	foldsep = " ",
	foldinner = " ",
})

-- vim.o.statuscolumn = "%s%l %C "
vim.o.statuscolumn = "%!v:lua.require('fish.statuscolumn').build()"

-- }}}

-- {{{ statusline
-- FIXME: Quero usar o laststatus = 0, mas o nome do arquivo não fica salvo per janela
vim.o.laststatus = 3
vim.o.showmode = false

-- vim.opt.fillchars:append({
--   stl = "-",
--   stlnc = "-"
-- })

-- set statusline=%<%f\ %h%w%m%r\ %{%\ v:lua.require('vim._core.util').term_exitcode()\ %}%=%{%\ luaeval('(package.loaded[''vim.ui'']\ and\ vim.api.nvim_get_current_win()\ ==\ tonumber(vim.g.actual_curwin\ or\ -1)\ and\ vim.ui.progress_status())\ or\ ''''\ ')%}%{%\ &showcmdloc\ ==\ 'statusline'\ ?\ '%-10.S\ '\ :\ ''\ %}%{%\ exists('b:keymap_name')\ ?\ '<'..b:keymap_name..'>\ '\ :\ ''\ %}%{%\ &busy\ >\ 0\ ?\ '◐\ '\ :\ ''\ %}%{%\ luaeval('(package.loaded[''vim.diagnostic'']\ and\ next(vim.diagnostic.count())\ and\ vim.diagnostic.status()\ ..\ ''\ '')\ or\ ''''\ ')\ %}%{%\ &ruler\ ?\ (\ &rulerformat\ ==\ ''\ ?\ '%-14.(%l,%c%V%)\ %P'\ :\ &rulerformat\ )\ :\ ''\ %}

--- vim.o.statusline = "%!v:lua.require('fish.statusline').build_statusline()"

-- From mini.statusline
-- -- Set statusline globally and dynamically decide which content to use
vim.go.statusline =
	[[ %{%(nvim_get_current_win()==#g:actual_curwin || &laststatus==3) ? v:lua.require('fish.statusline').build_statusline() : v:lua.require('fish.statusline').build_statusline_inactive()%} ]]

-- }}}

-- {{{ tabline
vim.o.tabline = "%!v:lua.require('fish.tabline').build_tabline()"
-- }}}

-- {{{ quickfix
-- TODO: add custom quickfix list
-- vim.o.quickfixtextfunc = "v:lua.require('fish.quickfix').format()"
--- }}}

-- {{{ ui2
if vim.fn.has('nvim-0.12') ~= 1 then
  vim.notify("Use 0.12 to enable ui2", vim.log.levels.WARN)
  return
end

-- vim.schedule(function()
-- 	vim.o.cmdheight = 1
-- 	require("vim._core.ui2").enable({
-- 		enable = true, -- Whether to enable or disable the UI.
-- 		msg = { -- Options related to the message module.
-- 			---@type 'cmd'|'msg' Default message target, either in the
-- 			---cmdline or in a separate ephemeral message window.
-- 			---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
-- 			---or table mapping |ui-messages| kinds and triggers to a target.
-- 			targets = "msg",
-- 		},
-- 	})
-- end)

-- }}}

-- {{{ -- Experimental UI2: floating cmdline and messages
-- require('vim._core.ui2').enable({
--   enable = true,
--   msg = {
--     targets = {
--       [''] = 'msg',
--       empty = 'cmd',
--       bufwrite = 'msg',
--       confirm = 'cmd',
--       emsg = 'pager',
--       echo = 'msg',
--       echomsg = 'msg',
--       echoerr = 'pager',
--       completion = 'cmd',
--       list_cmd = 'pager',
--       lua_error = 'pager',
--       lua_print = 'msg',
--       progress = 'pager',
--       rpc_error = 'pager',
--       quickfix = 'msg',
--       search_cmd = 'cmd',
--       search_count = 'cmd',
--       shell_cmd = 'pager',
--       shell_err = 'pager',
--       shell_out = 'pager',
--       shell_ret = 'msg',
--       undo = 'msg',
--       verbose = 'pager',
--       wildlist = 'cmd',
--       wmsg = 'msg',
--       typed_cmd = 'cmd',
--     },
--     cmd = {
--       height = 0.5,
--     },
--     dialog = {
--       height = 0.5,
--     },
--     msg = {
--       height = 0.3,
--       timeout = 5000,
--     },
--     pager = {
--       height = 0.5,
--     },
--   },
-- })
-- }}}
