-- vim.api.nvim_create_autocmd("TextYankPost", {
-- 	desc = "Highlight when yanking (copying) text",
-- 	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
-- 	callback = function()
-- 		vim.hl.on_yank()
-- 	end,
-- })

-- Define custom highlight groups (choose your own colors)
-- Example: Cyan for normal yanks, Orange for clipboard (+ register) yanks
vim.api.nvim_set_hl(0, "YankHlDefault", { fg = "cyan", bg = "" })
vim.api.nvim_set_hl(0, "YankHlSystem", { fg = "orange", bg = "" })
vim.api.nvim_set_hl(0, "YankHlBlackHole", { fg = "orange", bg = "" })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text with different colors based on register",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    local reg = vim.v.event.regname
    if reg == "+" then
      -- Yank to system clipboard → orange highlight
      -- vim.highlight.on_yank({ higroup = "YankHighlightClipboard", timeout = 150 })
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    -- elseif reg == "_" then
    -- 	-- Yank to system clipboard → orange highlight
    -- 	-- vim.highlight.on_yank({ higroup = "YankHighlightClipboard", timeout = 150 })
    -- 	vim.highlight.on_yank({ higroup = "ErrorMsg", timeout = 150 })
    else
      -- Any other yank (default register, "*", named registers, etc.) → cyan highlight
      -- vim.highlight.on_yank({ higroup = "YankHighlightNormal", timeout = 150 })
      vim.highlight.on_yank({ higroup = "Search", timeout = 150 })
    end
  end,
})

-- Set EDITOR for terminal buffers
-- vim.api.nvim_create_autocmd("TermOpen", {
--   callback = function()
--     if vim.fn.exists("$NVIM") > 0 then
--       vim.env.EDITOR = "nvim --server $NVIM --remote"
--       vim.env.VISUAL = "nvim --server $NVIM --remote"
--     end
--   end,
-- })

-- REF: https://github.com/neovim/neovim/discussions/39260
local mark_names = vim.split("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", "") -- .><^

local au = vim.api.nvim_create_augroup("mark_signs", { clear = true })
local ns = vim.api.nvim_create_namespace("mark_signs")

local iter_marks = function(buf, cb)
	local line_count = vim.api.nvim_buf_line_count(buf)
	for _, name in ipairs(mark_names) do
		local lnum = vim.api.nvim_buf_get_mark(buf, name)[1]
		if lnum > 0 and lnum <= line_count then
			cb(lnum, name)
		end
	end
end

vim.api.nvim_create_autocmd("MarkSet", {
	pattern = "[[:alpha:]]",
	group = au,
	desc = "Remove overlapping marks on the same line",
	callback = function(e)
		iter_marks(e.buf, function(lnum, name)
			if e.data.line == lnum and e.data.name ~= name then
				vim.cmd.delmark(name)
			end
		end)
	end,
})

-- NOTE: After neovim#39218 (NVIM 0.12.2+), `MarkSet` also fires on deletion,
-- so the `event` can be changed to `{ "BufRead", "MarkSet" }`.
-- vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
vim.api.nvim_create_autocmd({ "BufRead", "MarkSet" }, {
	group = au,
	desc = "Frequently update mark signs",
	callback = function(e)
		vim.api.nvim_buf_clear_namespace(e.buf, ns, 0, -1)
		iter_marks(e.buf, function(lnum, name)
			-- if name:match("%p") and vim.bo[e.buf].buftype ~= "" then
			--   return
			-- end
			vim.api.nvim_buf_set_extmark(e.buf, ns, lnum - 1, 0, {
				sign_text = name,
				sign_hl_group = "DiagnosticHint",
			})
		end)
	end,
})


-- Kitty
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume", "UIEnter" }, {
  group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
  callback = function()
    if vim.api.nvim_ui_send then
      vim.api.nvim_ui_send("\x1b]1337;SetUserVar=in_editor=MQo\007")
    else
      io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\007")
    end
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
  callback = function()
    if vim.api.nvim_ui_send then
      vim.api.nvim_ui_send("\x1b]1337;SetUserVar=in_editor=MQo\007")
    else
      io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
    end
  end,
})

