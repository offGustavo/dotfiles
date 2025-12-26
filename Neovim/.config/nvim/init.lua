-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Custom Things
-- require("fish.multi_marks")
require("fish.commads")
require("fish.filetypes")

-- External Programs
require("fish.neovide")
require("fish.vscode")

-- if os.getenv("DISPLAY") then
  -- Theme
  -- require("fish.theme")
  require("themes.compline").setup()
-- else
--   vim.cmd([[
--       colorscheme default
--       set notermguicolors
--     ]])
-- end

if vim.uv.os_uname().sysname == "Windows_NT" then
else
  require("fish.wezterm")
  require("fish.kitty")
  -- require("fish.tmux")
  -- require("fish.lazygit")
end
