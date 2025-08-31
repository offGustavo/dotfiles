--[[
=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================
--]]

-- Config
require('config.options')
require('config.keymaps')
require('config.lsp')
require('config.autocmds')

-- Plugins
require("plugins.theme")
require("plugins.mason-lsp-config")
require("plugins.treesitter")
require("plugins.neogit")
-- require("plugins.mini")
-- require("plugins.snacks")
-- require("plugins.oil")


vim.pack.add({ 'https://github.com/dmtrKovalenko/fff.nvim' })

-- the plugin will automatically lazy load
vim.g.fff = {
  lazy_sync = true, -- start syncing only when the picker is open
  debug ={
    enabled = true,
    show_scores = true,
  }
}

vim.keymap.set('n', 'ff', function()
   require('fff').find_files()
end, { desc = 'FFFind files' })
