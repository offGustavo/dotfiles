return {
  "NStefan002/screenkey.nvim",
  lazy = true,
  enabled = true,
  version = "*", -- or branch = "main", to use the latest commit
  opts = {
    win_opts = {
        anchor = "SW",
        title = " Screenkey.nvim ",
    },
  },
  keys = {
    { "<leader>os", "<Cmd>Screenkey<Cr>", { desc = "Screenkey Toggle" } },
  },
}
