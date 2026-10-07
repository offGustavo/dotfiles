---@alias OptScope "both"|"local"|"global"

---Option object returned by `vim.opt[name]`, `vim.opt_local[name]` or
---`vim.opt_global[name]`.
---@class OptObject
---@field append  fun(self: OptObject, value: string|string[]|table)
---@field prepend fun(self: OptObject, value: string|string[]|table)
---@field remove  fun(self: OptObject, value: string|string[]|table)
---@field get     fun(self: OptObject): any

---Operation table applied to an existing list/set option, in the order
---`prepend`, `append`, `remove`.
---@class OptOps
---@field prepend? string|string[]
---@field append?  string|string[]
---@field remove?  string|string[]

---Value accepted for an option:
---  - `boolean|number|string`: assigned directly
---  - `table`: full replacement of a list/map/set
---  - `OptOps`: prepend/append/remove on the current value
---  - `function`: called with the scoped option object
---@alias OptValue boolean|number|string|table|OptOps|fun(opt: OptObject)

local M = {}

---@type table<OptScope, table>
local scopes = {
  both     = vim.opt,        -- :set
  ["local"] = vim.opt_local,  -- :setlocal
  global   = vim.opt_global, -- :setglobal
}

---Set Neovim options in bulk.
---
---Each value is handled according to its type:
---  - boolean/number/string             -> assigned directly
---  - function(opt)                     -> called with the scoped option object
---  - { prepend, append, remove } table -> applied in that order
---  - any other table                   -> full replacement of list/map/set
---
---An operation table is any table with a key named `append`, `prepend` or
---`remove`; each key accepts a string or a list. For map options that use such
---keys, use the function form instead.
---
---Keep all operations for one option in a single key, because `pairs` does not
---guarantee iteration order.
---@param opts table<string, OptValue> Map of option name -> value
---@param scope? OptScope Defaults to `"both"` (`:set`)
---@usage lua
--- local set = require("Fish.set").set
--- set {
---   number     = true,
---   listchars  = { tab = "» ", trail = "·" },                    -- replace
---   wildignore = { append = { "*.o", "*.obj" }, remove = "*.tmp" },
---   path       = { prepend = "src/**" },
---   shortmess  = function(o) o:remove("I") end,                  -- function form
--- }
--- set({ wrap = false }, "local")
function M.set(opts, scope)
  scope = scope or "both"
  local target = scopes[scope]
  assert(target, ("set: invalid scope %q (expected both|local|global)"):format(tostring(scope)))

  for option, value in pairs(opts) do
    local t = type(value)
    if t == "function" then
      value(target[option])
    elseif t == "table" and (value.append or value.prepend or value.remove) then
      local o = target[option]
      if value.prepend then o:prepend(value.prepend) end
      if value.append  then o:append(value.append)   end
      if value.remove  then o:remove(value.remove)   end
    else
      target[option] = value -- scalars and replacement tables
    end
  end
end

return M
