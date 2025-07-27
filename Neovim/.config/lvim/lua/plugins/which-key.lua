return { -- Which Key
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
  icons = {
    mappings = false, -- set to false to disable all mapping icons
  },
win = {
    -- don't allow the popup to overlap with the cursor
    no_overlap = true,
    -- width = 1,
    -- height = { min = 4, max = 25 },
    -- col = 0,
    -- row = math.huge,
    -- border = "none",
    padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
    title = true,
    title_pos = "center",
    zindex = 1000,
    -- Additional vim.wo and vim.bo options
    bo = {},
    wo = {
      -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
    },
  },
    preset = 'helix',
    spec = {
      { '<leader>s', group = 'search' },
      { '<leader>f', group = 'find' },
      { '<leader>c', group = 'code' },
      { '<leader>q', group = 'quickfix' },
      { '<leader>u', group = 'ui' },
      { '<leader>h', group = 'harpoon' },
      { '<leader>b', group = 'buffer' },
      { '<leader>o', group = 'options/custom' },
      { '<leader>g', group = 'git ', mode = { 'n', 'v' } },
      {
        '<leader>w',
        group = 'windows',
        proxy = '<c-w>',
        expand = function()
          return require('which-key.extras').expand.win()
        end,
      },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer Keymaps',
    },
    {
      '<c-w><space>',
      function()
        require('which-key').show { keys = '<c-w>', loop = true }
      end,
      desc = 'Window Hydra Mode',
    },
  },
}
