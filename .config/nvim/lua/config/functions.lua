---Check whether Neovim is running on Windows.
---@return boolean
function Fish.is_windows()
  return vim.fn.has("win32") == 1
end

local fish_group = vim.api.nvim_create_augroup("Fish.config", {})

---comment
---@param event string|table
---@param callback? function
---@param pattern? string|table
---@param group? any
---@param desc? string
function _G.autocmd(event, callback, pattern, group, desc)
  vim.api.nvim_create_autocmd(event, {
    group = group or fish_group,
    desc = desc or nil,
    pattern = pattern or nil,
    callback = callback or nil,
  })
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

function _G.later(fn)
  -- TODO: i should use async here?
  vim.async.run(fn)
end

---@param package string
function _G.packadd(package)
  vim.cmd.packadd(package)
end

autocmd("VimEnter", function()
  later(function()
    require("fish.set_keymap").set(Fish.keymaps)
  end)
end)
