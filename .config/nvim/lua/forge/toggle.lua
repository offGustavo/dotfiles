local M = {}

-- Groups of words to cycle through
local groups = {
	{ "on", "off" },
	{ "true", "false" },
	{ "yes", "no" },
	{ "public", "private", "protected" },
}

-- Helper: check if a string is an integer (optionally negative)
local function is_number(s)
	-- Match optional minus sign followed by one or more digits
	return s:match("^-?%d+$") ~= nil
end

-- Helper: increment/decrement a number at the cursor position
-- direction: 1 for increase, -1 for decrease
local function handle_number(direction)
	-- Save cursor position
	local pos = vim.fn.getpos(".")
	local current_line = pos[2]
	local current_col = pos[3] - 1 -- 0-based column

	-- Get the word under cursor
	local current_word = vim.fn.expand("<cword>")
	if current_word == "" or not is_number(current_word) then
		return false -- Not a number
	end

	-- Convert to number, apply delta, convert back
	local num = tonumber(current_word)
	local delta = direction == 1 and 1 or -1
	local new_num = num + delta
	local new_word = tostring(new_num)

	-- Get the whole line
	local line = vim.fn.getline(".")

	-- Escape special characters for pattern matching
	local pattern = current_word:gsub("[%-%.%+%[%]%(%)%$%^%%%?%*]", "%%%1")
	-- Replace only the word (with boundary checks)
	local new_line = line:gsub("(%f[%a_]" .. pattern .. "%f[%A_])", new_word, 1)

	-- Update the line
	vim.fn.setline(".", new_line)

	-- Adjust cursor to the end of the new word
	local new_col = current_col - #current_word + #new_word + 1
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
	local current_col = pos[3] - 1

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
					local prev_index = ((i - 2) % #group) + 1
					new_word = group[prev_index]
				end

				local pattern = current_word:gsub("[%-%.%+%[%]%(%)%$%^%%%?%*]", "%%%1")
				local new_line = line:gsub("(%f[%a_]" .. pattern .. "%f[%A_])", new_word, 1)

				vim.fn.setline(".", new_line)

				local new_col = current_col - #current_word + #new_word + 1
				vim.fn.cursor(current_line, new_col)

				return
			end
		end
	end
end

-- Increase: cycle forward (like Ctrl+A)
M.increase = function()
	cycle_word(1)
end

-- Decrease: cycle backward (like Ctrl+X)
M.decrease = function()
	cycle_word(-1)
end

-- Toggle: original behavior (forward cycle)
M.toggle = M.increase

return M
