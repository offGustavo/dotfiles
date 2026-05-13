local command = vim.api.nvim_create_user_command

-- Better Cd with Zoxide (window)
command("Z", function(opts)
  require("fish.zoxide").zoxide_commmand(opts.args, "cd")
end, {
  nargs = "?",
  complete = function(_, cmd_line)
    return require("fish.zoxide").zoxide_complete(cmd_line)
  end,
})

-- Better Cd with Zoxide (tab)
command("Zt", function(opts)
  require("fish.zoxide").zoxide_commmand(opts.args, "tcd")
end, {
  nargs = "?",
  complete = function(_, cmd_line)
    return require("fish.zoxide").zoxide_complete(cmd_line)
  end,
})

vim.api.nvim_create_user_command("AlignRegexp", function ()
  require('fish.align').align_regexp(opts)
end, { range = true })
