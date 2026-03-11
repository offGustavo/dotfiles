-- lazygit.nvim - Open lazygit in a floating window

local M = {}

---Configurable user options.
---@class Options
---@field enable_cmds boolean            Create :Lazygit commands
---@field keybindings table<string, string> Terminal mode keymaps
---@field ui UI                          Window appearance
---@field on_exit function|nil            Function to run after lazygit exits (optional)

---@class UI
---@field border string   (see ':h nvim_open_win')
---@field height number   0 to 1 (0% to 100% of screen)
---@field width number    0 to 1
---@field x number        0 to 1 (left to right)
---@field y number        0 to 1 (top to bottom)

---@class WindowDimensions
---@field height number
---@field width number
---@field row number
---@field col number

---@type Options
local opts = {
    enable_cmds = false,
    ui = {
        border = "none",
        height = 1,
        width = 1,
        x = 0.5,
        y = 0.5,
    },
    keybindings = {},
    on_exit = nil, -- e.g., function() vim.cmd('Git status') end
}

---Builds the lazygit launch command.
---@param path string|nil Working directory (default: current buffer's directory or cwd)
---@return string cmd, string cwd
local function build_lazygit_cmd(path)
    local cmd = "lazygit"
    -- Determine working directory
    local cwd = path or vim.fn.expand("%:p:h") -- fallback to current file's directory
    if cwd == "" then
        cwd = vim.loop.cwd()                   -- fallback to Neovim's cwd
    end
    return cmd, cwd
end

---Returns window dimensions based on ui options.
---@return WindowDimensions
local function get_window_dimensions()
    local win_height = math.ceil(vim.o.lines * opts.ui.height)
    local win_width = math.ceil(vim.o.columns * opts.ui.width)
    return {
        height = win_height,
        width = win_width,
        row = math.ceil((vim.o.lines - win_height) * opts.ui.y - 1),
        col = math.ceil((vim.o.columns - win_width) * opts.ui.x),
    }
end

---Open a floating window for lazygit.
local function open_win()
    local buf = vim.api.nvim_create_buf(false, true)

    local win = vim.api.nvim_open_win(
        buf,
        true,
        vim.tbl_extend("error", {
            relative = "editor",
            border = opts.ui.border,
            style = "minimal",
        }, get_window_dimensions())
    )
    vim.api.nvim_set_option_value("winhl", "NormalFloat:Normal", { win = win })
    vim.api.nvim_set_option_value("filetype", "lazygit", { buf = buf })

    -- Resize window on VimResized
    local group = vim.api.nvim_create_augroup("lazygit_window", { clear = true })
    vim.api.nvim_create_autocmd("VimResized", {
        group = group,
        buffer = buf,
        callback = function()
            vim.api.nvim_win_set_config(
                win,
                vim.tbl_deep_extend("force", vim.api.nvim_win_get_config(win), get_window_dimensions())
            )
        end,
    })

    -- Apply custom keymaps
    for keybind, command in pairs(opts.keybindings) do
        vim.api.nvim_buf_set_keymap(buf, "t", keybind, command, { silent = true })
    end

    return buf, win
end

---Opens lazygit in a floating window.
---@param path string|nil Working directory (default: current file's directory or cwd)
---@param open_mode any (kept for API compatibility, ignored)
function M.open(path, open_mode)
    -- Check if lazygit is installed
    assert(
        vim.fn.executable("lazygit") == 1,
        "lazygit executable not found. Please ensure lazygit is installed and in your PATH."
    )

    local cmd, cwd = build_lazygit_cmd(path)
    local last_win = vim.api.nvim_get_current_win()

    open_win()

    local on_exit = function(_, code, _)
        vim.api.nvim_win_close(0, true)
        vim.api.nvim_set_current_win(last_win)

        if code == 0 and opts.on_exit then
            opts.on_exit()
        end
    end

    local term_opts = {
        cwd = cwd,
        on_exit = on_exit,
        -- FIXME: this sould work...
        -- env = {
        --     EDITOR = "$NVIM --remote",
        --     VISUAL = "$NVIM --remote",
        -- }
    }

    vim.fn.jobstart(cmd, vim.tbl_extend("force", { term = true }, term_opts))
    vim.cmd.startinsert()
end

---Setup function.
---@param user_opts Options|nil
function M.setup(user_opts)
    if user_opts then
        opts = vim.tbl_deep_extend("force", opts, user_opts)
    end

    if opts.enable_cmds then
        vim.cmd('command! LazyGit lua require("fish.lazygit").open()')
        -- vim.keymap.set("n", "<leader>gg", function()
        --     require("fish.lazygit").open(vim.loop.cwd())
        -- end, { desc = "Open lazygit" })

        -- Optional: commands that open lazygit in different directories
        -- e.g., current file's directory, Neovim's cwd, etc.
        vim.cmd('command! LazyGitCwd lua require("fish.lazygit").open(vim.loop.cwd())')
        vim.cmd('command! LazyGitFileDir lua require("fish.lazygit").open(vim.fn.expand("%:p:h"))')
    end
end

return M
