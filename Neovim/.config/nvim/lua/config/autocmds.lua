-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

--------------------------------------------
-- AUTOCOMDS                              --
--------------------------------------------

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    -- vim.opt_local.spell = false
    -- vim.opt_local.conceallevel = 3
    vim.opt_local.wrap = false
  end,
})

-- vim.api.nvim_create_autocmd("ColorScheme", {
--   callback = function()
--     TmuxTheme.write_tmux_theme()
--   end,
-- })

-- -- [Native Fuzzy Finder in Neovim With Lua and Cool Bindings :: Cherry's Blog](https://cherryramatis.xyz/posts/native-fuzzy-finder-in-neovim-with-lua-and-cool-bindings/)
-- local function is_cmdline_type_find()
--     local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]
--
--     return cmdline_cmd == 'find' or cmdline_cmd == 'fin'
-- end
--
-- vim.api.nvim_create_autocmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
--     pattern = { '*' },
--     group = vim.api.nvim_create_augroup('CmdlineAutocompletion', { clear = true }),
--     callback = function(ev)
--         vim.opt.wildmenu = true
--         vim.opt.wildmode = 'noselect:lastused,full'
--         local function should_enable_autocomplete()
--             local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]
--             return is_cmdline_type_find() or cmdline_cmd == 'help' or cmdline_cmd == 'h'
--         end
--         if ev.event == 'CmdlineChanged' and should_enable_autocomplete() then
--           vim.opt.wildmode = 'noselect:lastused,full'
--           vim.schedule(function()
--             vim.fn.wildtrigger()
--           end)
--         end
--         if ev.event == 'CmdlineLeave' then
--             vim.opt.wildmode = 'full'
--         end
--     end
-- })

-- -- [:grep with live updating quickfix list : r/neovim](https://www.reddit.com/r/neovim/comments/1n2ln9w/grep_with_live_updating_quickfix_list/)
-- vim.api.nvim_create_autocmd("CmdlineChanged", {
--     callback = function()
--         local cmdline = vim.fn.getcmdline()
--         local words = vim.split(cmdline, " ", { trimempty = true })
--         if words[1] == "LiveGrep" and #words > 1 then
--             vim.cmd("silent grep! " .. vim.fn.escape(words[2], " "))
--             vim.cmd("cwindow")
--             vim.cmd.redraw()
--         end
--     end,
--     pattern = ":",
-- })

-- vim.api.nvim_create_autocmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
--         pattern = { '*' },
--         group = vim.api.nvim_create_augroup('FuzzyCmdlineCompletion', { clear = true }),
--         callback = function(ev)
--                 if ev.event == 'CmdlineChanged' then
--                         vim.opt.wildmode = 'noselect:lastused,full'
--                         vim.fn.wildtrigger()
--                 end
--                 if ev.event == 'CmdlineLeave' then
--                         vim.opt.wildmode = 'full'
--                 end
--         end
-- })

-- https://stackoverflow.com/questions/42905008/quickfix-list-how-to-add-and-remove-entries
vim.cmd[[
" When using `dd` in the quickfix list, remove the item from the quickfix list.
function! RemoveQFItem()
let curqfidx = line('.') - 1
let qfall = getqflist()
call remove(qfall, curqfidx)
call setqflist(qfall, 'r')
execute curqfidx + 1 . "cfirst"
:copen
endfunction
:command! RemoveQFItem :call RemoveQFItem()
" Use map <buffer> to only map dd in the quickfix window. Requires +localmap
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>
]]

-- Função para remover item atual da Location List
local function remove_loc_item()
  local curidx = vim.fn.line(".") - 1
  local winid = vim.fn.win_getid()

  -- Pega a lista local da janela
  local loclist = vim.fn.getloclist(winid)

  if #loclist == 0 then
    vim.notify("Location List vazia", vim.log.levels.WARN)
    return
  end

  -- Remove o item atual
  table.remove(loclist, curidx + 1)

  -- Atualiza a loclist com a nova lista
  vim.fn.setloclist(winid, loclist, "r")

  -- Reabre para atualizar a janela
  vim.cmd.lwindow()
end

-- Cria comando para remover
vim.api.nvim_create_user_command("RemoveLocItem", remove_loc_item, {})

-- Autocmd: quando abrir uma janela de loclist, mapear `dd`
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(args)
    local wininfo = vim.fn.getwininfo(vim.fn.win_getid())[1]
    if wininfo and wininfo.loclist == 1 then
      vim.api.nvim_buf_set_keymap(
        args.buf,
        "n",
        "dd",
        ":RemoveLocItem<CR>",
        { noremap = true, silent = true }
      )
    end
  end,
})
