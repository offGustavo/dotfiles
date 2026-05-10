return {
	"https://github.com/ThePrimeagen/harpoon",
  enabled = false,
	branch = "harpoon2",
	dependencies = {
		"https://github.com/nvim-lua/plenary.nvim",
	},
	config = function()
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
	end,
	-- keys = {
	-- 	{
	-- 		"<leader>h",
	-- 		function()
	-- 			local count = vim.v.count
	-- 			if count then
	-- 				require("harpoon"):list():select(count)
	-- 			end
	-- 			require("harpoon"):list():add()
	-- 		end,
	-- 		desc = "Harpoon File",
	-- 	},
	-- 	{
	-- 		"<leader>H",
	-- 		function()
	-- 			local count = vim.v.count
	-- 			if count then
	-- 				require("harpoon"):list():replace_at(count)
	-- 			end
	-- 			local harpoon = require("harpoon")
	-- 			harpoon.ui:toggle_quick_menu(harpoon:list())
	-- 		end,
	-- 		desc = "Harpoon Quick Menu",
	-- 	},
	-- },
	keys = function()
		local keys = {
			{
				"<leader>ha",
				function()
					require("harpoon"):list():add()
				end,
				desc = "Harpoon File",
			},
			{
				"<leader>he",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Harpoon Quick Menu",
			},
		}

		for i = 1, 9 do
			table.insert(keys, {
				"<leader>" .. i,
				function()
					require("harpoon"):list():select(i)
				end,
				desc = "which_key_ignore",
				-- desc = "Harpoon to File " .. i,
			})

			table.insert(keys, {
				"<leader>h" .. i,
				function()
					require("harpoon"):list():replace_at(i)
				end,
				desc = "Add " .. i,
			})
		end
		return keys
	end,
}
