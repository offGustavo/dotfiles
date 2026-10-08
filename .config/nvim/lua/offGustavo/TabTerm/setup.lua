local tabterm = require("offGustavo.TabTerm")

tabterm.setup({
  -- Winbar Config
  separator_right = "",
  separator_left = "",
  separator_first = "",
  center = true,
  default_highlight = "%#Normal#",
  tab_highlight = "%#TablineSel#",
  -- Window Config
  vertical_size = 20,
  float = false,
  default_maps = true,
})

vim.keymap.set({ "n", "i", "x", "t" }, "<A-n>", function()
  tabterm.new()
end, { desc = "TabTerm New" })
vim.keymap.set({ "n", "i", "x", "t" }, "<A-z>", function()
  tabterm.close()
end, { desc = "TabTerm Close" })
vim.keymap.set({ "n", "i", "x", "t" }, "<A-/>", function()
  tabterm.toggle()
end, { desc = "TabTerm Toggle" })
for i = 1, 9, 1 do
  vim.keymap.set({ "n", "i", "x", "t" }, "<A-" .. i .. ">", function()
    tabterm.go(i)
  end, { desc = "TabTerm Toggle" })
end
