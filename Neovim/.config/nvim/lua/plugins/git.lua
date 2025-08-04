return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    "folke/snacks.nvim", -- optional
  },
  opts = {
    auto_refresh = true,
  },
  keys = {
    { "<leader>gn", "<Cmd>Neogit kind=floating cwd=%:h<Cr>", silent = true, desc = "Neogit Float" },
    { "<leader>gg", "<Cmd>Neogit kind=replace cwd=%:h<Cr>", silent = true, desc = "Neogit" },
  },
}
