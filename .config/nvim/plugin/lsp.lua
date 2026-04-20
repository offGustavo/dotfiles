vim.schedule(function()
	vim.lsp.config("*", {
		capabilities = {
			textDocument = {
				semanticTokens = {
					multilineTokenSupport = true,
				},
			},
		},
		root_markers = { ".git" },
	})

	vim.lsp.enable("rust_analyzer")
	vim.lsp.enable("ts_ls")

	vim.diagnostic.config({
		-- Use the default configuration
		virtual_lines = false,
		virtual_text = true,
		-- signs = {
		--   text = {
		--     [vim.diagnostic.severity.ERROR] = "󰐼",
		--     [vim.diagnostic.severity.WARN] = "",
		--     [vim.diagnostic.severity.INFO] = "",
		--     [vim.diagnostic.severity.HINT] = "",
		--   }
		-- }
	})
end)

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		-- Diagnostics
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
			vim.keymap.set("n", "<leader>ca", function()
				vim.lsp.buf.code_action()
			end, { desc = "Code Action" })
			vim.keymap.set("n", "<leader>cd", function()
				vim.lsp.buf.definition()
			end, { desc = "Open Definition" })
			vim.keymap.set("n", "<leader>cr", function()
				vim.lsp.buf.references()
			end, { desc = "Open References" })
			vim.keymap.set("n", "<leader>cR", function()
				vim.lsp.buf.rename()
			end, { desc = "Lsp Rename" })
			vim.keymap.set("n", "<leader>cF", function()
				vim.lsp.buf.format()
			end, { desc = "Lsp Code Format" })
			vim.keymap.set("n", "<leader>cq", function()
				vim.diagnostic.setqflist()
			end, { desc = "Open Diagnostics Quickfix list" })
			-- Diagnostic keymaps
			vim.keymap.set("n", "<leader>ce", vim.diagnostic.open_float, { desc = "Line Diagnostics Error" })
		end
	end,
})
