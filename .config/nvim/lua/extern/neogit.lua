-- if true then return {} end
return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },         -- required

    -- Only one of these is needed.
    -- "sindrets/diffview.nvim",        -- optional
    { "esmuellert/codediff.nvim", lazy = true },      -- optional

    -- Only one of these is needed.
    -- "nvim-telescope/telescope.nvim", -- optional
    -- "ibhagwan/fzf-lua",              -- optional
    -- "nvim-mini/mini.pick",           -- optional
    -- "folke/snacks.nvim",             -- optional
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit kind=replace<cr>", desc = "Show Neogit UI" },
    { "<M-S-g>", "<cmd>Neogit kind=replace<cr>", desc = "Show Neogit UI" }
  }
}
