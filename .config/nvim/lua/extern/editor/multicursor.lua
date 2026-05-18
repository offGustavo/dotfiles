return {
  "https://github.com/brenton-leighton/multiple-cursors.nvim",
  opts = {
    pre_hook = function()
      -- require("vim._core.ui2").enable({
      --   enable = false, -- Whether to enable or disable the UI.
      -- })
    end,
    post_hook = function()
      -- require("vim._core.ui2").enable({
      --   enable = true, -- Whether to enable or disable the UI.
      --   msg = {        -- Options related to the message module.
      --     ---@type 'cmd'|'msg' Default message target, either in the
      --     ---cmdline or in a separate ephemeral message window.
      --     ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
      --     ---or table mapping |ui-messages| kinds and triggers to a target.
      --     targets = "msg",
      --   },
      -- })
    end,
  }, -- This causes the plugin setup function to be called
  keys = {
    { "<M-q>", "<Cmd>MultipleCursorsAddDelete<Cr>" },
    { "<C-m>",   "<Cmd>MultipleCursorsLock<Cr>" },
    { "<C-S-d>", "<Cmd>MultipleCursorsAddMatches<Cr>" },
    { "<C-S-k>", "<Cmd>MultipleCursorsAddUp<Cr>" },
    { "<C-S-j>", "<Cmd>MultipleCursorsAddDown<Cr>" },
    { "<C-;>",   "<Cmd>MultipleCursorsAddVisualArea<Cr>" },
    { "<C-;>",   "<Cmd>MultipleCursorsAddMatchesV<Cr>" },
    { "<C-.>",   "<Cmd>MultipleCursorsAddJumpNextMatch<CR>" },
    { "<C-,>",   "<Cmd>MultipleCursorsAddJumpPrevMatch<CR>" },
    { "<C-p>",   "<Cmd>MultipleCursorsJumpPrevMatch<Cr>" },
    { "<C-n>",   "<Cmd>MultipleCursorsJumpNextMatch<Cr>" },
  },
}
