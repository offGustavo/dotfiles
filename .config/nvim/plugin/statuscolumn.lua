-- Fold settings
vim.o.foldtext = ""
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99

-- -- Status column settings
vim.o.foldcolumn = "1"
vim.o.signcolumn = "yes:1"

vim.opt.fillchars:append({
	fold = " ",
	foldopen = "",
	foldclose = "",
	foldsep = " ",
	foldinner = " ",
})

-- vim.o.statuscolumn = "%s%l %C "

vim.o.statuscolumn = "%!v:lua.require('fish.statuscolumn').build()"
