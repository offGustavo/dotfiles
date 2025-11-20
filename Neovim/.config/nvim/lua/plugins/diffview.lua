return {
  "sindrets/diffview.nvim",
  config = function()
    vim.keymap.set("n", "<leader>gd", "<Cmd>DiffviewOpen<Cr>", { silent = true, desc = "DiffView" })
  end,
}
