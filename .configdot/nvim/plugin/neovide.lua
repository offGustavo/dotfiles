-------------
-- NEOVIDE --
-------------
if not vim.g.neovide then
	return
end

vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 8
vim.g.neovide_padding_left = 8

local font_size = 12
local function set_font_size(amount)
	if amount == 0 then
		font_size = 12
	else
		font_size = font_size + amount
	end
	if vim.uv.os_uname().sysname == "Windows_NT" then
		vim.o.guifont = "JetbrainsMonoNL Nerd Font Propo:h" .. font_size
		print("Font Size: " .. font_size)
	else
		vim.o.guifont = "JetbrainsmonoNL NF:h" .. font_size
		print("Font Size: " .. font_size)
	end
end
set_font_size(0)
vim.keymap.set({ "i", "v", "n", "c" }, "<C-+>", function()
	set_font_size(1)
end, { desc = "Increase Font Size in neovide", silent = true })
vim.keymap.set({ "i", "v", "n", "c" }, "<C-_>", function()
	set_font_size(-1)
end, { desc = "Decrease Font Size in neovide", silent = true })
vim.keymap.set({ "i", "v", "n", "c" }, "<C-S-BS>", function()
	set_font_size(0)
end, { desc = "Restore Font Size in neovide", silent = true })
