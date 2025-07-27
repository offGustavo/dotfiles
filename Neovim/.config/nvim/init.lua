
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- Custom Things

vim.keymap.set("n", "<leader>oT", function() require("fish.tmux_theme").write_tmux_theme() end, { desc = "Update Tmux Theme"})
require("fish.chamaleon").setup()

-- local colorscheme = require('config.colorscheme')
-- vim.cmd('colorscheme ' .. colorscheme.colorscheme)

local last_colorscheme_file = vim.fn.stdpath("config") .. "/theme"
local file = io.open(last_colorscheme_file, "r")
if file then
  local colorscheme = file:read("*line")
  file:close()
  if colorscheme ~= "" then
    vim.cmd("colorscheme " .. colorscheme)
  else
    vim.cmd("colorscheme default")
  end
else
  vim.cmd("colorscheme default")
end


