vim.schedule(function()

  vim.cmd.packadd("plenary.nvim")
  vim.cmd.packadd("codediff.nvim")
  vim.cmd.packadd("neogit")

  vim.keymap.set("n", "<M-S-g>", "<Cmd>Neogit kind=replace<Cr>", { desc = "Neogit" })
end)
