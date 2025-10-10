-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Custom Things
require("fish.multi_marks")
require("fish.commads")

require("fish.neovide")
require("fish.vscode")
require("fish.filetypes")

if not vim.uv.os_uname().sysname == "Windows_NT" then
  require("fish.theme")
  require("fish.kitty")
  require("fish.tmux")
end

