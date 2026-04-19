local render_with_mode_color = require("extern.mode_colors").render_with_mode_color
local render_with_mode_color_inverted = require("extern.mode_colors").render_with_mode_color_inverted

-- Helper function to get tab label
local function get_tab_label(tabnr)
  local tabinfo = vim.fn.gettabinfo(tabnr)[1]
  local windows = tabinfo.windows
  local window_count = #windows

  -- Get the current window in this tab
  local cur_win = vim.fn.tabpagewinnr(tabnr)
  local buf = vim.fn.tabpagebuflist(tabnr)[cur_win]
  local bufname = vim.fn.bufname(buf)
  local filename = vim.fn.fnamemodify(bufname, ":t")

  if filename == "" then
    filename = "[No Name]"
  end

  -- Get cwd for the tab
  local tab_cwd = vim.fn.gettabvar(tabnr, "cwd")
  if not tab_cwd or tab_cwd == "" then
    tab_cwd = vim.fn.getcwd(tabnr)
  end
  local cwd_short = vim.fn.fnamemodify(tab_cwd, ":t")
  if cwd_short == "" then
    cwd_short = "~"
  end

  -- Build the label: index | cwd | filename [+windows]
  -- local label = string.format("%d | %s | %s", tabnr, cwd_short, filename)
  -- local label = string.format("%d [%s] %s", tabnr, cwd_short, filename)
  local label = string.format("%d [%s]", tabnr, cwd_short)

  -- -- Add window count only if more than 1
  -- if window_count > 1 then
  --   label = label .. string.format(" +%d", window_count)
  -- end

  return label
end

-- Function to generate the entire tabline
function Fish.build_tabline()
  local tabs = vim.fn.tabpagenr('$')
  local current_tab = vim.fn.tabpagenr()
  local items = {}

  for i = 1, tabs do
    local label = get_tab_label(i)
    local item

    -- Highlight based on whether it's the current tab
    if i == current_tab then
      item = string.format("%%#TabLineSel#%%%dT%s%%T", i, label)
    else
      item = string.format("%%#TabLine#%%%dT%s%%T", i, label)
    end

    table.insert(items, item)
  end

  -- Join all tabs with spaces
  local tabline = table.concat(items, " ")

  -- Add TabLineFill after tabs
  tabline = tabline .. "%#TabLineFill#%T"

  -- Add right-aligned close button if more than 1 tab
  if tabs > 1 then
    tabline = tabline .. "%=%#TabLine#%999X✗"
  end

  return tabline
end

-- Set the tabline option
vim.o.tabline = "%!v:lua.Fish.build_tabline()"
