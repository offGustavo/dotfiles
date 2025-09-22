-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Custom Things
require("fish.filetypes")
require("fish.theme")
require("fish.kitty")
require("fish.tmux")
-- require("fish.multi_marks")
require("fish.neovide")
require("fish.vscode")

vim.cmd.colorscheme("catppuccin")
