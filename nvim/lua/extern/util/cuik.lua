return {
  -- "offGustavo/cuik.vim",
  dir = "~/Projects/cuik.vim/",
  -- enabled = not is_windows(),
  lazy = true,
  cmd = "CuikCompile",
  init = function()
    vim.g.cuik = {
      default_cmd = "grep -rn ",
      run_async = true,
      short_cmds = true,
    }
  end,
  keys = {
    { "<M-C>", "<Cmd>CuikCompile<Cr>" },
    { "<M-CR>", "<Cmd>CuikRecompile<Cr>" },
    { "<M-g><M-k>", "<Cmd>CuikKill<CR>" },
    { "<M-g><M-o>", "<Cmd>cope<Cr>" },
    { "<M-g><M-c>", "<Cmd>cclose<Cr>" },
    { "<M-g><M-n>", "<Cmd>cnext<Cr>" },
    { "<M-g><M-p>", "<Cmd>cprev<Cr>" },
  },
}
