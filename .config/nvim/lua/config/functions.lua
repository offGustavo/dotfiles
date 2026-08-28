---Check whether Neovim is running on Windows.
---@return boolean
function Fish.is_windows()
  return vim.fn.has("win32") == 1
end

---Set Neovim options in bulk.
---Scalar values (boolean/number/string) are applied via `vim.o`.
---Table values (lists/maps, e.g. `listchars`, `shortmess`) are applied via `vim.opt`,
---which performs the correct comma-list/flag/map conversion.
---@param opts table<string, boolean|number|string|table> Map of option name -> value
---@usage
--- set {
---   number = true,
---   relativenumber = true,
---   wrap = false,
---   listchars = { tab = "» ", trail = "·" }, -- routed to vim.opt
--- }
function _G.set(opts)
  for name, value in pairs(opts) do
    if type(value) == "table" then
      vim.opt[name] = value
    else
      vim.o[name] = value
    end
  end
end

---@class KeymapSpec
---@field [1] string|string[]|nil mode or lhs (see mode-detection rules)
---@field [2] string
---@field [3]? string
---@field mode? string|string[]
---@field buf? integer buffer number, or 0 for current buffer
---@field noremap? boolean
---@field remap? boolean inverse of noremap; ignored if `noremap` is set explicitly
---@field silent? boolean
---@field opts? table extra vim.keymap.set opts (desc, expr, nowait, etc.)

local VALID_MODES = {
  n = true, v = true, x = true, s = true, o = true,
  i = true, l = true, c = true, t = true, [""] = true,
}

---@param v any
---@return boolean
local function is_mode(v)
  if type(v) == "table" then
    for _, mm in ipairs(v) do
      if not VALID_MODES[mm] then
        return false
      end
    end
    return true
  elseif type(v) == "string" then
    return VALID_MODES[v] == true
  end
  return false
end

---Set multiple keymaps in bulk, lazy.nvim `keys`-spec style.
---@param maps KeymapSpec[] List of keymap specs
---@usage
--- map {
---   { "n", "<C-Down>", "}", noremap = true, silent = true },
---   { "i", "<M-S-.>", "<C-o>G", noremap = true, silent = true },
---   { { "n", "x" }, "<M-x>", ":" },
---   { "<M-i><M-t>", "- [ ] ", buf = 0 },
--- }
function _G.map(maps)
  for _, m in ipairs(maps) do
    local mode, lhs, rhs

    if m.mode ~= nil then
      mode = m.mode
      lhs, rhs = m[1], m[2]
    elseif is_mode(m[1]) then
      mode = m[1]
      lhs, rhs = m[2], m[3]
    else
      mode = "n"
      lhs, rhs = m[1], m[2]
    end

    -- defaults, then any extra opts table, then flat fields on top
    local opts = vim.tbl_extend("force", { noremap = true, silent = true }, m.opts or {})

    if m.noremap ~= nil then
      opts.noremap = m.noremap
    elseif m.remap ~= nil then
      opts.noremap = not m.remap
    end

    if m.silent ~= nil then
      opts.silent = m.silent
    end

    if m.buf ~= nil then
      opts.buffer = m.buf
    end

    vim.keymap.set(mode, lhs, rhs, opts)
  end
end
