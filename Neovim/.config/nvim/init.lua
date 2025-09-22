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

local picker = require("fish.picker")
-- vim.ui.select = picker.select
vim.keymap.set('n', '<leader>sb', picker.pick_buffer)
vim.keymap.set('n', '<leader>sf', picker.pick_file)
vim.keymap.set("n", "<leader>sg", picker.pick_grep)
-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = vim.api.nvim_create_augroup('LspPickers', {}),
--   callback = function(ev)
--     local function opts(desc)
--       return { buffer = ev.buf, desc = desc }
--     end
--     pcall(vim.keymap.del, "n", "gra")
--     pcall(vim.keymap.del, "n", "gri")
--     pcall(vim.keymap.del, "n", "grn")
--     pcall(vim.keymap.del, "n", "grr")
--     vim.keymap.set('n', 'gD', picker.pick_declaration, opts("Goto declaration"))
--     vim.keymap.set('n', 'gd', picker.pick_definition, opts("Goto definition"))
--     vim.keymap.set('n', 'gi', picker.pick_implementation, opts("Goto implementation"))
--     vim.keymap.set('n', 'gy', picker.pick_type_definition, opts("Goto type definition"))
--     vim.keymap.set('n', 'gr', picker.pick_reference, opts("Goto reference"))
--     vim.keymap.set('n', '<leader>ss', picker.pick_document_symbol, opts("Open symbol picker"))
--     vim.keymap.set('n', '<leader>sS', picker.pick_workspace_symbol, opts("Open workspace symbol picker"))
--     vim.keymap.set('n', '<leader>sd', picker.pick_document_diagnostic, opts("Open diagnostic picker"))
--     vim.keymap.set('n', '<leader>sD', picker.pick_workspace_diagnostic, opts("Open workspace diagnostic picker"))
--   end,
-- });

