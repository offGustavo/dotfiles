-- lazygit.nvim - Open lazygit in a floating window, themed to match the current colorscheme

local M = {}

---@class UI
---@field border string   (see ':h nvim_open_win')
---@field height number   0 to 1 (0% to 100% of screen)
---@field width number    0 to 1
---@field x number        0 to 1 (left to right)
---@field y number        0 to 1 (top to bottom)

---@class Options
---@field enable_cmds boolean               Create the :Lazygit command
---@field keybindings table<string,string>  Terminal-mode keymaps
---@field ui UI                             Window appearance
---@field theme boolean                     Generate a lazygit theme from the current colorscheme
---@field remote_edit boolean                Make lazygit's "e" open files in this running Neovim (Unix + Windows)
---@field on_exit function|nil              Called after lazygit exits successfully

---@type Options
local opts = vim.tbl_deep_extend("force", {
  enable_cmds = false,
  theme = true,
  remote_edit = true,
  ui = {
    border = "none",
    height = 1,
    width = 1,
    x = 0.5,
    y = 0.5,
  },
  keybindings = {},
  on_exit = nil, -- e.g. function() vim.cmd("Git status") end
}, vim.g.lazygit_config or {})

local config_path = vim.fn.stdpath("cache") .. "/lazygit-nvim.yml"

-- ── Generated lazygit config (theme + remote-edit) ─────────────────────────

---Returns the hex color of a highlight group's fg/bg, or nil if unresolved.
---@param group string
---@param attr "fg"|"bg"
---@return string|nil
local function hl_hex(group, attr)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if not ok or not hl or not hl[attr] then
    return nil
  end
  return string.format("#%06x", hl[attr])
end

---Tries each highlight group in order, falling back to a default color.
---@param groups string[]
---@param attr "fg"|"bg"
---@param fallback string
---@return string
local function color(groups, attr, fallback)
  for _, group in ipairs(groups) do
    local hex = hl_hex(group, attr)
    if hex then
      return hex
    end
  end
  return fallback
end

---Renders lazygit's `gui.theme` yaml block from the active colorscheme.
---@return string
local function build_gui_theme()
  local active = color({ "MatchParen", "Function", "Constant" }, "fg", "#89b4fa")
  local border = color({ "FloatBorder", "WinSeparator", "Comment" }, "fg", "#6c7086")
  local option_text = color({ "Function", "Identifier" }, "fg", "#89b4fa")
  local selected_bg = color({ "Visual", "CursorLine" }, "bg", "#313244")
  local unstaged = color({ "DiagnosticError", "ErrorMsg" }, "fg", "#f38ba8")

  return table.concat({
    "gui:",
    "  theme:",
    "    activeBorderColor:",
    ("      - '%s'"):format(active),
    "      - bold",
    "    inactiveBorderColor:",
    ("      - '%s'"):format(border),
    "    optionsTextColor:",
    ("      - '%s'"):format(option_text),
    "    selectedLineBgColor:",
    ("      - '%s'"):format(selected_bg),
    "    selectedRangeBgColor:",
    ("      - '%s'"):format(selected_bg),
    "    cherryPickedCommitBgColor:",
    ("      - '%s'"):format(selected_bg),
    "    cherryPickedCommitFgColor:",
    ("      - '%s'"):format(active),
    "    unstagedChangesColor:",
    ("      - '%s'"):format(unstaged),
  }, "\n")
end

-- Neovim always exports $NVIM (the server address) into :terminal jobs, so as
-- long as lazygit runs inside this floating terminal, these commands hand
-- the file back to *this* running Neovim instead of spawning a nested one.
local UNIX_REMOTE_EDIT_YAML = table.concat({
  "os:",
  "  edit: 'nvim --server \"$NVIM\" --remote-tab {{filename}}'",
  '  editAtLine: \'nvim --server "$NVIM" --remote-tab {{filename}}; '
    .. '[ -z "$NVIM" ] || nvim --server "$NVIM" --remote-send ":{{line}}<CR>"\'',
  "  editAtLineAndWait: 'nvim +{{line}} {{filename}}'",
  "  promptToReturnFromSubprocess: false",
}, "\n")

