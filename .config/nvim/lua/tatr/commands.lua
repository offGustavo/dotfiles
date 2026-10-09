local M = {}

-- TODO: Add a lua doc
---@class CommandScheme

---@class Command
---@field table CommandScheme
M.commands = {
  {
    name = "help",
    fun = function()
      for _, v in pairs(M.commands) do
        local name, desc = v.name, v.desc or ""
        vim.notify("- " .. name .. " " .. desc or "", vim.log.levels.INFO)
      end
    end,
  },
  {
    name = "ls",
    desc = "List all tasks",
    fun = function()
      require("tatr.file").ls()
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

-- Return the name of all commands
function M.complete()
  local t = {}
  for _, v in ipairs(M.commands) do
    table.insert(t, v.name)
  end
  return t
end

return M
