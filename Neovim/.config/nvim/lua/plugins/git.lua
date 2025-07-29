return {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "folke/snacks.nvim", -- optional
    },
    config = function()
      vim.keymap.set("n", "<leader>gn", ":Neogit kind=floating cwd=%:h<Cr>", { silent = true, desc = "Neogit Float" })
      vim.keymap.set("n", "<leader>gN", ":Neogit kind=replace cwd=%:h<Cr>", { silent = true, desc = "Neogit" })
    end,
  }
