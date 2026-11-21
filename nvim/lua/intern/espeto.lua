local espeto = require("offGustavo.espeto")
local map = vim.keymap.set

espeto.setup()

map("n", "<leader>ha", espeto.add,    { desc = "Add File" })
map("n", "<leader>hd", function() espeto.remove() end, { desc = "Remove Current File" })
map("n", "<leader>he", espeto.menu,   { desc = "Quick Menu" })
map("n", "<leader>hn", espeto.next,   { desc = "Next File" })
map("n", "<leader>hp", espeto.prev,   { desc = "Previous File" })
for i = 1, 9 do
  map("n", "<leader>" .. i, function() espeto.select(i) end, { desc = "Go to File " .. i })
end
