local PATH_CACHE = vim.fn.stdpath("cache")
local PATH_SELECTED_FILES = PATH_CACHE .. "/forge_yazi_selected_files"

local M = {}

---Configurable user options.
---@class Options
---@field enable_cmds boolean            Create :Yazi commands
---@field replace_netrw boolean          Replace netrw with yazi on directory open
---@field keybindings table<string, string> Terminal mode keymaps
---@field ui UI                          Window appearance

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

---@enum OPEN_MODE
M.OPEN_MODE = {
  vsplit = "vsplit",
  split = "split",
  tabedit = "tabedit",
}

---@type Options
local opts = {
  enable_cmds = true,
  replace_netrw = true,
  ui = {
    border = "none",
    height = 1,
    width = 1,
    x = 0.5,
    y = 0.5,
  },
  keybindings = {},
}

---Get the function which will be used to open files based on the given mode
---@param open_mode OPEN_MODE|nil
---@return function
local function get_edit_fn(open_mode)
  if open_mode == nil or M.OPEN_MODE[open_mode] == nil then
    return vim.cmd.edit
  end

  local alternative_open_funcs = {
    vsplit = vim.cmd.vsplit,
    split = vim.cmd.split,
    tabedit = vim.cmd.tabedit,
  }

  return alternative_open_funcs[open_mode]
end

---Handles opening of the selected path(s)
---@param open_mode OPEN_MODE|nil
local function open_paths(open_mode)
  if vim.fn.filereadable(PATH_SELECTED_FILES) ~= 1 then
    return
  end

  local selected_files = vim.fn.readfile(PATH_SELECTED_FILES)
  local edit = get_edit_fn(open_mode)
  local directories = {}

  for _, path in ipairs(selected_files) do
    if vim.fn.isdirectory(path) == 1 then
      table.insert(directories, path)
    else
      edit(path)
    end
  end

  -- Reopen yazi in the first selected directory, ignore the rest
  local _, first_dir = next(directories)
  if first_dir ~= nil then
    M.open(first_dir, open_mode)
  end
end

---Builds the yazi launch command
---@param path_to_open string|nil Path to focus (file or directory)
---@return string
local function build_yazi_cmd(path_to_open)
  local args = { "yazi" }

  -- Chooser file output
  table.insert(args, "--chooser-file")
  table.insert(args, PATH_SELECTED_FILES)

  -- Focus file/directory if provided
  if path_to_open and path_to_open ~= "" then
    -- Quote to handle spaces
    table.insert(args, vim.fn.shellescape(path_to_open))
  end

  return table.concat(args, " ")
end

---Returns window dimensions based on ui options
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

---Open a floating window for yazi
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
  vim.api.nvim_set_option_value("filetype", "yazi", { buf = buf })

  -- Resize window on VimResized
  local group = vim.api.nvim_create_augroup("yazi_window", { clear = true })
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
end

---Returns a table of buffer names pointing to existing files
---@return table<string>
local function get_buffers_for_existing_files()
  local buffer_names = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1 then
      local buf_name = vim.fn.bufname(buf)
      if vim.fn.filereadable(buf_name) == 1 then
        table.insert(buffer_names, buf_name)
      end
    end
  end

  return buffer_names
end

---Closes buffers whose files no longer exist
---@param buffers table<string>
local function close_empty_buffers(buffers)
  for _, buf in ipairs(buffers) do
    if vim.fn.filereadable(buf) ~= 1 then
      vim.cmd.bdelete(buf)
    end
  end
end

---Clean up temporary files
local function clean_up()
  vim.fn.delete(PATH_SELECTED_FILES)
end

---Disable netrw and replace with yazi on directory open
local function replace_netrw()
  -- Disable netrw
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1
  pcall(vim.api.nvim_clear_autocmds, { group = "FileExplorer" })

  -- Replace on VimEnter if a directory is passed
  vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
      local path = vim.fn.argv(0)
      if vim.fn.isdirectory(path) == 1 then
        vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), { force = true })
        M.open(path)
      end

      -- Replace for any directory buffer opened later (e.g., :e dir/)
      vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
        callback = function()
          local current_bufnr = vim.api.nvim_get_current_buf()
          local buf_name = vim.api.nvim_buf_get_name(current_bufnr)

          if vim.fn.isdirectory(buf_name) == 1 then
            pcall(vim.api.nvim_buf_delete, current_bufnr, { force = true })
            M.open(buf_name)
          end
        end,
      })
    end,
  })
end

---Opens yazi in a floating window and handles selected files on exit
---@param path_to_open string|nil Path to focus (default: current file or cwd)
---@param open_mode OPEN_MODE|nil How to open selected files
function M.open(path_to_open, open_mode)
  -- Check if yazi is installed
  assert(vim.fn.executable("yazi") == 1,
    "yazi executable not found. Please ensure yazi is installed and in your PATH.")

  clean_up()

  -- Store existing buffers before running yazi
  local buffers_for_existing_files = get_buffers_for_existing_files()

  local cmd = build_yazi_cmd(path_to_open)
  local last_win = vim.api.nvim_get_current_win()

  open_win()

  local on_exit = function(_, code, _)
    if code ~= 0 then
      return
    end

    -- Allow buffer-local override of open mode
    open_mode = vim.b.yazi_next_open_mode or open_mode

    vim.api.nvim_win_close(0, true)
    vim.api.nvim_set_current_win(last_win)

    open_paths(open_mode)

    clean_up()
    close_empty_buffers(buffers_for_existing_files)
  end

  if vim.fn.has("nvim-0.9") then
    vim.fn.termopen(cmd, { on_exit = on_exit })
  else
    vim.fn.jobstart(cmd, { term = true, on_exit = on_exit })
  end

  vim.cmd.startinsert()
end

---Set the next open mode for selected files (buffer-local)
---@param open_mode OPEN_MODE|nil
function M.set_next_open_mode(open_mode)
  vim.b.yazi_next_open_mode = open_mode
end

---Setup function
---@param user_opts Options|nil
function M.setup(user_opts)
  if user_opts then
    opts = vim.tbl_deep_extend("force", opts, user_opts)
  end

  if opts.replace_netrw then
    replace_netrw()
  end

  if opts.enable_cmds then
    vim.cmd('command! Yazi lua require("forge.yazi").open()')
    vim.keymap.set("n", "<M-S-y>", ":Yazi<CR>")
    -- vim.keymap.set("n", "-", function()
    --     require("forge.yazi").open(vim.fn.expand("%:h"), nil)
    -- end, { desc = "Open Yazi File Manager" })
    vim.cmd(string.format('command! Sex lua require("forge.yazi").open(nil, "%s")', M.OPEN_MODE.split))
    vim.cmd(string.format('command! Vex lua require("forge.yazi").open(nil, "%s")', M.OPEN_MODE.vsplit))
    vim.cmd(string.format('command! Tex lua require("forge.yazi").open(nil, "%s")', M.OPEN_MODE.tabedit))
  end
end

return M
