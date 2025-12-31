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

-- [:grep with live updating quickfix list : r/neovim](https://www.reddit.com/r/neovim/comments/1n2ln9w/grep_with_live_updating_quickfix_list/)
vim.api.nvim_create_autocmd("CmdlineChanged", {
  callback = function()
    local cmdline = vim.fn.getcmdline()
    local words = vim.split(cmdline, " ", { trimempty = true })
    if words[1] == "LiveGrep" and #words > 1 then
      vim.cmd("silent grep! " .. vim.fn.escape(words[2], " "))
      vim.cmd("cwindow")
      vim.cmd.redraw()
    end
  end,
  pattern = ":",
})

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
vim.cmd([[
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
]])

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
      vim.api.nvim_buf_set_keymap(args.buf, "n", "dd", ":RemoveLocItem<CR>", { noremap = true, silent = true })
    end
  end,
})

-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
--   callback = function(args)
--     local name = vim.api.nvim_buf_get_name(args.buf)
--     if name == "" then
--       return
--     end
--     local dir = vim.fn.fnamemodify(name, ":p:h")
--     vim.cmd.lcd(dir)
--   end,
-- })


-- Function to find next/prev error pattern in terminal buffer
local function find_error_line(direction)
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local total_lines = vim.api.nvim_buf_line_count(0)
  local pattern = "[^:]+:%d+:?%d*:?.*"

  local line = current_line
  local step = direction == "next" and 1 or -1

  while true do
    line = line + step

    -- Wrap around
    if line > total_lines then
      line = 1
    elseif line < 1 then
      line = total_lines
    end

    -- Return to start if we've checked all lines
    if line == current_line then
      break
    end

    local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
    if line_content and line_content:match(pattern) then
      vim.api.nvim_win_set_cursor(0, { line, 0 })
      vim.cmd("normal! zzgF") -- Center the line
      return
    end
  end

  vim.notify("No more errors found", vim.log.levels.INFO)
end

-- Jump to error at current line
local function jump_to_error()
  local line = vim.api.nvim_get_current_line()

  -- Try different patterns
  -- pattern: file:line:column
  local file, line_num, col = line:match("([^:]+):(%d+):(%d+)")

  -- pattern: file:line
  if not file then
    file, line_num = line:match("([^:]+):(%d+)")
    col = nil
  end

  -- pattern: file:line:column:message
  if not file then
    file, line_num, col = line:match("([^:]+):(%d+):(%d+):.*")
  end

  -- pattern: file:line:message
  if not file then
    file, line_num = line:match("([^:]+):(%d+):.*")
    col = nil
  end

  if file and line_num then
    -- Expand ~ to home directory if present
    if file:match("^~") then
      file = vim.fn.expand(file)
    end

    -- Jump to the file
    local success, err = pcall(vim.cmd, "e +" .. line_num .. " " .. vim.fn.fnameescape(file))

    if success and col and col ~= "" then
      -- Set cursor to specific column if provided
      vim.api.nvim_win_set_cursor(0, { tonumber(line_num), tonumber(col) - 1 })
    end

    if success then
      vim.cmd("normal! zzgF") -- Center the line
    else
      vim.notify("Failed to open file: " .. (err or "unknown error"), vim.log.levels.ERROR)
    end
  else
    vim.notify("No file:line pattern found on this line", vim.log.levels.WARN)
  end
end

-- Set up keymaps in terminal buffers only
vim.api.nvim_create_autocmd({ "BufEnter", "TermOpen" }, {
  pattern = "*",
  callback = function(args)
    local buf = args.buf
    local buftype = vim.api.nvim_buf_get_option(buf, "buftype")

    if buftype == "terminal" then
      -- Navigate to next error in terminal buffer
      vim.keymap.set("n", "<A-g>n", function()
        find_error_line("next")
      end, { buffer = buf, desc = "Next error in terminal" })

      -- Navigate to previous error in terminal buffer
      vim.keymap.set("n", "<A-g>p", function()
        find_error_line("prev")
      end, { buffer = buf, desc = "Previous error in terminal" })

      -- Jump to error at cursor line
      vim.keymap.set("n", "<Cr>", jump_to_error, {
        buffer = buf,
        desc = "Jump to file:line from grep results",
      })

      -- Jump to error at cursor line
      vim.keymap.set("n", "q", ":close<Cr>", {
        buffer = buf,
        desc = "Quit buffer",
      })
    end
  end,
})

-- Optional: Also add a global command to jump to errors from any buffer
vim.api.nvim_create_user_command("GotoError", function(opts)
  -- Get the line from args or visual selection
  local line
  if opts.args and opts.args ~= "" then
    line = opts.args
  else
    line = vim.api.nvim_get_current_line()
  end

  -- Parse and jump (simplified parsing)
  local file, line_num = line:match("([^:]+):(%d+)")
  if file and line_num then
    vim.cmd("e +" .. line_num .. " " .. vim.fn.fnameescape(file))
  else
    vim.notify("No valid file:line pattern found", vim.log.levels.WARN)
  end
end, { nargs = "?", desc = "Jump to file:line pattern" })
