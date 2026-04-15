vim.schedule(function()
	vim.o.spelllang = "pt_br,en_us,es"
	vim.o.spell = true
	vim.o.spelloptions = "camel" -- Treat camelCase word parts as separate words

	-- local spell_on_choice = vim.schedule_wrap(function(_, idx)
	-- 	if type(idx) == "number" then
	-- 		vim.cmd("normal! " .. idx .. "z=")
	-- 	end
	-- end)
	-- local spellsuggest_select = function()
	-- 	if vim.v.count > 0 then
	-- 		spell_on_choice(nil, vim.v.count)
	-- 		return
	-- 	end
	-- 	local cword = vim.fn.expand("<cword>")
	-- 	local prompt = "Change " .. vim.inspect(cword) .. " to:"
	-- 	vim.ui.select(vim.fn.spellsuggest(cword, vim.o.lines), { prompt = prompt }, spell_on_choice)
	-- end
	-- vim.keymap.set("n", "z=", spellsuggest_select, { desc = "Shows spelling suggestions" })
end)
