vim.o.foldcolumn = "1"
vim.o.signcolumn = "yes:1"

Fish.close_fold_char = ""
-- Fish.close_fold_char = ">"
-- vim.o.statuscolumn = "%s %l %C"

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


-- TODO: add mouse support
-- vim.schedule(function()
	function Fish.statuscolumn()
		local function pad_center(s, width)
			local len = vim.fn.strwidth(s)
			if len >= width then
				return s
			end
			local left = math.floor((width - len) / 2)
			local right = width - len - left
			return string.rep(" ", left) .. s .. string.rep(" ", right)
		end

		-- Fixed widths for each column
		local W_SIGN = 1 -- sign column
		local W_MARKS = 1 -- marks column
		local W_NUM = 1 -- line number (up to 9999)
		local W_FOLD = 2 -- fold indicator
		local W_DIFF = 1 -- diff character

		-- Sign column (built-in %s handles it, just pad)
		local sign = "%s"

		-- Marks on this line
		local marks_str = ""
		local bufnr = vim.fn.bufnr("%")
		local marklist = vim.fn.getmarklist(bufnr)
		for _, mark in ipairs(marklist) do
			if mark.pos and mark.pos[2] == vim.v.lnum then
				marks_str = "%#LineNr#" .. mark.mark:gsub("'", "")
			end
		end
		local marks = pad_center(marks_str, W_MARKS)

		-- Line number (right-aligned within fixed width)
		local lnum_str = tostring(vim.v.lnum)
		local lnum = string.rep(" ", W_NUM - #lnum_str) .. lnum_str

		-- Fold indicator
		local fold_str = ""
		local fold_closed = vim.fn.foldclosed(vim.v.lnum)
		local fold_level = vim.fn.foldlevel(vim.v.lnum)

		if vim.v.lnum == vim.fn.foldclosedend(vim.v.lnum) then


			fold_str = "%#Folded#" .. Fish.close_fold_char .. " "
		elseif fold_closed ~= -1 then
			fold_str = "%#Folded#" .. Fish.close_fold_char .. " "
		elseif fold_level > 0 then
			fold_str = ""
			-- -- Diff character
			-- local diff_str = ""
			-- if pcall(require, "mini.diff") then
			-- 	local mini_diff = require("mini.diff")
			-- 	local diff_type = mini_diff.get_diff and mini_diff.get_diff(vim.v.lnum)
			-- 	if diff_type == "add" then
			-- 		diff_str = "+"
			-- 	elseif diff_type == "change" then
			-- 		diff_str = "~"
			-- 	elseif diff_type == "delete" then
			-- 		diff_str = "-"
			-- 	end
			-- end
			-- local diff = pad_center(diff_str, W_DIFF)
			-- fold_str = diff
		end
		local fold = pad_center(fold_str, W_FOLD)

		-- return "%s" .. marks .. "%l" .. fold
		return "%s" .. "%l" .. fold
	end

	vim.o.statuscolumn = "%!v:lua.Fish.statuscolumn()"
-- end)
