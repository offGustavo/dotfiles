local M = {}
local last_cmd = ""

local function append(lines)
  lines = vim.tbl_filter(function(l)
    return l ~= ""
  end, lines)
  if #lines > 0 then
    vim.fn.setqflist({}, "a", { lines = lines })
  end
end

function M.compile(cmd)
  if cmd == nil or cmd == "" then
    cmd = vim.fn.input({
      -- prompt = "Compile command: ",
      prompt = "$ ",
      default = last_cmd,
      completion = "shellcmd",
    })
  end
  if cmd == "" or cmd == nil then
    return
  end
  last_cmd = cmd

  vim.fn.setqflist({}, " ", { title = cmd, lines = {} })
  vim.cmd("copen")
  vim.cmd("wincmd p") -- keep focus in your code window

  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      append(data)
    end,
    on_stderr = function(_, data)
      append(data)
    end,
    on_exit = function(_, code)
      append({
        "",
        code == 0 and "Compilation finished" or ("Compilation exited abnormally with code " .. code),
      })
    end,
  })
end

function M.recompile()
  M.compile(last_cmd)
end

return M

-- local M = {}
--
-- local config = vim.tbl_extend("force", {
-- 	default_compile_command = "make -k",
-- 	error_format = {
-- 		"%f:%l:%c: %m",
-- 	},
-- }, vim.g.compile_config or {})
--
-- ---@return string
-- --- Return user compile cmd
-- local getCmd = function()
-- 	return vim.fn.input({
-- 		prompt = "Compile: ",
-- 		default = config.default_compile_command,
-- 		completion = "file",
-- 		-- completion = "shellcmd", -- For shell commands
-- 	})
-- end
--
-- --- Parse the command
-- local parseCmd = function(c)
-- 	c = string.split(c, " ")
-- 	if string.len(c) == 1 then
-- 		return c
-- 	end
-- 	return parseCmd(c)
-- end
--
-- -- User interface to execute the command
-- --@param
-- --@return
-- M.compile = function()
-- 	local userCmd = getCmd()
--
-- 	if userCmd == nil then
-- 		return
-- 	end
--
-- 	if userCmd == "" then
-- 		vim.notify(" Empty input, provide an command to compile optation cacelled", vim.log.levels.WARN)
-- 		return
-- 	end
--
-- 	vim.cmd("terminal " .. userCmd)
-- end
--
-- M.setup = function()
-- 	local c = require("Fish.compile")
--
-- 	vim.keymap.set("n", "<M-c>", function()
-- 		c.compile()
-- 	end, { desc = "Compile Mode" })
--
-- 	vim.api.nvim_create_user_command("Compile", function()
-- 		c.compile()
-- 	end, {})
-- end
--
-- return M
