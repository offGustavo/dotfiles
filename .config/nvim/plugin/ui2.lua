if vim.fn.has('nvim-0.12') == 1 then
	require("vim._core.ui2").enable({
		enable = true, -- Whether to enable or disable the UI.
		msg = { -- Options related to the message module.
			target = "msg",
			timeout = 2000, -- Time a message is visible in the message window.
		},
	})
end
