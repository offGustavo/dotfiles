-- if true then return {} end

return {
  {
  "santhosh-tekuri/picker.nvim",
  enabled = false,
  config = function()
    local m = require("picker")
    vim.ui.select = m.select
    vim.keymap.set("n", "<leader>opf", m.pick_file)
    vim.keymap.set("n", "<leader>opb", m.pick_buffer)
    vim.keymap.set("n", l"<leader>oph", m.pick_help)
    vim.keymap.set("n", "<leader>op/", m.pick_grep)
    vim.keymap.set("n", "<leader>opu", m.pick_undo)
    vim.keymap.set("n", "<leader>opq", m.pick_qfitem)
    -- vim.api.nvim_create_autocmd('LspAttach', {
    --     group = vim.api.nvim_create_augroup('LspPickers', {}),
    --     callback = function(ev)
    --         local function opts(desc)
    --             return { buffer = ev.buf, desc = desc }
    --         end
    --         vim.keymap.set('n', 'gd', m.pick_definition, opts("Goto definition"))
    --         vim.keymap.set('n', 'gD', m.pick_declaration, opts("Goto declaration"))
    --         vim.keymap.set('n', 'gy', m.pick_type_definition, opts("Goto type definition"))
    --         vim.keymap.set('n', 'gi', m.pick_implementation, opts("Goto implementation"))
    --         vim.keymap.set('n', '<leader>r', m.pick_reference, opts("Goto reference"))
    --         vim.keymap.set('n', '<leader>s', m.pick_document_symbol, opts("Open symbol picker"))
    --         vim.keymap.set('n', '<leader>S', m.pick_workspace_symbol, opts("Open workspace symbol picker"))
    --         vim.keymap.set('n', '<leader>d', m.pick_document_diagnostic, opts("Open diagnostic picker"))
    --         vim.keymap.set('n', '<leader>D', m.pick_workspace_diagnostic, opts("Open workspace diagnostic picker"))
    --     end,
    -- });
  end,
  },
{
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "nvim-mini/mini.icons" },
  ---@module "fzf-lua"
  ---@type fzf-lua.Config|{}
  ---@diagnostic disable: missing-fields
  opts = {}
  ---@diagnostic enable: missing-fields
},
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- optional but recommended
      -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    }
}
}
