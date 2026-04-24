vim.schedule(function()
  vim.cmd.packadd("vim-startuptime")
	vim.g.startuptime_tries = 10
end)
