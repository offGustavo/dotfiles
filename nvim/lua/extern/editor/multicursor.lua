return {
  "https://github.com/brenton-leighton/multiple-cursors.nvim",
  -- TODO: remover quando 0.13 ser estavel
  enabled = vim.fn.has("nvim-0.13") ~= 1,
  lazy = true,
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
    { "Q", "<Cmd>MultipleCursorsAddDelete<Cr>" },
    { "q=", "<Cmd>MultipleCursorsLock<Cr>" },
    { "<C-S-L>", "<Cmd>MultipleCursorsAddMatches<Cr>" },
    { "<C-S-K>", "<Cmd>MultipleCursorsAddUp<Cr>" },
    { "<C-S-J>", "<Cmd>MultipleCursorsAddDown<Cr>" },
    { "<C-;>", "<Cmd>MultipleCursorsAddVisualArea<Cr>", mode = "x" },
    { "<C-;>", "<Cmd>MultipleCursorsAddMatchesV<Cr>", mode = "n" },
    { "<M-p>", "<Cmd>MultipleCursorsAddJumpPrevMatch<CR>" },
    { "<M-n>", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>" },
    { "<C-p>", "<Cmd>MultipleCursorsJumpPrevMatch<Cr>" },
    { "<C-n>", "<Cmd>MultipleCursorsJumpNextMatch<Cr>" },
  },
}