-- lazygit runs os.edit commands through cmd.exe on Windows, where $NVIM/[ -z ]
-- aren't valid syntax, so route the same logic through an inline PowerShell
-- one-liner instead (no extra script file to manage).
local WINDOWS_REMOTE_EDIT_YAML = table.concat({
  "os:",
  "  edit: 'powershell -NoProfile -Command \"if ($env:NVIM) "
    .. "{ nvim --server $env:NVIM --remote-tab {{filename}} } else { nvim {{filename}} }\"'",
  "  editAtLine: 'powershell -NoProfile -Command \"if ($env:NVIM) "
    .. "{ nvim --server $env:NVIM --remote-tab {{filename}}; "
    .. "nvim --server $env:NVIM --remote-send '':{{line}}<CR>'' } else { nvim +{{line}} {{filename}} }\"'",
  "  editAtLineAndWait: 'nvim +{{line}} {{filename}}'",
  "  promptToReturnFromSubprocess: false",
}, "\n")

local IS_WINDOWS = vim.fn.has("win32") == 1

---Builds the yaml lazygit config for the current session (theme, remote edit).
---@return string
local function build_config_yaml()
  local sections = {}
  if opts.remote_edit then
    table.insert(sections, IS_WINDOWS and WINDOWS_REMOTE_EDIT_YAML or UNIX_REMOTE_EDIT_YAML)
  end
  if opts.theme then
    table.insert(sections, build_gui_theme())
  end
  return table.concat(sections, "\n") .. "\n"
end

---Finds the user's own lazygit config file (if any), so we don't clobber it.
---@return string|nil
local function user_config_path()
  local config_home = os.getenv("XDG_CONFIG_HOME")
  if not config_home or config_home == "" then
    local home = os.getenv("HOME")
    config_home = home and (home .. "/.config") or nil
  end
  if not config_home then
    return nil
  end
  local path = config_home .. "/lazygit/config.yml"
  return vim.loop.fs_stat(path) and path or nil
end

---Writes the generated config file and returns the LG_CONFIG_FILE value,
---merging in the user's own config (if present) so it still applies.
---@return string|nil
local function config_files()
  if not (opts.theme or opts.remote_edit) then
    return nil
  end

  local file = io.open(config_path, "w")
  if file then
    file:write(build_config_yaml())
    file:close()
  end

  local user_config = user_config_path()
  return user_config and (user_config .. "," .. config_path) or config_path
end

-- ── Window & process management ─────────────────────────────────────────────

---@return { height: number, width: number, row: number, col: number }
local function get_window_dimensions()
  local height = math.ceil(vim.o.lines * opts.ui.height)
  local width = math.ceil(vim.o.columns * opts.ui.width)
  return {
    height = height,
    width = width,
    row = math.ceil((vim.o.lines - height) * opts.ui.y - 1),
    col = math.ceil((vim.o.columns - width) * opts.ui.x),
  }
end

---Opens a scratch floating window for lazygit's terminal.
---@return integer buf, integer win
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

  -- vim.api.nvim_create_autocmd({ "BufEnter", "Filetype" }, {
  --   pattern = "lazygit",
  --   group = group,
  --   callback = function()
  --     vim.cmd.startinsert()
  --   end,
  -- })

  for keybind, command in pairs(opts.keybindings) do
    vim.api.nvim_buf_set_keymap(buf, "t", keybind, command, { silent = true })
  end

  return buf, win
end

---Opens lazygit in a floating window, themed to match the current colorscheme.
---@param path string|nil Working directory (default: current file's directory, else cwd)
function M.open(path)
  if vim.fn.executable("lazygit") ~= 1 then
    vim.notify("lazygit executable not found in PATH", vim.log.levels.ERROR, { title = "lazygit.nvim" })
    return
  end

  local cwd = path or vim.fn.expand("%:p:h")
  if cwd == "" then
    cwd = vim.loop.cwd()
  end

  local last_win = vim.api.nvim_get_current_win()
  local config = config_files()
  local env = config and { LG_CONFIG_FILE = config } or nil

  open_win()

  vim.fn.jobstart("lazygit", {
    term = true,
    cwd = cwd,
    env = env,
    on_exit = function(_, code)
      if vim.api.nvim_win_is_valid(0) then
        vim.api.nvim_win_close(0, true)
      end
      if vim.api.nvim_win_is_valid(last_win) then
        vim.api.nvim_set_current_win(last_win)
      end
      if code == 0 and opts.on_exit then
        opts.on_exit()
      end
    end,
  })

  vim.cmd.startinsert()
end

return M
