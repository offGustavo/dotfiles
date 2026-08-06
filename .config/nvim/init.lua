-- Our Global thing
_G.Fish = {}

-- Config Files
require("config.autocmds")
require("config.functions")
require("config.commands")
require("config.options")
require("config.keymaps")
require("config.lsp")
require("config.neovide")

-- Intern plugins
require("intern")

-- External plugins
require("config.lazy")
-- require("config.pack")
