local M = {}

local is_windows = vim.fn.has("win32") == 1

-- On Windows, Neovim listens on named pipes instead of unix socket files.
local PIPE_PREFIX = [[\\.\pipe\nvim-sessionizer-]]

local sessions_dir
if is_windows then
  sessions_dir = vim.fs.normalize(vim.fn.stdpath("cache") .. "/nvim-sessionizer")
else
  sessions_dir = "/tmp/nvim-sessionizer"
end
vim.fn.mkdir(sessions_dir, "p")

M.sessions = {}
M.current_index = nil
M.session_order = {}

--- Configuration table for Sessionizer
---@class SessionizerConfig
---@field no_zoxide boolean Disable zoxide integration
---@field search_dirs string[] Directories to search for projects
---@field max_depth integer Maximum depth to search for projects
---@field ui SessionizerUIConfig? UI configuration

---@class SessionizerUIConfig
---@field keymap SessionizerKeymapConfig Key mappings for actions
---@field win SessionizerWinConfig Window configuration
---@field current SessionizerCurrentConfig Highlight for the current session

---@class SessionizerKeymapConfig
---@field quit string Key to quit the window
---@field attach string Key to attach to a session
---@field delete string Key to delete a session
---@field move_up string Key to move session up
---@field move_down string Key to move session down

---@class SessionizerWinConfig
---@field width number Window width ratio (0-1)
---@field height number Window height ratio (0-1)
---@field winbar SessionizerWinbarConfig Winbar configuration

---@class SessionizerWinbarConfig
---@field hl_left string Highlight group for left section text
---@field hl_right string Highlight group for right section text
---@field hl_separator string Highlight group for separators
---@field sep_left string Separator between left items
---@field sep_mid string Separator for middle alignment
---@field sep_right string Separator between right items
---@field format fun(config:SessionizerConfig):{left:string[], right:string[]} Function that returns formatted winbar items

---@class SessionizerCurrentConfig
---@field mark string Marker for the current session
---@field hl string Highlight group for the marker
local config = {
  no_zoxide = false,
  search_dirs = { "~/projects", "~/work" },
  max_depth = 3,
  ui = {
    keymap = {
      quit = "q",
      attach = "<CR>",
      delete = "<S-d>",
      move_up = "<S-k>",
      move_down = "<S-j>",
    },
    win = {
      width = 0.6,
      height = 0.4,
      winbar = {
        hl_left = "Title", -- highlight group para a parte esquerda
        hl_right = "Comment", -- highlight group para a parte direita
        hl_separator = "Comment", -- highlight group para a parte direita
        sep_left = "/", -- separador entre ações
        sep_mid = "%=", -- separador para alinhar
        sep_right = "│",
        format = function(config) -- agora recebe o config
          return {
            left = {
              " " .. config.ui.keymap.quit .. " close",
              config.ui.keymap.delete .. " delete session",
            },
            right = {
              config.ui.keymap.attach .. " attach session",
              config.ui.keymap.move_up .. "/" .. config.ui.keymap.move_down .. " move session ",
            },
          }
        end,
      },
    },
    current = {
      mark = ">",
      hl = "MatchParen",
    },
  },
}

--- Update Sessionzer config based on user config
config = vim.tbl_extend("force", config, vim.g.sessionizer or {})

---------------------------------------------------------------------------
-- Platform helpers
---------------------------------------------------------------------------

---Path of the file that represents a session in `sessions_dir`.
---On Linux/macOS this is the socket itself; on Windows it is an empty marker file.
---@param name string
---@return string
local function marker_path(name)
  return sessions_dir .. "/" .. name
end

---@param name string
---@return string
local function session_file_path(name)
  return sessions_dir .. "/" .. name .. ".vim"
end

---Address passed to `nvim --listen` / `:connect`.
---@param name string
---@return string
local function socket_address(name)
  if is_windows then
    return PIPE_PREFIX .. name
  end
  return marker_path(name)
