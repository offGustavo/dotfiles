return {
  {

    -- (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
    -- (global-set-key (kbd "C->")         'mc/mark-next-like-this)
    -- (global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
    -- (global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
    -- (global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
    -- (global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

    "brenton-leighton/multiple-cursors.nvim",
    lazy = true,
    -- cond = not not vim.g.vscode,
    version = "*", -- Use the latest tagged version
    opts = {}, -- This causes the plugin setup function to be called
    keys = {
      -- {"<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "x"}, desc = "Add cursor and move down"},
      -- {"<C-k>", "<Cmd>MultipleCursorsAddUp<CR>", mode = {"n", "x"}, desc = "Add cursor and move up"},

      -- { "<A-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move up" },
      -- { "<A-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move down" },
      -- { "<C-A-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move up" },
      -- { "<C-A-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move down" },
      { "<C-A-S-k>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move up" },
      { "<C-A-S-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move down" },

      { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = { "n", "i" }, desc = "Add or remove cursor" },

      {
        "<C-;>",
        "<Cmd>MultipleCursorsAddVisualArea<CR>",
        mode = { "x" },
        desc = "Add cursors to the lines of the visual area",
      },

      { "<C-S-d>", "<Cmd>MultipleCursorsAddMatches<CR>", mode = { "n", "x" }, desc = "Add cursors to cword" },
      { "<C-A-d>", "<Cmd>MultipleCursorsAddMatches<CR>", mode = { "n", "x" }, desc = "Add cursors to cword" },
      -- {"<Leader>A", "<Cmd>MultipleCursorsAddMatchesV<CR>", mode = {"n", "x"}, desc = "Add cursors to cword in previous area"},

      {
        "<C-A-.>",
        "<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
        mode = { "n", "x" },
        desc = "Add cursor and jump to next cword",
      },
      { "<C-A-,>", "<Cmd>MultipleCursorsJumpNextMatch<CR>", mode = { "n", "x" }, desc = "Jump to next cword" },
      {
        "<C->>",
        "<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
        mode = { "n", "x" },
        desc = "Add cursor and jump to next cword",
      },
      { "<C-<>", "<Cmd>MultipleCursorsJumpNextMatch<CR>", mode = { "n", "x" }, desc = "Jump to next cword" },

      { "<C-:>", "<Cmd>MultipleCursorsLock<CR>", mode = { "n", "x" }, desc = "Lock virtual cursors" },
    },
  },

  -- { 'mg979/vim-visual-multi'  }
  --   {
  --     -- dir = "~/Projects/multicursor.nvim/",
  --     "smoka7/multicursors.nvim",
  --     event = "VeryLazy",
  --     dependencies = {
  --       "nvimtools/hydra.nvim",
  --     },
  --     opts = {},
  --     cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
  --     keys = {
  --       {
  --         mode = { "v", "n" },
  --         "<Leader>m",
  --         "<cmd>MCstart<cr>",
  --         desc = "Create a selection for selected text or word under the cursor",
  --       },
  --     },
  --   },
  -- {
  --   "vscode-neovim/vscode-multi-cursor.nvim",
  --   event = "VeryLazy",
  --   cond = not not vim.g.vscode,
  --   opts = {},
  --   config = function()
  --     local cursors = require("vscode-multi-cursor")
  --     vim.keymap.set({ "n", "x" }, "m<space>", cursors.create_cursor, { expr = true, desc = "Create cursor" })
  --     vim.keymap.set({ "n" }, "m<BS>", cursors.cancel, { desc = "Cancel/Clear all cursors" })
  --     vim.keymap.set({ "n", "x" }, "mi", cursors.start_left, { desc = "Start cursors on the left" })
  --     vim.keymap.set({ "n", "x" }, "mI", cursors.start_left_edge, { desc = "Start cursors on the left edge" })
  --     vim.keymap.set({ "n", "x" }, "ma", cursors.start_right, { desc = "Start cursors on the right" })
  --     vim.keymap.set({ "n", "x" }, "mA", cursors.start_right, { desc = "Start cursors on the right" })
  --     vim.keymap.set({ "n" }, "[m<space>", cursors.prev_cursor, { desc = "Goto prev cursor" })
  --     vim.keymap.set({ "n" }, "]m<space>", cursors.next_cursor, { desc = "Goto next cursor" })
  --     vim.keymap.set({ "n" }, "mcs", cursors.flash_char, { desc = "Create cursor using flash" })
  --     vim.keymap.set({ "n" }, "mcw", cursors.flash_word, { desc = "Create selection using flash" })
  --   end,
  -- },
}
