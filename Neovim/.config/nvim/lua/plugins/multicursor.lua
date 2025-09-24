return {
  -- {
  --   -- dir = "~/Projects/multicursor.nvim/",
  --   "smoka7/multicursors.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "nvimtools/hydra.nvim",
  --   },
  --   opts = {},
  --   cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
  --   keys = {
  --     {
  --       mode = { "v", "n" },
  --       "<Leader>m",
  --       "<cmd>MCstart<cr>",
  --       desc = "Create a selection for selected text or word under the cursor",
  --     },
  --   },
  -- },
  {
    "vscode-neovim/vscode-multi-cursor.nvim",
    event = "VeryLazy",
    cond = not not vim.g.vscode,
    opts = {},
    config = function()
      local cursors = require("vscode-multi-cursor")
      local k = vim.keymap.set
      k({ "n", "x" }, "m<space>", cursors.create_cursor, { expr = true, desc = "Create cursor" })
      k({ "n" }, "m<BS>", cursors.cancel, { desc = "Cancel/Clear all cursors" })
      k({ "n", "x" }, "mi", cursors.start_left, { desc = "Start cursors on the left" })
      k({ "n", "x" }, "mI", cursors.start_left_edge, { desc = "Start cursors on the left edge" })
      k({ "n", "x" }, "ma", cursors.start_right, { desc = "Start cursors on the right" })
      k({ "n", "x" }, "mA", cursors.start_right, { desc = "Start cursors on the right" })
      k({ "n" }, "[m<space>", cursors.prev_cursor, { desc = "Goto prev cursor" })
      k({ "n" }, "]m<space>", cursors.next_cursor, { desc = "Goto next cursor" })
      -- k({ 'n' }, 'mcs', cursors.flash_char, { desc = 'Create cursor using flash' })
      -- k({ 'n' }, 'mcw', cursors.flash_word, { desc = 'Create selection using flash' })
    end,
  },
}
