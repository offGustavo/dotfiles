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

Fish.keymaps = {}

function _G.map(keys)
  vim.list_extend(Fish.keymaps, keys)
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.schedule(function()
      require("fish.set_keymap").set(Fish.keymaps)
    end)
  end,
})
