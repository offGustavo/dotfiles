-- Smart increase/decrease
vim.keymap.set("n", "<C-a>", function()
  require("forge.toggle").increase()
end, { desc = "Inrease numbers and words" })
vim.keymap.set("n", "<C-x>", function()
  require("forge.toggle").decrease()
end, { desc = "Inrease numbers and words" })

vim.keymap.set("n", "<leader>tt", function()
  require("forge.toggle").toggle()
end, { desc = "Toggle Value" })

vim.keymap.set("n", "<leader>uc", function()
  -- vim.o.conceallever = not vim.opt.conceallevel:get()
  vim.print("TODO: set conceallevel!")
end, {
  desc = "set conceallevel!"
})

vim.keymap.set("n", "<leader>ul", function()
  vim.o.cursorline = not vim.opt.cursorline:get()
end, {
  desc = "set cursorline!"
})

vim.keymap.set("n", "<leader>un", function()
  vim.o.number = not vim.opt.number:get()
end, {
  desc = "set number!"
})

vim.keymap.set("n", "<leader>ur", function()
  vim.o.relativenumber = not vim.opt.relativenumber:get()
end, {
  desc = "set relativenumber!"
})

vim.keymap.set("n", "<leader>uw", function()
  vim.o.wrap = not vim.opt.wrap:get()
end, {
  desc = "set wrap!"
})

vim.keymap.set("n", "<leader>us", function()
  vim.o.spell = not vim.opt.spell:get()
end, {
  desc = "set spell!"
})

vim.keymap.set("n", "<leader>ub", function()
  if vim.opt.backgroung:get() == "light" then
    vim.o.background = "dark"
    return
  end
  vim.o.background = "light"
end, {
  desc = "set bg!"
})

vim.keymap.set("n", "<leader>ud", function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
    return
  end
  vim.diagnostic.enable(true)
end, {
  desc = "set vim.diagnostic.enable()!"
})

vim.keymap.set("n", "<leader>ut", function()
  local state = vim.b.ts_highlight
  if state then
    vim.treesitter.stop(0)
    return
  end
  vim.treesitter.start(0)
end, {
  desc = "set vim.treesitter()!",
})

vim.keymap.set("n", "<leader>ui", function()
  vim.o.list = not vim.opt.list:get()
end, {
  desc = "set list!",
})

