-- Our Global thing
_G.Fish = {}

-- vim options
require("config.options")
require("config.autocmds")
require("config.commands")
require("config.functions")
require("config.keymaps")
require("config.lsp")
require("config.neovide")

-- intern plugins
require("intern")

-- load lazy.nvim and external plugins
require("config.lazy")
-- require("config.pack")
