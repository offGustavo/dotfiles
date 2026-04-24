vim.schedule(function()
  vim.cmd.packadd("tokyonight.nvim")

	require("tokyonight").setup({
		dim_inactive = false,
		light_style = "day", -- The theme is used when the background is set to light
		style = "night",
		transparent = false,
		styles = {
			sidebars = "transparent",
			floats = "transparent",
			functions = { bold = true },
			keywords = { bold = true },
		},
		on_colors = function(colors)
			-- colors.bg = "#000000" -- To check if its working try something like "#ff00ff" instead of colors.none
			colors.bg_statusline = colors.none -- To check if its working try something like "#ff00ff" instead of colors.none
			colors.bg_statusline = colors.none
		end,
	})

	vim.cmd.colorscheme("tokyonight")
end)
