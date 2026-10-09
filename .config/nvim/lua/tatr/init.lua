vim.api.nvim_create_user_command("Tatr", function(opts)
  local commands = require("tatr.commands").commands
  for _, v in pairs(commands) do
    if opts.fargs[1] == v.name then
      v.fun(opts)
      return
    end
  end

  vim.notify(
    [[
  -- Not a Tatr Command.
  Run :Tatr help to see all commands or :h tatr-commands
  ]],
    vim.log.levels.WARN
  )

  -- Run help
  commands[1].fun()
end, {
  nargs = "*",
  complete = function()
    return require("tatr.commands").complete()
  end,
})
