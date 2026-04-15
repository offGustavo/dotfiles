local M = {}

local config = vim.tbl_extend("force", {
	default_compile_command = "make -k",
	error_format = {
		"%f:%l:%c: %m",
	},
}, vim.g.forge_compile_config or {})

---@return string
--- Return user compile cmd
local getCmd = function()
	return vim.fn.input({
		prompt = "Compile: ",
		default = config.default_compile_command,
		completion = "file",
		-- completion = "shellcmd", -- For shell commands
	})
end

--- Parse the command
local parseCmd = function(c)
	c = string.split(c, " ")
	if string.len(c) == 1 then
		return c
	end
	return parseCmd(c)
end

-- User interface to execute the command
--@param
--@return
M.compile = function()
	local userCmd = getCmd()

	if userCmd == nil then
		return
	end

	if userCmd == "" then
		vim.notify(
			[[
        Empty input, provide an command to compile
        optation cacelled
        ]],
			vim.log.levels.WARN
		)
		return
	end

	vim.cmd("terminal " .. userCmd)
end

M.setup = function()
  local c = require("forge.compile")

	if vim.g.forge_terminal_loaded then
		return
	end
	vim.g.forge_terminal_loaded = true

  vim.keymap.set("n", "<M-c>", function ()
    c.compile()
  end, { desc = "Compile Mode" })

	vim.api.nvim_create_user_command("Compile", function()
		c.compile()
	end, {})
end

return M
