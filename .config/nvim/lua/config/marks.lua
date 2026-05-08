-- REF: https://github.com/neovim/neovim/discussions/39260
local mark_names = vim.split("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", "") -- .><^

local au = vim.api.nvim_create_augroup("mark_signs", { clear = true })
local ns = vim.api.nvim_create_namespace("mark_signs")

local iter_marks = function(buf, cb)
	local line_count = vim.api.nvim_buf_line_count(buf)
	for _, name in ipairs(mark_names) do
		local lnum = vim.api.nvim_buf_get_mark(buf, name)[1]
		if lnum > 0 and lnum <= line_count then
			cb(lnum, name)
		end
	end
end

vim.api.nvim_create_autocmd("MarkSet", {
	pattern = "[[:alpha:]]",
	group = au,
	desc = "Remove overlapping marks on the same line",
	callback = function(e)
		iter_marks(e.buf, function(lnum, name)
			if e.data.line == lnum and e.data.name ~= name then
				vim.cmd.delmark(name)
			end
		end)
	end,
})

-- NOTE: After neovim#39218 (NVIM 0.12.2+), `MarkSet` also fires on deletion,
-- so the `event` can be changed to `{ "BufRead", "MarkSet" }`.
-- vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
vim.api.nvim_create_autocmd({ "BufRead", "MarkSet" }, {
	group = au,
	desc = "Frequently update mark signs",
	callback = function(e)
		vim.api.nvim_buf_clear_namespace(e.buf, ns, 0, -1)
		iter_marks(e.buf, function(lnum, name)
			-- if name:match("%p") and vim.bo[e.buf].buftype ~= "" then
			--   return
			-- end
			vim.api.nvim_buf_set_extmark(e.buf, ns, lnum - 1, 0, {
				sign_text = name,
				sign_hl_group = "DiagnosticHint",
			})
		end)
	end,
})

vim.keymap.set("n", "dm", "<Cmd>exe 'delmarks ' . getcharstr()<Enter>", { desc = "Del mark" })

---{{{
-- ---folke
-- vim.keymap.set("n", "dm", ":execute 'delmarks '.nr2char(getchar())<cr>", { silent = true })
---}}}
