return {
  "mbbill/undotree",
  config = function()
    vim.keymap.set("n", "<leader>ou", vim.cmd.UndotreeToggle, { desc = "Undo Tree Toggle" })
    vim.cmd([[
    let g:undotree_WindowLayout = 2
    let g:undotree_DiffAutoOpen = 1
      ]])
  end,
}
