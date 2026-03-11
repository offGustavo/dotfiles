require("config.options")
-- Lazy.nvim/Plugins things
require("config.lazy")

-- vim.cmd.colorscheme("tokyonight")
-- vim.cmd.colorscheme("shibuya")
require("fish.theme")

-- Our custom things
Fish = {}

-- PERF:
vim.schedule(function()
    require("config.autocmds")
    require("config.keymaps")
    require("config.zoxide")
    require("fish.forge")
    require("fish.kitty")
end)
