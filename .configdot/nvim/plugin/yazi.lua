vim.g.loaded_netrwPlugin = 1
-- (Obtain yazi.nvim and its dependencies using your preferred method first)
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/mikavilpas/yazi.nvim",
})
-- Next, map a key to open yazi.nvim
vim.keymap.set("n", "<M-e>", function()
  require("yazi").yazi()
end)

-- 👇 if you use `open_for_directories=true`, this is recommended.
--
-- mark netrw as loaded so it's not loaded at all.
-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
vim.g.loaded_netrwPlugin = 1
require("yazi").setup({
  open_for_directories = true,
})
