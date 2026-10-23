vim.api.nvim_create_user_command("Compile", function(o)
  require "Fish.compile".compile(o.args)
end, { nargs = "*", complete = "shellcmd" })

vim.api.nvim_create_user_command("Recompile", function()
  require "Fish.compile".recompile()
end, { nargs = 0 })

vim.keymap.set("n", "<M-C>", "<Cmd>Compile<Cr>", { desc = "Compile" })
vim.keymap.set("n", "<M-CR>", "<Cmd>Recompile<Cr>", { desc = "Recompile" })
