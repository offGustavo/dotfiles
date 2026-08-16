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
---@field [1] string LHS (key sequence to map)
---@field [2] string|function RHS (command string or Lua function)
---@field mode? string|string[] Mode(s) to apply the mapping in (default: "n")
---@field opts? vim.keymap.set.Opts Options passed to `vim.keymap.set` (default: `{ noremap = true, silent = true }`)

---Set multiple keymaps in bulk, lazy.nvim `keys`-spec style.
---@param maps KeymapSpec[] List of keymap specs
---@usage
--- map {
---   { "<leader>y", '"+y', opts = { desc = "Yank to clipboard" } },
---   { "<C-h>", "<C-w>h", mode = { "n", "t" } },
--- }
function _G.map(maps)
  for _, m in ipairs(maps) do
    local mode = m.mode or "n"
    local lhs, rhs = m[1], m[2]
    local opts = m.opts or { noremap = true, silent = true }
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end
