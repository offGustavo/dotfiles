local M = {}

function M.click_fold()
	local pos = vim.fn.getmousepos()
	vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 1 })
	vim.api.nvim_win_call(pos.winid, function()
		if vim.fn.foldlevel(pos.line) > 0 then
			vim.cmd("normal! za")
		end
	end)
end

local GIT_PATTERNS = { "GitSign", "MiniDiffSign" }

local function is_git_sign(name)
	for _, p in ipairs(GIT_PATTERNS) do
		if name:find(p) then
			return true
		end
	end
end

local function get_line_signs(buf, lnum)
	local by_type = {}
	local extmarks = vim.api.nvim_buf_get_extmarks(buf, -1, { lnum - 1, 0 }, { lnum - 1, -1 }, {
		details = true,
		type = "sign",
	})
	for _, mark in ipairs(extmarks) do
		local d = mark[4]
		local name = d.sign_hl_group or d.sign_name or ""
		local kind = is_git_sign(name) and "git" or "sign"
		local existing = by_type[kind]
		local priority = d.priority or 0
		if not existing or priority > (existing.priority or 0) then
			by_type[kind] = {
				text = d.sign_text,
				texthl = d.sign_hl_group,
				priority = priority,
				type = kind,
			}
		end
	end
	return by_type
end

local function render_sign(sign)
	if not sign then
		return "  "
	end
	local text = vim.fn.strcharpart(sign.text or "", 0, 2)
	text = text .. string.rep(" ", 2 - vim.fn.strchars(text))
	if sign.texthl then
		return "%#" .. sign.texthl .. "#" .. text .. "%*"
	end
	return text
end

function M.build()
	local win = vim.g.statusline_winid
	local buf = vim.api.nvim_win_get_buf(win)
	local lnum = vim.v.lnum

	local signs = get_line_signs(buf, lnum)
	local left = render_sign(signs.sign)

	-- All window-sensitive calls scoped to `win`
	local fold_level = vim.api.nvim_win_call(win, function()
		return vim.fn.foldlevel(lnum)
	end)

	local right = "  "
	if fold_level > 0 then
		local fold_closed = vim.api.nvim_win_call(win, function()
			return vim.fn.foldclosed(lnum)
		end)

		if fold_closed ~= -1 then
			local foldclose = vim.api.nvim_win_call(win, function()
				return vim.opt.fillchars:get().foldclose or "+"
			end)
			right = "%#Folded#" .. foldclose .. " %*"
		else
			right = render_sign(signs.git)
		end
	end

	local num
	if vim.wo[win].relativenumber and vim.v.relnum ~= 0 then
		num = vim.v.relnum
	else
		num = lnum
	end
	local lnum_str = "%=" .. num .. " "

	return left .. lnum_str .. "%@v:lua.require'fish.statuscolumn'.click_fold@" .. right .. "%T"
end

return M
