local M = {}

-- TODO: Add a lua doc
---@class CommandScheme
---@field name string
---@field desc? string
---@field fun function

---@class Command
---@field table CommandScheme

M.commands = {
  {
    name = "help",
    fun = require("Tatr.help").print_help(M.commands),
  },
  {
    name = "ls",
    desc = "List all tasks",
    fun = function()
      require("Tatr.ls").init()
      vim.print "Tatr ls"
    end,
  },
  {
    name = "ref",
    fun = function()
      vim.print("TODO: ref")
    end,
  },
}

--- Print Help
function M.help()
  M.commands[1].fun()
end

-- Return the name of all commands
function M.complete()
  local t = {}
  for _, v in ipairs(M.commands) do
    table.insert(t, v.name)
  end
  return t
end

return M
