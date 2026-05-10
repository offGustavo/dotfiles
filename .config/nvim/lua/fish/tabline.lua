local render_with_mode_color = require("fish.mode_colors").render_with_mode_color
local render_with_mode_color_inverted = require("fish.mode_colors").render_with_mode_color_inverted
local mode_name = require("fish.mode_colors").mode_name

local ignore_names = {
  "[Pager]",
  "[Msg]",
  "[Dialog]",
  "[Cmd]",
}

local M = {}

vim.api.nvim_create_autocmd("DirChanged", {
  pattern = "tabpage",
  callback = function()
    vim.fn.settabvar(vim.fn.tabpagenr(), "cwd", vim.fn.getcwd())
  end,
})

vim.api.nvim_create_autocmd({ "ModeChanged", "BufEnter", "TabEnter", "DirChanged" }, {
  group = vim.api.nvim_create_augroup("tabline_redraw", { clear = true }),
  callback = function()
    vim.cmd.redrawtabline()
  end,
})

---@param tabnr integer
---@return string
local function get_tab_cwd(tabnr)
  local tab_cwd = vim.fn.gettabvar(tabnr, "cwd", "")
  if tab_cwd == "" then
    tab_cwd = vim.fn.getcwd(-1, tabnr)
  end
  local cwd_short = vim.fn.fnamemodify(tab_cwd, ":~:t")
  if cwd_short == "" then
    cwd_short = "~"
  end
  return cwd_short
end

---Get unique name for a buffer by adding parent directories recursively until unique
---@param buf integer
---@param all_names table<string, table> Map of base names to list of (bufnr, full_path)
---@return string
local function get_unique_name(buf, all_names)
  local full_path = vim.fn.expand("#" .. buf .. ":p")
  local base_name = vim.fn.fnamemodify(full_path, ":t")
  if base_name == "" then
    base_name = "[No Name]"
  end

  -- Check if this base_name exists in all_names
  local group = all_names[base_name]
  if not group then
    return base_name
  end

  -- If no other buffer has this base name, return just the base name
  if #group == 1 then
    return base_name
  end

  -- Otherwise, recursively add parent directories until unique
  local current_path = full_path
  local parts = {}

  while true do
    -- Add the current last part (directory or filename)
    local current_name = vim.fn.fnamemodify(current_path, ":t")
    if current_name == "" then
      -- Reached root, show full path as fallback
      return full_path
    end
    table.insert(parts, 1, current_name)

    -- Move up one directory
    current_path = vim.fn.fnamemodify(current_path, ":h")

    -- Build the candidate name with parent directories
    local candidate = table.concat(parts, "/")

    -- Check if this candidate is unique among buffers with same base name
    local is_unique = true
    for _, item in ipairs(group) do
      if item.bufnr ~= buf then
        local other_full_path = vim.fn.expand("#" .. item.bufnr .. ":p")

        -- Extract the same number of path components from the other buffer
        local other_parts = {}
        local other_path = other_full_path
        for _ = 1, #parts do
          local part = vim.fn.fnamemodify(other_path, ":t")
          if part == "" then
            is_unique = false
            break
          end
          table.insert(other_parts, 1, part)
          other_path = vim.fn.fnamemodify(other_path, ":h")
        end

        if is_unique then
          local other_candidate = table.concat(other_parts, "/")
          if candidate == other_candidate then
            is_unique = false
            break
          end
        end
      end
    end

    if is_unique then
      -- Format with angle brackets for parent directory info
      if #parts == 1 then
        return base_name
      else
        local parent_path = table.concat(parts, "/", 1, #parts - 1)
        return string.format("%s<%s>", parts[#parts], parent_path)
      end
    end

    -- Stop if we've reached root directory
    if current_path == "" or current_path == "/" or current_path == vim.fn.fnamemodify(current_path, ":h") then
      -- If still not unique, show full path as fallback
      return full_path
    end
  end
end

---@param tabnr integer
---@return string[]
local function get_window_names(tabnr)
  local buflist = vim.fn.tabpagebuflist(tabnr)

  local function is_ignored(name)
    for _, ignore in ipairs(ignore_names) do
      if name:find(ignore, 1, true) then
        return true
      end
    end
    return false
  end

  -- First, group buffers by their base name
  local name_groups = {}
  for _, buf in ipairs(buflist) do
    local full_path = vim.fn.expand("#" .. buf .. ":p")
    local base_name = vim.fn.fnamemodify(full_path, ":t")
    if base_name == "" then
      base_name = "[No Name]"
    end

    if is_ignored(base_name) then
      goto continue
    end

    if not name_groups[base_name] then
      name_groups[base_name] = {}
    end
    table.insert(name_groups[base_name], { bufnr = buf, full_path = full_path })

    ::continue::
  end

  -- Then generate unique names for each buffer
  local names = {}

  for _, buf in ipairs(buflist) do
    local full_path = vim.fn.expand("#" .. buf .. ":p")
    local base_name = vim.fn.fnamemodify(full_path, ":t")
    if base_name == "" then
      base_name = "[No Name]"
    end

    if is_ignored(base_name) then
      goto continue
    end

    local display_name
    if name_groups[base_name] and #name_groups[base_name] > 1 then
      display_name = get_unique_name(buf, name_groups)
    else
      display_name = base_name
    end

    table.insert(names, display_name)

    ::continue::
  end

  return names
end

function M.build_tabline()
  local tabs = vim.fn.tabpagenr("$")
  local current_tab = vim.fn.tabpagenr()
  local items = {}

  table.insert(items, string.format("%s %s ", render_with_mode_color(""), "%#Normal#"))

  for i = 1, tabs do
    local cwd = get_tab_cwd(i)
    local item

    if i == current_tab then
      item = string.format("%s%%%dT %d:%s%%T %s", render_with_mode_color(""), i, i, cwd, "%#Normal#")
    else
      item = string.format("%%#Normal#%%%dT %d:%s %%T", i, i, cwd)
    end

    table.insert(items, item)
  end

  table.insert(items, "%=")

  -- Window names for the current tab, shown after all tabs
  local win_names = get_window_names(current_tab)
  if #win_names > 0 then
    table.insert(items, "%#Normal#  ")
    for i, name in ipairs(win_names) do
      table.insert(items, string.format("%%#Comment#%d:%s%%#Normal# ", i, name))
    end
  end

  local tabline = table.concat(items, "")
  tabline = tabline .. "%#Normal#%T"

  if tabs > 1 then
    tabline = tabline .. string.format("%s %%999X✗ %s", render_with_mode_color(""), "%#Normal#")
  end

  return tabline
end

return M
