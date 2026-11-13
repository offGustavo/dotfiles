local shell_job

-- Handles a line of user input.
local function on_submit(text)
  -- Send the text to the shell with Enter appended.
  vim.api.nvim_chan_send(shell_job, text .. "\n")
end

-- Handles output from the shell.
local function on_output(_, msg, _)
  -- Add shell output above the prompt.
  local buf = vim.api.nvim_get_current_buf()
  vim.fn.prompt_appendbuf(buf, msg)
end

-- Handles the shell exit.
local function on_exit(_, _, _)
  vim.cmd("quit!")
end

-- Start a shell in the background.
shell_job = vim.fn.jobstart({ "/bin/sh" }, {
  on_stdout = on_output,
  on_stderr = on_output,
  on_exit = on_exit,
})

vim.cmd("new")
vim.bo.buftype = "prompt"
local buf = vim.api.nvim_get_current_buf()
vim.fn.prompt_setcallback(buf, on_submit)
vim.fn.prompt_setprompt(buf, "shell command: ")

-- Start accepting shell commands.
vim.cmd("startinsert")
