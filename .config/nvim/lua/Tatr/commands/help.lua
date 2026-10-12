local M = {}

---Print Help
---@param commands? table
function M.print_help(commands)
  local t = commands or M.commands
  for _, v in pairs(t) do
    local name, desc = v.name, v.desc or ""
    local msg = "- " .. name .. " " .. desc
    vim.notify(msg, vim.log.levels.INFO)
  end
end

return M
