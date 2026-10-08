local espeto = require("offGustavo.espeto")
local map = vim.keymap.set
local prefix = "<leader>"

espeto.setup()

map("n", prefix .. "ha", espeto.add,    { desc = "Espeto: add file" })
map("n", prefix .. "hd", function() espeto.remove() end, { desc = "Espeto: remove current file" })
map("n", prefix .. "he", espeto.menu,   { desc = "Espeto: quick menu" })
map("n", prefix .. "hn", espeto.next,   { desc = "Espeto: next file" })
map("n", prefix .. "hp", espeto.prev,   { desc = "Espeto: previous file" })

for i = 1, 9 do
  map("n", prefix .. i, function() espeto.select(i) end, { desc = "Espeto: go to file " .. i })
end

-- local map = vim.keymap.set
-- local prefix = "<leader>"
--
-- for i = 1, 9 do
--   map("n", prefix .. i, function()
--     require("Fish.espeto").go(i)
--   end, { desc = "Go to file " .. i })
-- end
--
-- for i = 1, 9 do
--   map("n", prefix .. "h" .. i, function()
--     local buf = vim.api.nvim_get_current_buf()
--     local path = vim.api.nvim_buf_get_name(buf)
--     if path == "" then
--       vim.notify("No File", vim.log.levels.ERROR)
--       return
--     end
--     require("Fish.espeto").set(i, path)
--   end, { desc = "Espeto: add file in " .. i })
-- end
--
-- for i = 1, 9 do
--   map("n", prefix .. "hd" .. i, function()
--     require("Fish.espeto").remove(i)
--   end, { desc = "Espeto: delete file in " .. i })
-- end
--
-- map("n", prefix .. "he", require("Fish.espeto").list, { desc = "Espeto: list files" })
--
-- map("n", prefix .. "ha", function()
--   local buf = vim.api.nvim_get_current_buf()
--   local path = vim.api.nvim_buf_get_name(buf)
--   if path == "" then
--     vim.notify("Buffer sem nome", vim.log.levels.ERROR)
--     return
--   end
--   require("Fish.espeto").add(path)
-- end, { desc = "Espeto: add file" })
--
-- map {
--   { "n", "<leader>{i}", "<Cmd>Espeto {i}", range = { 1, 9 }, desc = "Go to file {i}" }
--
-- }
--
--
-- require("Fish.espeto").load()
