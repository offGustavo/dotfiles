return {
  "https://codeberg.org/comfysage/artio.nvim",
  enabled = false,
  -- event = "VeryLazy",
  opts = {
    opts = {
      preselect = true, -- whether to preselect the first match
      bottom = true, -- whether to draw the prompt at the bottom
      shrink = true, -- whether the window should shrink to fit the matches
      promptprefix = "::", -- prefix for the prompt
      prompt_title = true, -- whether to draw the prompt title
      pointer = ">", -- pointer for the selected match
      marker = "│", -- prefix for marked items
      infolist = { "list" }, -- index: [1] list: (4/5)
      use_icons = true, -- requires mini.icons
    },
    win = {
      height = 12,
      hidestatusline = false, -- works best with laststatus=3
    },
    -- NOTE: if you override the mappings, make sure to provide keys for all actions
    mappings = {
      ["<C-n>"] = "down",
      ["<C-p>"] = "up",
      ["<cr>"] = "accept",
      ["<esc>"] = "cancel",
      ["<tab>"] = "mark",
      ["<c-g>"] = "togglelive",
      ["<c-l>"] = "togglepreview",
      ["<c-q>"] = "setqflist",
      ["<m-q>"] = "setqflistmark",
    },
  },
  keys = {
    { "<M-o>", function() require('artio.builtins').files({ findprg = [[ fd --type f ]], }) end },
    { "<M-s>", "<Plug>(artio-grep)" },
    { "<M-p>", "<Plug>(artio-smart)" },
    { "<M-b>", "<Plug>(artio-buffers)" },
    { "<M-r>", "<Plug>(artio-oldfiles)" }
  },
  -- init = function()
  --   -- override built-in ui select with artio
  --   vim.ui.select = require("artio").select
  -- end
}
