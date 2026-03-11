local M = {}

local terminals = {}
local current_index = 1
M.terminal_win = nil

-- TabTerm Config
local config = {
    -- Winbar Config
    separator_right = "",
    separator_left = "",
    separator_first = "█",
    center = false,
    default_highlight = "%#Tabline#",
    tab_highlight = "%#TablineSel#",
    -- Window Config
    vertical_size = 20,
    float = false,
}

-- Update Winbar, this uses config.style to customize
local function update_winbar()
    local bufnr = vim.api.nvim_get_current_buf()

    local index = nil
    for i, term in ipairs(terminals) do
        if term.bufnr == bufnr then
            index = i
            break
        end
    end

    if index then
        local get_normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
        local normal_bg = get_normal_bg and string.format("#%06x", get_normal_bg) or "NONE"

        local get_tab_sel_bg = vim.api.nvim_get_hl(0, { name = "TablineSel" }).bg
        local tab_sel_bg = get_tab_sel_bg and string.format("#%06x", get_tab_sel_bg) or "NONE"

        vim.api.nvim_set_hl(0, "TabTermSeparator", {
            fg = tab_sel_bg,
            bg = normal_bg,
            bold = false,
        })

        local winbar = ""
        -- TODO: Make this more customizable similar to what statusline does
        if config.center then
            winbar = winbar .. "%="
        end
        for i, term in ipairs(terminals) do
            if i == 1 and i == index then
                winbar = winbar
                    .. string.format(
                        "%%#TabTermSeparator#%s%s %d:%s %%#TabTermSeparator#%s%%*",
                        config.separator_first,
                        config.tab_highlight,
                        i,
                        term.name,
                        config.separator_right
                    )
            else
                if i == index then
                    winbar = winbar
                        .. string.format(
                            "%%#TabTermSeparator#%s%s %d:%s %%#TabTermSeparator#%s%%*",
                            config.separator_left,
                            config.tab_highlight,
                            i,
                            term.name,
                            config.separator_right
                        )
                else
                    winbar = winbar .. string.format("  %d:%s  ", i, term.name)
                end
            end
        end

        if config.center then
            winbar = winbar .. "%="
        end
        vim.wo.winbar = winbar
    else
        vim.wo.winbar = ""
    end
end

-- Verify if a buffer is a TabTerminal Buffer, if true returns the buffer
local function find_terminal_window()
    if M.terminal_win and vim.api.nvim_win_is_valid(M.terminal_win) then
        return M.terminal_win
    end
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local bufnr = vim.api.nvim_win_get_buf(win)
        for _, term in ipairs(terminals) do
            if term.bufnr == bufnr then
                M.terminal_win = win
                return win
            end
        end
    end
    return nil
end

-- Create the split for the window
local function create_split(new)
    -- NOTE: this must be inverted
    if not new then
        vim.cmd("botright split")
        M.terminal_win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_height(0, config.vertical_size)
        vim.api.nvim_set_current_buf(terminals[current_index].bufnr)
        update_winbar()
    else
        vim.cmd("botright split")
        vim.api.nvim_win_set_height(0, config.vertical_size)
        M.terminal_win = vim.api.nvim_get_current_win()
    end
end

