return {
    "https://github.com/tpope/vim-fugitive",
    enabled = true,
    lazy = true,
    cmd = { "G", "Git" },
    init = function()
      vim.g.fugitive_legacy_commands = true
    end,
    keys = {
      { "<M-G>", ":Git<Cr>" },
      { "<leader>gl", ":Git log<Cr>" },
      { "<space>ga", ":Git add %:p<CR><CR>" },
      { "<space>gc", ":Gcommit -v -q<CR>" },
      { "<space>gt", ":Gcommit -v -q %:p<CR>" },
      { "<space>gd", ":Gdiff<CR>" },
      { "<space>ge", ":Gedit<CR>" },
      { "<space>gr", ":Gread<CR>" },
      { "<space>gw", ":Gwrite<CR><CR>" },
      { "<space>gl", ":silent! Glog<CR>:bot copen<CR>" },
      { "<space>gp", ":Ggrep<Space>" },
      { "<space>gm", ":Gmove<Space>" },
      { "<space>gb", ":Git branch<Space>" },
      { "<space>go", ":Git checkout<Space>" },
      { "<space>gps", ":Dispatch! git push<CR>" },
      { "<space>gpl", ":Dispatch! git pull<CR>" },
    },
  }

