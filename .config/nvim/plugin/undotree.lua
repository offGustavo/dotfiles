vim.schedule(function()
	vim.cmd("packadd nvim.undotree")
	vim.keymap.set("n", "U", require("undotree").open)
end)