-- -- [Native Fuzzy Finder in Neovim With Lua and Cool Bindings :: Cherry's Blog](https://cherryramatis.xyz/posts/native-fuzzy-finder-in-neovim-with-lua-and-cool-bindings/)
-- vim.api.nvim_create_autocmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
--   pattern = { '*' },
--   group = vim.api.nvim_create_augroup('CmdlineAutocompletion', { clear = true }),
--   callback = function(ev)
--     vim.opt.wildmenu = true
--     vim.opt.wildmode = 'noselect:lastused,full'
--     if ev.event == 'CmdlineChanged' then
--       vim.opt.wildmode = 'noselect:lastused,full'
--       vim.schedule(function()
--         vim.fn.wildtrigger()
--       end)
--     end
--     if ev.event == 'CmdlineLeave' then
--       vim.opt.wildmode = 'full'
--     end
--   end,
-- })
--
-- -- [:grep with live updating quickfix list : r/neovim](https://www.reddit.com/r/neovim/comments/1n2ln9w/grep_with_live_updating_quickfix_list/)
-- vim.api.nvim_create_autocmd('CmdlineChanged', {
--   callback = function()
--     local cmdline = vim.fn.getcmdline()
--     local words = vim.split(cmdline, ' ', { trimempty = true })
--
--     if words[1] == 'LiveGrep' or words[1] == 'live' and #words > 1 then
--       vim.cmd('silent grep! ' .. vim.fn.escape(words[2], ' '))
--       vim.cmd 'cwindow'
--       vim.cmd.redraw()
--     end
--   end,
--   pattern = ':',
-- })
--
-- -- https://stackoverflow.com/questions/42905008/quickfix-list-how-to-add-and-remove-entries
-- vim.cmd [[
-- " When using `dd` in the quickfix list, remove the item from the quickfix list.
-- function! RemoveQFItem()
-- let curqfidx = line('.') - 1
-- let qfall = getqflist()
-- call remove(qfall, curqfidx)
-- call setqflist(qfall, 'r')
-- execute curqfidx + 1 . "cfirst"
-- :copen
-- endfunction
-- :command! RemoveQFItem :call RemoveQFItem()
-- " Use map <buffer> to only map dd in the quickfix window. Requires +localmap
-- autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>
-- ]]
--
-- -- Função para remover item atual da Location List
-- local function remove_loc_item()
--   local curidx = vim.fn.line(".") - 1
--   local winid = vim.fn.win_getid()
--
--   -- Pega a lista local da janela
--   local loclist = vim.fn.getloclist(winid)
--
--   if #loclist == 0 then
--     vim.notify("Location List vazia", vim.log.levels.WARN)
--     return
--   end
--
--   -- Remove o item atual
--   table.remove(loclist, curidx + 1)
--
--   -- Atualiza a loclist com a nova lista
--   vim.fn.setloclist(winid, loclist, "r")
--
--   -- Reabre para atualizar a janela
--   vim.cmd.lwindow()
-- end
--
-- -- Cria comando para remover
-- vim.api.nvim_create_user_command("RemoveLocItem", remove_loc_item, {})
--
-- -- Autocmd: quando abrir uma janela de loclist, mapear `dd`
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "qf",
--   callback = function(args)
--     local wininfo = vim.fn.getwininfo(vim.fn.win_getid())[1]
--     if wininfo and wininfo.loclist == 1 then
--       vim.api.nvim_buf_set_keymap(
--         args.buf,
--         "n",
--         "dd",
--         ":RemoveLocItem<CR>",
--         { noremap = true, silent = true }
--       )
--     end
--   end,
-- })
--
-- vim.api.nvim_create_autocmd({ 'BufEnter', "TermOpen" }, {
--   pattern = '*',
--   callback = function(args)
--     local buf = args.buf
--     local buf_options = vim.api.nvim_buf_get_option
--     -- Check if this is a terminal buffer
--     if buf_options(buf, 'buftype') == 'terminal' then
--       -- Check if buffer name contains --vimgrep
--       local buf_name = vim.api.nvim_buf_get_name(buf)
--       if buf_name:find('--vimgrep') then
--         -- Set the mapping again (in case it was lost)
--         vim.keymap.set('n', '<Cr>', 'gF', {
--           buffer = buf,
--           noremap = true,
--           silent = true,
--           desc = 'Jump to file:line from grep results'
--         })
--       end
--     end
--   end
-- })
