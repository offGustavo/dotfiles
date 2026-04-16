vim.schedule(function()
  vim.cmd.packadd("plenary.nvim")
  vim.cmd.packadd("harpoon")

	local harpoon = require("harpoon")
	harpoon.setup({
		menu = {
			width = vim.api.nvim_win_get_width(0) - 4,
		},
		settings = {
			save_on_toggle = true,
		},
	})

	local harpoon_extensions = require("harpoon.extensions")
	harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
	vim.keymap.set("n", "<leader>ha", function()
		require("harpoon"):list():add()
	end, { desc = "Harpoon File" })
	vim.keymap.set("n", "<leader>he", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end, { desc = "Harpoon Quick Menu" })

	for i = 1, 9 do
		vim.keymap.set("n", "<leader>" .. i, function()
			require("harpoon"):list():select(i)
		end, { desc = "Go to " .. i .. " File" })

		vim.keymap.set("n", "<leader>h" .. i, function()
			require("harpoon"):list():replace_at(i)
		end, { desc = "Add File to " .. i })
	end
end)
