local M = {}

-- Groups of words to cycle through
local groups = {
	{ "on",     "off"                  },
	{ "true",   "false"                },
	{ "yes",    "no"                   },
	{ "public", "private", "protected" },
}

-- Helper: find the start/end (1-based, inclusive) of the number under or
-- nearest to the cursor on the current line, searching rightward first.
-- Returns: start_col, end_col, matched_string  (all 1-based) or nil
local function find_number_at_cursor(line, col)
	-- col is 1-based here
	local best_s, best_e, best_m = nil, nil, nil

	local search_start = 1
	while true do
		-- Match optional leading minus followed by digits
		local s, e, m = line:find("(%-?%d+)", search_start)
		if not s then break end

		-- A minus is only part of the number if it's not preceded by a digit
		-- (avoids treating "3-2" where "-2" would be a false negative number)
		if line:sub(s, s) == "-" then
			local prev = s > 1 and line:sub(s - 1, s - 1) or ""
			if prev:match("%d") then
				search_start = s + 1
				goto continue
			end
		end

		-- Pick the first number that the cursor is on or to the right of cursor
		if e >= col then
			best_s, best_e, best_m = s, e, m
			break
		end

		-- Keep last occurrence before cursor as fallback
		best_s, best_e, best_m = s, e, m
		search_start = e + 1
		::continue::
	end

	return best_s, best_e, best_m
end

-- Helper: increment/decrement a number at/near the cursor position
-- direction: 1 for increase, -1 for decrease
-- Returns true if a number was found and modified
local function handle_number(direction)
	local pos = vim.fn.getpos(".")
	local current_line = pos[2]
	local current_col = pos[3] -- 1-based

	local line = vim.fn.getline(".")

	local s, e, m = find_number_at_cursor(line, current_col)
	if not s then
		return false
	end

	local num = tonumber(m)
	local new_num = num + direction
	local new_word = tostring(new_num)

	-- Replace the matched span directly by position (no pattern needed)
	local new_line = line:sub(1, s - 1) .. new_word .. line:sub(e + 1)

	vim.fn.setline(".", new_line)

	-- Place cursor on the last digit of the new number (vim C-a behavior)
	local new_col = s + #new_word - 1
	vim.fn.cursor(current_line, new_col)

	return true
end

-- Helper: cycle through a word group in a given direction
-- direction: 1 for next, -1 for previous
local function cycle_word(direction)
	-- First, try to handle a number
	if handle_number(direction) then
		return
	end

	-- If not a number, proceed with word cycling
	local pos = vim.fn.getpos(".")
	local current_line = pos[2]
	local current_col = pos[3] -- 1-based

	local current_word = vim.fn.expand("<cword>")
	if current_word == "" then
		return
	end

	local line = vim.fn.getline(".")

	for _, group in ipairs(groups) do
		for i, word in ipairs(group) do
			if word == current_word then
				local new_word
				if direction == 1 then
					new_word = group[i % #group + 1]
				else
					new_word = group[((i - 2) % #group) + 1]
				end

				-- Find the word's position in the line around the cursor
				-- using positional replacement to handle duplicate words correctly
				local search_start = 2
				local found_s, found_e = nil, nil
				local escaped = current_word:gsub("[%-%.%+%[%]%(%)%$%^%%%?%*]", "%%%1")

				while true do
					local s, e = line:find("%f[%w_]" .. escaped .. "%f[%W_]", search_start)
					if not s then break end

					if e >= current_col then
						-- This occurrence covers or is right of the cursor — use it
						found_s, found_e = s, e
						break
					end
					-- Save as fallback (last occurrence before cursor)
					found_s, found_e = s, e
					search_start = e + 1
				end

				if found_s then
					local new_line = line:sub(1, found_s - 1) .. new_word .. line:sub(found_e + 1)
					vim.fn.setline(".", new_line)
					-- Place cursor on last char of new word
					vim.fn.cursor(current_line, found_s + #new_word - 1)
				end

				return
			end
		end
	end
end

-- Increase: cycle forward (like Ctrl+A in vim)
M.increase = function()
	cycle_word(1)
end

-- Decrease: cycle backward (like Ctrl+X in vim)
M.decrease = function()
	cycle_word(-1)
end

-- Toggle: original behavior (forward cycle)
M.toggle = M.increase

return M
