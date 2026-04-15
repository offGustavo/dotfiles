vim.schedule(function()
	vim.pack.add({ "https://github.com/brenton-leighton/multiple-cursors.nvim" })
	require("multiple-cursors").setup({
		pre_hook = function()
			require("vim._core.ui2").enable({
				enable = false, -- Whether to enable or disable the UI.
			})
		end,
		post_hook = function()
			require("vim._core.ui2").enable({
				enable = true, -- Whether to enable or disable the UI.
				msg = { -- Options related to the message module.
					---@type 'cmd'|'msg' Default message target, either in the
					---cmdline or in a separate ephemeral message window.
					---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
					---or table mapping |ui-messages| kinds and triggers to a target.
					targets = "msg",
				},
			})
		end,
	}) -- This causes the plugin setup function to be called

	--- Custom keymap(like nmap in vim)
	---@param m string
	---@param k string
	---@param c string
	local function map(m, k, c)
		vim.keymap.set(m, k, c)
	end

	-- I dont like this

	map("n", "<M-S-m>", "<Cmd>MultipleCursorsLock<Cr>")
	map("n", "<M-q>", function()
		-- require("multiple-cursors.virtual_cursors").set_lock()
		local lnum, col, curswant = 1, 1, 1
		require("multiple-cursors").add_cursor(lnum, col, curswant)
	end)

	map("n", "<C-S-d>", "<Cmd>MultipleCursorsAddMatches<Cr>")
	map("n", "<C-S-k>", "<Cmd>MultipleCursorsAddUp<Cr>")
	map("n", "<C-S-j>", "<Cmd>MultipleCursorsAddDown<Cr>")
	map("x", "<C-;>", "<Cmd>MultipleCursorsAddVisualArea<Cr>")
	map("n", "<C-;>", "<Cmd>MultipleCursorsAddMatchesV<Cr>")
	map("n", "<C-.>", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>")
	map("n", "<C-,>", "<Cmd>MultipleCursorsAddJumpPrevMatch<CR>")
	map("n", "<C-p>", "<Cmd>MultipleCursorsJumpPrevMatch<Cr>")
	map("n", "<C-n>", "<Cmd>MultipleCursorsJumpNextMatch<Cr>")
end)