end

---Check if a server is accepting connections at `address`.
---@param address string
---@return boolean
local function is_alive(address)
  local ok, chan = pcall(vim.fn.sockconnect, "pipe", address, { rpc = true })
  if ok and type(chan) == "number" and chan > 0 then
    pcall(vim.fn.chanclose, chan)
    return true
  end
  return false
end

---Check if a session server is running.
---@param name string
---@return boolean
local function session_exists(name)
  if is_windows then
    return is_alive(socket_address(name))
  end
  local socket = marker_path(name)
  return vim.fn.filereadable(socket) == 1 or vim.fn.getftype(socket) == "socket"
end

---Files in `sessions_dir` that are not sessions.
---@param filename string
---@return boolean
local function is_reserved(filename)
  return filename == "session_order" or filename:match("%.vim$") ~= nil
end

---Build a safe session name from a path.
---@param path string
---@return string
local function make_name(path)
  local name = vim.fs.basename(vim.fs.normalize(path))
  name = name:gsub('[%.%s\\/:*?"<>|]', "_")
  if name == "" then
    name = "root"
  end
  return name
end

---------------------------------------------------------------------------
-- Session order
---------------------------------------------------------------------------

---Save the session order to a file.
---@return nil
local function save_session_order()
  local order_file = sessions_dir .. "/session_order"
  local lines = {}
  for _, session_name in ipairs(M.session_order) do
    table.insert(lines, session_name)
  end
  vim.fn.writefile(lines, order_file)
end

---Load the session order from a file.
---@return nil
local function load_session_order()
  local order_file = sessions_dir .. "/session_order"
  if vim.fn.filereadable(order_file) == 1 then
    local lines = vim.fn.readfile(order_file)
    M.session_order = lines
  else
    M.session_order = {}
  end
end

---Apply the saved session order to the current sessions list.
---@return nil
local function apply_session_order()
  if #M.session_order > 0 then
    local ordered_sessions = {}
    local unordered_sessions = {}

    for _, ordered_name in ipairs(M.session_order) do
      for _, session_name in ipairs(M.sessions) do
        if session_name == ordered_name then
          table.insert(ordered_sessions, session_name)
          break
        end
      end
    end

    for _, session_name in ipairs(M.sessions) do
      local found = false
      for _, ordered_name in ipairs(ordered_sessions) do
        if session_name == ordered_name then
          found = true
          break
        end
      end
      if not found then
        table.insert(unordered_sessions, session_name)
      end
    end

    M.sessions = ordered_sessions
    for _, session_name in ipairs(unordered_sessions) do
      table.insert(M.sessions, session_name)
    end
  end
end

---Build a formatted winbar string with highlights and separators.
---The function processes left and right sections of the winbar configuration,
---applying highlights to keymaps and using specified separators.
---@return string # Formatted winbar string ready for vim.wo.winbar
local function build_winbar()
  -- TODO: Simplificar isso
  local wb_cfg = config.ui.win.winbar
  local fmt = wb_cfg.format(config)

  local left = {}
  for i, txt in ipairs(fmt.left or {}) do
    table.insert(left, string.format("%%#%s#%s%%*", wb_cfg.hl_left, txt))
    if i < #fmt.left then
      table.insert(left, wb_cfg.sep_left)
    end
  end

  local right = {}
  for i, txt in ipairs(fmt.right or {}) do
    table.insert(right, string.format("%%#%s#%s%%*", wb_cfg.hl_right, txt))
    if i < #fmt.right then
      table.insert(right, wb_cfg.sep_right)
    end
  end

  return table.concat(left, " ") .. " " .. wb_cfg.sep_mid .. " " .. table.concat(right, " ")
end

---Verify if a command exists in the system.
---@param cmd string Command name to check.
---@return boolean True if the command exists, false otherwise.
local function command_exists(cmd)
  return vim.fn.executable(cmd) == 1
end

