vim.schedule(function()
  vim.cmd.packadd("multiple-cursors.nvim")
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

	vim.keymap.set("n", "<C-m>", "<Cmd>MultipleCursorsLock<Cr>")
	vim.keymap.set("n", "<M-q>", function() require("multiple-cursors.virtual_cursors").set_lock() local lnum, col, curswant = 1, 1, 1 require("multiple-cursors").add_cursor(lnum, col, curswant) end)
	vim.keymap.set("n", "<C-S-d>", "<Cmd>MultipleCursorsAddMatches<Cr>")
	vim.keymap.set("n", "<C-S-k>", "<Cmd>MultipleCursorsAddUp<Cr>")
	vim.keymap.set("n", "<C-S-j>", "<Cmd>MultipleCursorsAddDown<Cr>")
	vim.keymap.set("x", "<C-;>", "<Cmd>MultipleCursorsAddVisualArea<Cr>")
	vim.keymap.set("n", "<C-;>", "<Cmd>MultipleCursorsAddMatchesV<Cr>")
	vim.keymap.set("n", "<C-.>", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>")
	vim.keymap.set("n", "<C-,>", "<Cmd>MultipleCursorsAddJumpPrevMatch<CR>")
	vim.keymap.set("n", "<C-p>", "<Cmd>MultipleCursorsJumpPrevMatch<Cr>")
	vim.keymap.set("n", "<C-n>", "<Cmd>MultipleCursorsJumpNextMatch<Cr>")
end)
