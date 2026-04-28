return {
	"https://github.com/ibhagwan/fzf-lua",
  opts = {
				-- "ivy",
				-- "fzf-native",
				"telescope",
				ui_select = true,
				fzf_colors = {
					true, -- inherit fzf colors that aren't specified below from
				},
			},
      keys = {
			 { "<M-o>", "<Cmd>FzfLua files<Cr>",  desc = "Find" },
			 { "<M-s>", "<Cmd>FzfLua live_grep<Cr>",  desc = "Grep" },
			 { "<M-b>", "<Cmd>FzfLua buffers<Cr>",  desc = "Buffers" },
			 { "<M-r>", "<Cmd>FzfLua oldfiles<Cr>",  desc = "Old Files" },
			 { "<M-p>", "<Cmd>FzfLua global<Cr>",  desc = "Global" },
			 { "<leader>fa", "<Cmd>FzfLua<Cr>",  desc = "Fzf Lua Builtin" },
      },
}
			-- vim.keymap.set("n", "z=", "<Cmd>FzfLua spell_suggest<Cr>")
