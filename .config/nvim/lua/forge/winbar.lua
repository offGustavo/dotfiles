-- TODO: add winbar when multiple wndows are open...
-- -- Custom winbar that shows filename, modified status, position, and diagnostics
-- Only appears when the current tabpage has more than 1 window

local function get_diagnostic_counts()
  local counts = vim.diagnostic.count(0)
  local errors = counts.error or 0
  local warnings = counts.warning or 0
  if errors + warnings == 0 then
    return ""
  end
  return string.format("  %d  %d", errors, warnings)
end

local function get_position()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local total = vim.api.nvim_buf_line_count(0)
  return string.format("%d:%d", line, total)
end

local function get_filename()
  local name = vim.fn.expand("%:t")
  if name == "" then
    name = "[No Name]"
  end
  local modified = vim.bo.modified and "[+]" or ""
  return name .. modified
end

local function build_winbar()
  -- Only show winbar if current tab has more than 1 window
  local wins = vim.api.nvim_tabpage_list_wins(0)
  if #wins <= 1 then
    return ""
  end

  local filename = get_filename()
  local position = get_position()
  local diagnostics = get_diagnostic_counts()

  return string.format("%s  %%#WinBar#│%%#WinBar#  %s  %%#WinBar#│%%#WinBar#  %s", filename, position, diagnostics)
end

local function update_current_winbar()
  local winbar = build_winbar()
  vim.wo.winbar = winbar
end

local function update_all_winbars_in_tab()
  local tab = vim.api.nvim_get_current_tabpage()
  local wins = vim.api.nvim_tabpage_list_wins(tab)
  for _, win in ipairs(wins) do
    local winbar = (function()
      -- Temporarily switch context to compute winbar for that window
      local cur_win = vim.api.nvim_get_current_win()
      vim.api.nvim_set_current_win(win)
      local result = build_winbar()
      vim.api.nvim_set_current_win(cur_win)
      return result
    end)()
    vim.api.nvim_set_option_value("winbar", winbar, { scope = "local", win = win })
  end
end

-- Autocommand group
local group = vim.api.nvim_create_augroup("CustomWinbar", { clear = true })

-- Update current window on events that change content
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter", "BufWritePost", "DiagnosticChanged" }, {
  group = group,
  callback = update_current_winbar,
})

-- Update all windows when tab layout changes (affects visibility condition)
vim.api.nvim_create_autocmd({ "TabEnter", "WinNew", "WinClosed" }, {
  group = group,
  callback = update_all_winbars_in_tab,
})

-- Initial setup for current windows
update_current_winbar()
