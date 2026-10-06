---Check whether Neovim is running on Windows.
---@return boolean
function _G.is_windows()
  return vim.fn.has("win32") == 1
end

-- Augroup
_G.fish_group = vim.api.nvim_create_augroup("Fish.config", {})

---Set Neovim options in bulk.
---  - boolean/number/string -> vim.o
---  - function(opt)         -> called with vim.opt[option]; use for append/prepend/remove
---  - { append, prepend, remove } table -> applied in order: prepend, append, remove
---  - any other table       -> vim.opt (full replacement of list/map/set)
---
---Operation tables accept a string or a list for each key. Note that a table
---with a key named `append`, `prepend` or `remove` is always treated as an
---operation table, so use the function form for options that are maps with
---such keys.
---@class OptOps
---@field prepend? string|string[]
---@field append?  string|string[]
---@field remove?  string|string[]
---
---@param opts table<string, boolean|number|string|table|OptOps|fun(opt: table)>
---@param global? nil|integer define if option should be set with set, set_local or set_global
---@usage
--- set {
---   number = true,
---   listchars  = { tab = "» ", trail = "·" },              -- replace
---   wildignore = { append = { "*.o", "*.obj" }, remove = "*.tmp" },
---   path       = { prepend = "src/**" },
---   shortmess  = function(o) o:remove("I") end,            -- function form
--- }

---Set options like `:set`.
---@param opts table<string, OptValue>
---@param scope? OptScope
---@usage
--- set {
---   number     = true,
---   listchars  = { tab = "» ", trail = "·" },
---   wildignore = { append = { "*.o", "*.obj" }, remove = "*.tmp" },
---   path       = { prepend = "src/**" },
---   shortmess  = function(o) o:remove("I") end,
--- }
--- set({ wrap = false }, "local") -- same as set_local
function _G.set(opts, scope)
  require("Fish.set").set(opts, scope)
end

---Set options like `:setlocal` (current buffer/window only).
---@param opts table<string, OptValue>
function _G.set_local(opts)
  require("Fish.set").set(opts, "local")
end

---Set options like `:setglobal` (global value only, not the current buffer/window).
---@param opts table<string, OptValue>
function _G.set_global(opts)
  require("Fish.set").set(opts, "global")
end

---comment
---@param event string|table
---@param callback? function
---@param pattern? string|table|function
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

function _G.map(maps)
  local keymap_set  = require("Fish.keymap_set")
  for idx, m in ipairs(maps) do
    if m.range then
      local first, last, step = m.range[1], m.range[2], m.range[3] or 1
      for i = first, last, step do
        keymap_set.set_one(m, i, idx)
      end
    else
      keymap_set.set_one(m, nil, idx)
    end
  end
end

function _G.later(fn)
  -- TODO: i should use async here?
  -- vim.async.run(fn)
  vim.schedule(fn)
end

-- ---@param package string|table
-- function _G.packadd(package)
--   if type(package) == "table" then
--     for _, v in pairs(package) do
--       vim.cmd.packadd(v)
--     end
--     return
--   end
--   vim.cmd.packadd(package)
-- end

---@param package string
function _G.packadd(package)
  vim.cmd.packadd(package)
end
