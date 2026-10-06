local M = {}

---@alias OptScope "both"|"local"|"global"

---@class OptOps
---@field prepend? string|string[]
---@field append?  string|string[]
---@field remove?  string|string[]

---@alias OptValue boolean|number|string|table|OptOps|fun(opt: table)

---@type table<OptScope, table>
local scopes = {
  both   = vim.opt,         -- :set
  ["local"]  = vim.opt_local,   -- :setlocal
  global = vim.opt_global,  -- :setglobal
}

---Apply options in bulk using the given scope.
---
---  - boolean/number/string             -> assigned directly
---  - function(opt)                     -> called with the scoped option object
---  - { prepend, append, remove } table -> applied in that order
---  - any other table                   -> full replacement of list/map/set
---
---An operation table is any table with a key named `append`, `prepend` or
---`remove`. For map options that use such keys, use the function form.
---@param opts table<string, OptValue>
---@param scope? OptScope Defaults to "both" (`:set`)
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