-- Create a new terminal, if a name is passed it will create a terminal with that name
-- TODO: enable creating a terminal with a command
function M.new(name)
    name = name or ("term" .. (#terminals + 1))

    local win = find_terminal_window()
    if win then
        vim.api.nvim_set_current_win(win)
    else
        create_split(true)
    end

    vim.cmd("term")
    local bufnr = vim.api.nvim_get_current_buf()

    vim.api.nvim_set_option_value('buflisted', false, { buf = 0 })

    vim.api.nvim_buf_set_var(bufnr, 'tabterm_created', true)

    table.insert(terminals, { bufnr = bufnr, name = name })
    current_index = #terminals

    update_winbar()

    vim.schedule(function()
        update_winbar()
    end)
end

-- If an id is passed it will delete the buffer, if nothing is passed it will verify if the current window is a tabterm buffer and then close it if true
function M.close(index)
    if not index then
        local bufnr = vim.api.nvim_get_current_buf()
        for i, term in ipairs(terminals) do
            if term.bufnr == bufnr then
                index = i
                break
            end
        end
        if not index then
            print("Not a Terminal Buffer")
            return
        end
    end

    local term = terminals[index]
    if not term then
        print("Terminal " .. index .. " doesn't exist.")
        return
    end

    vim.api.nvim_buf_delete(term.bufnr, { force = true })
    table.remove(terminals, index)

    if #terminals == 0 then
        current_index = 1
        if M.terminal_win and vim.api.nvim_win_is_valid(M.terminal_win) then
            vim.api.nvim_set_current_win(M.terminal_win)
            vim.cmd("enew")
            vim.wo.winbar = ""
        else
            M.terminal_win = nil
        end
    else
        if current_index > #terminals then
            current_index = #terminals
        end

        if not (M.terminal_win and vim.api.nvim_win_is_valid(M.terminal_win)) then
            create_split()
        else
            vim.api.nvim_set_current_win(M.terminal_win)
        end

        vim.api.nvim_set_current_buf(terminals[current_index].bufnr)
        update_winbar()
    end
end

-- If the current window is not a terminal window, it will focus on the last tabterminal buffer; if the current window is a tabterm buffer it will hide the split
function M.toggle()
    local win = find_terminal_window()
    local cur_win = vim.api.nvim_get_current_win()

    if win then
        if win == cur_win then
            config.vertical_size = vim.api.nvim_win_get_height(win)
            vim.api.nvim_win_close(win, true)
            M.terminal_win = nil
        else
            vim.api.nvim_set_current_win(win)
        end
    elseif #terminals > 0 then
        create_split()
    else
        M.new()
    end
end

-- Rename a tabterm; if an id and new name are passed, it renames it. If nothing is passed, it will ask for the new name and verify if it was a tabterm buffer
-- FIX: invert the logic here, first check if it's a tabterm window, then ask for the new name.
function M.rename(input)
    -- If no input was passed, ask the user
    if not input or input == "" then
        vim.ui.input({ prompt = "New Name: " }, function(user_input)
            if user_input and user_input ~= "" then
                M.rename(user_input)
            end
        end)
        return
    end

    local index, new_name = input:match("^(%d+):(.+)$")
    if index and new_name then
        index = tonumber(index)
        if terminals[index] then
            terminals[index].name = new_name
            update_winbar()
        else
            print("Terminal " .. index .. " doesn't exist.")
        end
        return
    end

    -- Otherwise: input is just the new name, so use the current buffer
    local bufnr = vim.api.nvim_get_current_buf()
    for i, term in ipairs(terminals) do
        if term.bufnr == bufnr then
            terminals[i].name = input
            update_winbar()
            return
        end
    end
    print("Can't rename, the current buffer is not a tabterm terminal.")
end

-- Navigate to a terminal buffer based on id
function M.go(index)
    local term = terminals[index]
    if not term then
        print("Terminal " .. index .. " doesn't exist.")
        return
    end

    current_index = index
    local win = find_terminal_window()
    if win then
        vim.api.nvim_set_current_win(win)
    else
        create_split()
    end
    vim.api.nvim_set_current_buf(term.bufnr)
    update_winbar()
end

-- Set the config and commands
function M.setup(user_config)
    config = vim.tbl_extend("force", config, user_config or {})

    vim.api.nvim_create_autocmd("BufWipeout", {
        callback = function(args)
            local ok, created = pcall(vim.api.nvim_buf_get_var, args.buf, 'tabterm_created')
            if ok and created then
                for i, term in ipairs(terminals) do
                    if term.bufnr == args.buf then
                        table.remove(terminals, i)
                        if current_index > #terminals then
                            current_index = #terminals
                        end
                        break
                    end
                end
                if M.terminal_win and not vim.api.nvim_win_is_valid(M.terminal_win) then
                    M.terminal_win = nil
                end
                if #terminals == 0 then
                    vim.wo.winbar = ""
                end
            end
        end,
    })
    vim.api.nvim_create_user_command("TabTermToggle", M.toggle, {})

    vim.api.nvim_create_user_command("TabTermNew", function(opts)
        M.new(opts.args ~= "" and opts.args or nil)
    end, { nargs = "?" })

    vim.api.nvim_create_user_command("TabTermClose", function(opts)
        if opts.args ~= "" then
            local idx = tonumber(opts.args)
            if idx then
                M.close(idx)
            end
        else
            M.close(nil)
        end
    end, { nargs = "?" })

    vim.api.nvim_create_user_command("TabTermRename", function(opts)
        M.rename(opts.args)
    end, { nargs = "?" })

    vim.api.nvim_create_user_command("TabTermGo", function(opts)
        local index = tonumber(opts.args) or 1 -- defaults to 1 if not a number
        M.go(index)
    end, { nargs = "?" })

    function M.go(index)
        local term = terminals[index]
        if not term then
            print("Terminal " .. (index or "?") .. " doesn't exist.")
            return
        end

        current_index = index
        local win = find_terminal_window()
        if win then
            vim.api.nvim_set_current_win(win)
        else
            create_split()
        end
        vim.api.nvim_set_current_buf(term.bufnr)
        update_winbar()
    end
end

return M
