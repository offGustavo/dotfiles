--- Alias to vim.keymap.set
---@param k string
---@param f function|string
---@param o table
local nmap = function(k, f, o)
  vim.keymap.set("n", k, f, o)
end

nmap("<leader>gP", function()
  vim.cmd("!git pull")
end, { desc = "Pull Changes" })

nmap("<leader>gp", function()
  vim.cmd("!git push")
end, { desc = "Push Changes" })

nmap("<leader>ga", function()
  vim.cmd("!git add %")
end, { desc = "Git add current file" })

nmap("<leader>gA", function()
  vim.cmd("!git add .")
end, { desc = "Git add current directory" })
