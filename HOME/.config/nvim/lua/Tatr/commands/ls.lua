local M = {}

M.subcommands = {
  {
    name = "help",
    fun = require("Tatr.help").print_help(M.subcommands)
  },
}

function M.init() end

return M