--- Return the current session name.
---@return string The current session name ("" if this instance is not a sessionizer session on Windows).
function M.get_current_session()
  local servername = vim.v.servername
  if is_windows then
    local normalized = (servername:gsub("/", "\\"))
    if normalized:sub(1, #PIPE_PREFIX):lower() == PIPE_PREFIX:lower() then
      return normalized:sub(#PIPE_PREFIX + 1)
    end
    return ""
  end
  return vim.fn.fnamemodify(servername, ":t")
end

--- Update the session list and set the current index.
--- @return nil
function M.update_sessions()
  local sessions = vim.fn.globpath(sessions_dir, "*", false, true)
  M.sessions = {}
  for _, path in ipairs(sessions) do
    local session_name = vim.fn.fnamemodify(path, ":t")
    -- Ignora o arquivo de ordem das sessões e os arquivos de mksession
    if not is_reserved(session_name) then
      if is_windows and not is_alive(socket_address(session_name)) then
        -- Stale marker (server is gone)
        vim.fn.delete(path)
      else
        table.insert(M.sessions, session_name)
      end
    end
  end

  load_session_order()
  apply_session_order()

  if #M.sessions == 0 then
    M.current_index = nil
  else
    local current = M.get_current_session()
    M.current_index = nil
    for i, name in ipairs(M.sessions) do
      if name == current then
        M.current_index = i
        break
      end
    end
  end
end

---Wait until a session server is accepting connections, then call `on_ready`.
---@param name string
---@param on_ready fun()
---@param tries? integer
local function wait_for_session(name, on_ready, tries)
  tries = tries or 0
  if session_exists(name) then
    on_ready()
  elseif tries >= 50 then
    vim.notify("Timed out waiting for session '" .. name .. "'", vim.log.levels.ERROR)
  else
    vim.defer_fn(function()
      wait_for_session(name, on_ready, tries + 1)
    end, 100)
  end
end

--- Create (or connect to) a Neovim session.
---
--- This function will:
--- 1. Validate the provided path.
--- 2. Derive a session name if one is not provided.
--- 3. Check if a server for this session already exists.
---    - If it exists, connect to the running session.
---    - If it doesn't, start a new Neovim instance listening on the session address.
--- 4. Attach the current client to the session.
---
---@param path string The filesystem path where the session will start.
---@param name? string Optional session name. Defaults to the last directory name in `path`.
local function create_session(path, name)
  if not path then
    vim.notify("Path is required!", vim.log.levels.ERROR)
    return
  end

  name = name or make_name(path)
  local address = socket_address(name)
  local session_file = session_file_path(name)

  if session_exists(name) then
    vim.notify("Existing session found. Connecting to '" .. name .. "'...", vim.log.levels.INFO)
  else
    local cmd = { vim.v.progpath, "--listen", address }
    if is_windows then
      -- No terminal available for the detached server on Windows
      table.insert(cmd, 2, "--headless")
    end

    -- Se houver arquivo de sessão salvo, carrega ele
    if vim.fn.filereadable(session_file) == 1 then
      vim.notify("Session file found. Restoring session '" .. name .. "'...", vim.log.levels.INFO)
      vim.list_extend(cmd, { "-S", session_file })
    end

    -- Caso contrário, apenas abre Neovim no diretório (cwd)
    local job = vim.fn.jobstart(cmd, { detach = true, cwd = path })
    if job <= 0 then
      vim.notify("Failed to start Neovim for session '" .. name .. "'", vim.log.levels.ERROR)
      return
    end

    if is_windows then
      -- Named pipes are not visible on the filesystem, so keep a marker file
      -- to be able to list sessions.
      vim.fn.writefile({}, marker_path(name))
    end
  end

  -- Conecta quando o servidor estiver pronto
  wait_for_session(name, function()
    M.attach_session(name)
  end)
end

--- Retrieve a list of directories for selection.
---
--- This function attempts to get directories in the following order:
--- 1. First tries to use zoxide if available and not disabled in config
---    - Returns directories with scores from zoxide query
---    - Format: "score path" for display
--- 2. Falls back to scanning the configured search directories (pure Lua,
---    no external `find`, so it also works on Windows)
---    - Searches directories specified in config.search_dirs
---    - Respects config.max_depth (default: 3)
---
---@return table[] # Array of directory items, each containing:
---   - path (string): Full path to the directory
---   - display (string): Formatted display string for UI presentation
---   Returns empty table if no directories found or on error
---
---@see config.no_zoxide Configuration flag to disable zoxide usage
---@see config.search_dirs List of directories to search when zoxide is unavailable
---@see config.max_depth Maximum directory depth for the fallback scan (default: 3)
function M.get_dirs()
  -- 1. Try zoxide if available and not disabled
  if not config.no_zoxide and command_exists("zoxide") then
    local results = vim.fn.systemlist({ "zoxide", "query", "-l", "-s" }, nil, 1)
    if #results == 0 then
      vim.notify("No directories found by zoxide", vim.log.levels.WARN)
      return {}
    end

    local items = {}
    for _, line in ipairs(results) do
      local score, path = line:match("(%S+)%s+(.+)")
      if path then
        table.insert(items, {
          path = path,
          display = string.format("%s %s", score, path),
        })
      end
    end
    return items
  end

  -- 2. Collect existing search directories from config
  local existing_dirs = {}
  for _, dir in ipairs(config.search_dirs or {}) do
    local expanded = vim.fs.normalize(vim.fn.expand(dir))
    if vim.fn.isdirectory(expanded) == 1 then
      table.insert(existing_dirs, expanded)
    end
  end

  if #existing_dirs == 0 then
    vim.notify("No valid search directories found", vim.log.levels.ERROR)
    return {}
  end

  -- 3. Scan directories (TODO: add fd command support)
  local ignored = { [".git"] = true, ["node_modules"] = true }
  local items = {}
  for _, dir in ipairs(existing_dirs) do
    local iter = vim.fs.dir(dir, {
      depth = config.max_depth or 3,
      skip = function(d)
        if ignored[vim.fs.basename(d)] then
          return false -- do not descend
        end
      end,
    })
    for name, type in iter do
      if type == "directory" and not ignored[vim.fs.basename(name)] then
        local full = dir .. "/" .. name
        table.insert(items, { path = full, display = full })
      end
    end
  end

  if #items == 0 then
    vim.notify("No directories found", vim.log.levels.WARN)
    return {}
  end

  return items
end

---Save the current session state and connect to another session.
---@param name string Target session name
local function connect_to_session(name)
  local current = M.get_current_session()
  if current ~= "" then
    -- Save session state before leaving
    pcall(vim.cmd, "mksession! " .. vim.fn.fnameescape(session_file_path(current)))
  end
  -- Table form avoids Ex-command parsing of backslashes in pipe names
  vim.cmd({ cmd = "connect", args = { socket_address(name) } })
end

--- Select a project directory using zoxide or a scan of the configured search paths,
--- and call the provided callback with the selected path.
---@param callback fun(path:string) Function to call with the selected project path.
---@return nil
local function select_project(callback)
  local items = M.get_dirs()

  if #items == 0 then
    return
  end

  -- Use vim.ui.select to show picker
  vim.ui.select(items, {
    prompt = "Select a project:",
    format_item = function(item)
      return item.display
    end,
  }, function(choice)
    if choice and choice.path then
      callback(choice.path)
    else
      vim.notify("No project selected", vim.log.levels.WARN)
    end
  end)
end

--- TODO: Improve the lua doc
--- Create a new session in the current working directory.
--- Prompts the user for a session name, then calls `create_session`.
--- If the user presses <Esc>, the operation is canceled.
--- If the user presses <Enter> without typing a name, a new session will be created
--- using the current directory name as default.
--- @param path? string
---@return nil
function M.new_session(path)
  if path then
    create_session(path, nil)
  else
    vim.ui.input({ prompt = "Session name: " }, function(name)
      local path = vim.uv.cwd() .. ""
      if name == nil then
        vim.notify("Operation canceled. Session not created.", vim.log.levels.WARN)
        return
      end
      if name == "" then
        name = make_name(path)
        vim.notify("No session name provided. Using default: " .. name, vim.log.levels.INFO)
      end
      vim.cmd("mksession! " .. vim.fn.fnameescape(session_file_path(name)))
      create_session(path, name)
    end)
  end
end

--- Attach to an existing session.
--- If `arg` is:
---   - `+1`: attach to the next session in the list
---   - `-1`: attach to the previous session
---   - a number: attach to the session at that index
---   - a string: attach to the session by name
--- Otherwise, shows a session picker for manual selection.
---@param arg? string|number|nil Session selector (`+1`, `-1`, index number, name, or nil for manual choice).
function M.attach_session(arg)
  M.update_sessions()
  if #M.sessions == 0 then
    vim.notify("No sessions found", vim.log.levels.WARN)
    return
  end

  -- Handle relative (+1/-1) or numeric index
  if arg == "+1" or arg == "-1" or tonumber(arg) then
    if not M.current_index then
      vim.notify("Current session not found, please select manually.", vim.log.levels.WARN)
      return
    end

    local new_index
    if arg == "+1" then
      new_index = M.current_index + 1
    elseif arg == "-1" then
      new_index = M.current_index - 1
    else
      new_index = tonumber(arg)
    end

    -- Wrap around if index goes out of range
    if new_index < 1 then
      new_index = #M.sessions
    elseif new_index > #M.sessions then
      new_index = 1
    end

    local next_session = M.sessions[new_index]
    connect_to_session(next_session)
    vim.notify("Connected to session: " .. next_session .. " (index " .. new_index .. ")")
    M.current_index = new_index

  -- Handle string session name
  elseif type(arg) == "string" and arg ~= "" then
    local found_index
    for i, name in ipairs(M.sessions) do
      if name == arg then
        found_index = i
        break
      end
    end

    if found_index then
      connect_to_session(arg)
      vim.notify("Connected to session: " .. arg)
      M.current_index = found_index
    else
      vim.notify("Session not found: " .. arg, vim.log.levels.ERROR)
    end

  -- Fallback: manual picker
  else
    vim.ui.select(M.sessions, { prompt = "Select a session to connect:" }, function(choice)
      if choice then
        connect_to_session(choice)
        vim.notify("Connected to session: " .. choice)
        M.update_sessions()
      end
    end)
  end
end

---Stop a session's server and clean up its files.
---@param session_name string Session name to be removed
---@return boolean success true if the session was found and asked to quit
local function kill_session(session_name)
  if not session_exists(session_name) then
    vim.notify("Socket not found: " .. socket_address(session_name), vim.log.levels.WARN)
    return false
  end

  -- Ask the remote nvim instance to quit over RPC (works with pipes and unix sockets,
  -- no shell quoting involved)
  local ok, chan = pcall(vim.fn.sockconnect, "pipe", socket_address(session_name), { rpc = true })
  if ok and type(chan) == "number" and chan > 0 then
    pcall(vim.rpcnotify, chan, "nvim_command", "qa!")
  end

  -- Wait for the server to go away
  vim.wait(1000, function()
    return not session_exists(session_name)
  end, 20)

  if ok and type(chan) == "number" and chan > 0 then
    pcall(vim.fn.chanclose, chan)
  end

  -- Remove leftover socket (Linux) or marker file (Windows)
  vim.fn.delete(marker_path(session_name))

  -- Update the saved order
  for i, name in ipairs(M.session_order) do
    if name == session_name then
      table.remove(M.session_order, i)
      break
    end
  end
  save_session_order()

  return true
end

--- Kill all orphaned nvim processes started with --embed and clean up stale session files
function M.cleanup_sessions()
  local self_pid = vim.fn.getpid()
  local procs
  if is_windows then
    procs = vim.fn.systemlist({
      "powershell",
      "-NoProfile",
      "-NonInteractive",
      "-Command",
      "Get-CimInstance Win32_Process | Where-Object { $_.Name -eq 'nvim.exe' } | ForEach-Object { '{0} {1}' -f $_.ProcessId, $_.CommandLine }",
    })
  else
    procs = vim.fn.systemlist("pgrep -a nvim")
  end

  local killed = 0
  for _, line in ipairs(procs) do
    local pid, args = line:match("(%d+)%s+(.+)")
    pid = tonumber(pid)
    -- Kill --embed processes (these are orphaned UI clients), but never ourselves
    if pid and pid ~= self_pid and args and args:find("--embed", 1, true) then
      if pcall(vim.uv.kill, pid, "sigterm") then
        killed = killed + 1
      end
    end
  end

  -- Also clean up stale session files with no running server
  local files = vim.fn.globpath(sessions_dir, "*", false, true)
  for _, path in ipairs(files) do
    local name = vim.fn.fnamemodify(path, ":t")
    if not is_reserved(name) then
      local stale
      if is_windows then
        stale = not is_alive(socket_address(name))
      else
        stale = vim.fn.getftype(path) ~= "socket"
      end
      if stale then
        vim.fn.delete(path)
      end
    end
  end

  vim.notify(string.format("Cleaned up %d orphaned processes", killed), vim.log.levels.INFO)
end

--- Remove a session by ID, name, or path.
--- If no arguments are provided, a popup will appear to select the session to delete.
---@param id? number  # Optional session index
---@param name? string  # Optional session name
---@return nil
function M.remove_session(id, name)
  M.update_sessions()
  if #M.sessions == 0 then
    vim.notify("No sessions to remove", vim.log.levels.WARN)
    return
  end

  -- If ID or name is provided, try to find and remove the specific session
  if id or name then
    local target_session

    if id then
      -- Find session by index (ID)
      if id >= 1 and id <= #M.sessions then
        target_session = M.sessions[id]
      else
        vim.notify("Invalid session ID: " .. id, vim.log.levels.ERROR)
        return
      end
    elseif name then
      -- Find session by name
      for _, session in ipairs(M.sessions) do
        if session == name then
          target_session = session
          break
        end
      end
      if not target_session then
        vim.notify("Session not found: " .. name, vim.log.levels.ERROR)
        return
      end
    end

    kill_session(target_session)
  else
    -- No arguments provided, show selection popup
    vim.ui.select(M.sessions, { prompt = "Select a session to remove:" }, function(choice)
      if choice and kill_session(choice) then
        vim.notify("Session removed: " .. choice)
        M.update_sessions()
      end
    end)
  end
end

--- Reorders the session list by moving a session up or down.
---
--- If `up` is true, the session will move one position up.
--- Otherwise, it will move one position down.
--- The custom order (`M.session_order`) is updated after the move.
---
---@param line integer The index (1-based) of the session to move.
---@param up boolean If true, move the session up; if false or nil, move it down.
---@return boolean success True if the session was successfully moved, false otherwise.
local function move_session(line, up)
  if line < #M.sessions and not up then
    -- Move a sessão na lista
    local temp = M.sessions[line]
    M.sessions[line] = M.sessions[line + 1]
    M.sessions[line + 1] = temp

    -- Atualiza a ordem personalizada
    M.session_order = vim.deepcopy(M.sessions)
    save_session_order()

    return true
  end

  if line > 1 and up then
    -- Move a sessão na lista
    local temp = M.sessions[line]
    M.sessions[line] = M.sessions[line - 1]
    M.sessions[line - 1] = temp

    -- Atualiza a ordem personalizada
    M.session_order = vim.deepcopy(M.sessions)
    save_session_order()

    return true
  end

  return false
end

-- TASK(20260109-172456): Make `manage_sessions` use a real buffer
--- List all available sessions in an interactive buffer
---@param opts? table config
function M.manage_sessions(opts)
  opts = opts or {}
  local width_ratio = opts.width or config.ui.win.width
  local height_ratio = opts.height or config.ui.win.height

  M.update_sessions()
  if #M.sessions == 0 then
    vim.notify("No active sessions", vim.log.levels.INFO)
    return
  end

  local width = math.floor(vim.o.columns * width_ratio)
  local height = math.floor(vim.o.lines * height_ratio)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    title = " Sessionizer ",
    border = "rounded",
  })
  vim.wo[win].winbar = build_winbar()
  vim.wo[win].number = true
  vim.wo[win].cursorline = true

  -- define o ícone usado na signcolumn
  vim.fn.sign_define(
    "SessionMark",
    { text = config.ui.current.mark, texthl = config.ui.current.hl, linehl = "", numhl = "" }
  )

  local function render_sessions()
    local formatted = {}
    for _, name in ipairs(M.sessions) do
      table.insert(formatted, string.format("%s", name))
    end

    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted)
    vim.bo[buf].modifiable = false

    -- limpa signs antigos antes de aplicar de novo
    vim.fn.sign_unplace("session_marks", { buffer = buf })

    -- Atualiza o current_index para refletir a nova posição da sessão atual
    if M.current_index then
      local current_session = M.get_current_session()
      for i, name in ipairs(M.sessions) do
        if name == current_session then
          M.current_index = i
          break
        end
      end
    end

    -- aplica mark na linha atual
    if M.current_index and M.sessions[M.current_index] then
      vim.fn.sign_place(
        0, -- id (0 = auto)
        "session_marks", -- group
        "SessionMark", -- nome do sign definido
        buf, -- buffer alvo
        { lnum = M.current_index, priority = 10 }
      )
    end
  end

  render_sessions()

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false

  -- Key mappings for session management in the session picker buffer
  -- All mappings use the configured keybinds and are buffer-local with nowait

  -- Default: <CR> - Attach to the selected session
  vim.keymap.set("n", config.ui.keymap.attach, function()
    local line = vim.fn.line(".")
    local session = M.sessions[line]
    if session then
      vim.api.nvim_win_close(win, true)
      M.attach_session(line)
    end
  end, { buffer = buf, nowait = true })

  -- Default: Shift+D - Delete the selected session
  vim.keymap.set("n", config.ui.keymap.delete, function()
    local line = vim.fn.line(".")
    local session = M.sessions[line]
    if session then
      M.remove_session(line) -- blocks until the server has exited
      M.update_sessions()
      if #M.sessions == 0 then
        vim.api.nvim_win_close(win, true)
        return
      end
      render_sessions()
    end
  end, { buffer = buf, nowait = true })

  -- Default: Shift+K - Move session up in the list
  vim.keymap.set("n", config.ui.keymap.move_up, function()
    local line = vim.fn.line(".")
    if move_session(line, true) then
      vim.api.nvim_win_set_cursor(win, { line - 1, 0 })
    end
    render_sessions()
  end, { buffer = buf, nowait = true })

  -- Default: Shift+J - Move session down in the list
  vim.keymap.set("n", config.ui.keymap.move_down, function()
    local line = vim.fn.line(".")
    if move_session(line, false) then
      vim.api.nvim_win_set_cursor(win, { line + 1, 0 })
    end
    render_sessions()
  end, { buffer = buf, nowait = true })

  -- Default: q - Close the session management window
  vim.keymap.set("n", config.ui.keymap.quit, function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })
end

--- Create a new session or attach to an existing one by selecting a project path
--- Uses vim.ui.select() to choose from available projects
---@return nil
function M.sessionizer()
  select_project(function(path)
    create_session(path)
  end)
end

return M
