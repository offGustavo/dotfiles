local map, new_command = vim.keymap.set, vim.api.nvim_create_user_command

new_command("Compile", function(o)
  require "Fish.compile".compile(o.args)
end, { nargs = "*", complete = "shellcmd" })

new_command("Recompile", function()
  require "Fish.compile".recompile()
end, { nargs = 0 })

map("n", "<M-C>", "<Cmd>Compile<Cr>", { desc = "Compile" })
map("n", "<M-CR>", "<Cmd>Recompile<Cr>", { desc = "Recompile" })
