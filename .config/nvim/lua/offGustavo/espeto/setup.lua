local espeto = require("offGustavo.espeto")
local map = vim.keymap.set

espeto.setup()

map("n", "<leader>ha", espeto.add,    { desc = "Espeto: add file" })
map("n", "<leader>hd", function() espeto.remove() end, { desc = "Espeto: remove current file" })
map("n", "<leader>he", espeto.menu,   { desc = "Espeto: quick menu" })
map("n", "<leader>hn", espeto.next,   { desc = "Espeto: next file" })
map("n", "<leader>hp", espeto.prev,   { desc = "Espeto: previous file" })
for i = 1, 9 do
  map("n", "<leader>" .. i, function() espeto.select(i) end, { desc = "Espeto: go to file " .. i })
end
