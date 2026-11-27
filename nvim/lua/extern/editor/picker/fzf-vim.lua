return {
  "https://github.com/junegunn/fzf.vim",
  enable = false,
  lazy = true,
  event = "VeryLazy",
  dependencies = "junegunn/fzf",
  keys = {
    { "<M-o>", ":Files<CR>" },
    {
      "<leader>fc",
      function()
        vim.cmd("Files " .. vim.fn.stdpath("config"))
      end,
    },

    { "<M-s>", ":Rg<CR>" },
    { "<leader>sg", ":Rg<CR>" },
    { "<leader>sb", ":BLines<CR>" },

    { "<M-b>", ":Buffers<CR>" },
    { "<leader>bs", ":Lines<CR>" },

    { "<leader>sh", ":Help<CR>" },
  },
}
