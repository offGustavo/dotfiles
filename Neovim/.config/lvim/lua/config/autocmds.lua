vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [Native Fuzzy Finder in Neovim With Lua and Cool Bindings :: Cherry's Blog](https://cherryramatis.xyz/posts/native-fuzzy-finder-in-neovim-with-lua-and-cool-bindings/)
local function is_cmdline_type_find()
    local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]

    return cmdline_cmd == 'find' or cmdline_cmd == 'fin'
end

vim.api.nvim_create_autocmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
    pattern = { '*' },
    group = vim.api.nvim_create_augroup('CmdlineAutocompletion', { clear = true }),
    callback = function(ev)

        vim.opt.wildmenu = true
        vim.opt.wildmode = 'noselect:lastused,full'
        local function should_enable_autocomplete()
            local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]

            return is_cmdline_type_find() or cmdline_cmd == 'help' or cmdline_cmd == 'h'
        end

        if ev.event == 'CmdlineChanged' and should_enable_autocomplete() then
          vim.opt.wildmode = 'noselect:lastused,full'
          vim.schedule(function()
            vim.fn.wildtrigger()
          end)
        end

        if ev.event == 'CmdlineLeave' then
            vim.opt.wildmode = 'full'
        end
    end
})
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
