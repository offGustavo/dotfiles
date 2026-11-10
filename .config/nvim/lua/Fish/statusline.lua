local M = {}

local render_with_mode_color = require("Fish.mode_colors").render_with_mode_color
local render_with_mode_color_inverted = require("Fish.mode_colors").render_with_mode_color_inverted

local function get_file_name()
  local modified = vim.bo[0].modified
  local full_path = vim.fn.expand("%~:.")

  -- Special case: buffer is a directory (e.g. opened with netrw/oil.nvim)
  local buftype = vim.bo[0].buftype
  local filetype = vim.bo[0].filetype
  if
    vim.fn.isdirectory(vim.fn.expand("%:p")) == 1
    or filetype == "netrw"
    or filetype == "oil"
    or filetype == "canola"
  then
    local dir_name = vim.fn.fnamemodify(full_path, ":t")
    if dir_name == "" then
      dir_name = full_path
    end
    return "%#Directory# " .. dir_name .. " "
  end

  local file_name = vim.fn.fnamemodify(full_path, ":t")
  if file_name == "" then
    file_name = "[No Name]"
  end

  local file_path = vim.fn.fnamemodify(full_path, ":h")
  if file_path == "." then
    file_path = ""
  elseif file_path ~= "" then
    file_path = file_path .. "/"
  end

  if modified then
    return "%<" .. file_path .. "%>" .. "%#CursorLineNr#" .. file_name .. " "
  else
    return "%<" .. file_path .. "%>" .. file_name .. " "
  end
end

local function git_branch()
  local branch_name = nil
  if vim.g.fish_git_branch ~= nil then
    branch_name = vim.g.fish_git_branch
  end
  if vim.b.fish_git_branch ~= nil then
    branch_name = vim.b.fish_git_branch
  end
  if branch_name == nil then
    return ""
  end

  local branch = {}
  table.insert(branch, "<")
  table.insert(branch, branch_name)
  table.insert(branch, ">")
  table.insert(branch, " ")
  return table.concat(branch)
end

local function git_info()
  local diff_summary = vim.b.minidiff_summary_string
  if diff_summary == nil or diff_summary == "" then
    return ""
  end

  local diff_parts = vim.split(diff_summary, " ")
  local highlighted_parts = {}
  table.insert(highlighted_parts, "%#Normal#")
  for _, part in ipairs(diff_parts) do
    if part:match("^%+%d+") then
      -- Added lines: +1, +42, etc.
      table.insert(highlighted_parts, "%#StatuslineDiffAdd#")
      table.insert(highlighted_parts, part)
      table.insert(highlighted_parts, " ")
    elseif part:match("^%~%d+") then
      -- Modified lines: ~1, ~42, etc.
      table.insert(highlighted_parts, "%#StatuslineDiffChange#")
      table.insert(highlighted_parts, part)
      table.insert(highlighted_parts, " ")
    elseif part:match("^%-%d+") then
      -- Deleted lines: -1, -42, etc.
      table.insert(highlighted_parts, "%#StatuslineDiffDelete#")
      table.insert(highlighted_parts, part)
      table.insert(highlighted_parts, " ")
    end
  end
  table.insert(highlighted_parts, "%#Normal#")
  return table.concat(highlighted_parts)
end

local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()

  if recording_register == "" then
    return ""
  else
    return "%#CursorLineNr#@" .. recording_register .. "%#Normal# "
  end
end

local function lsp_diagnostics()
  if not Fish.did_lsp_setup then
    return ""
  end
  local info = vim.diagnostic.status()
  if info == "" then
    return ""
  end
  return info .. " "
end

local function lsp_info()
  if not Fish.did_lsp_setup then
    return ""
  end
  local msg = {}
  table.insert(msg, "{")
  -- local msg = "No Active Lsp"
  local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
  local clients = vim.lsp.get_clients()
  if next(clients) == nil then
    return ""
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      table.insert(msg, client.name)
    end
  end
  table.insert(msg, "}")
  return table.concat(msg)
end

local function filetype()
  local ft = vim.bo.filetype
  if ft == "" or ft == nil then
    return ""
  end
  local text = {}

  table.insert(text, "[")
  table.insert(text, ft)
  table.insert(text, "]")
  table.insert(text, " ")

  return table.concat(text)
end

local function fileformat()
  local format = vim.bo.fileformat
  if format == "" then
    return
  end
  format = format .. " "
  return format:upper()
end

function M.build_statusline()
  return render_with_mode_color(" ")
    .. render_with_mode_color_inverted("  ")
    .. "%#Normal#"
    .. get_file_name()
    .. "%#Normal#"
    .. "%l:%c %L:%p%% "
    .. lsp_diagnostics()
    .. lsp_info()
    .. "%="
    .. show_macro_recording()
    .. git_branch()
    .. git_info()
    -- .. "%S "
    -- .. "%r "
    .. filetype()
    .. fileformat()
    .. render_with_mode_color("  ")
end

function M.build_statusline_inactive()
  local active_win = vim.fn.win_getid()
  local status_win = vim.g.statusline_winid
  if status_win ~= active_win then
    return render_with_mode_color(" ")
      .. render_with_mode_color_inverted("   ")
      .. "%#StatusLineNC#"
      .. get_file_name()
      .. "%#StatusLineNC#"
      .. "%l:%c %L:%p%%"
      .. "%="
      .. render_with_mode_color("  ")
  end
end

function M.build_quickfix_statusline()
  vim.cmd([[set statusline=%t%{exists('w:quickfix_title')? ' '.w:quickfix_title : ''} %=%-15(%l,%c%V%) %P]])
end

return M
