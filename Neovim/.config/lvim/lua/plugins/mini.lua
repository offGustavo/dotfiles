vim.pack.add { 'https://github.com/echasnovski/mini.nvim' }

require("mini.ai").setup()
require("mini.surround").setup()
require("mini.icons").setup()

-- require("mini.files").setup()
-- vim.keymap.set("n", "<leader>ff", ":Pick files<Cr>")
--
-- require("mini.pick").setup()
-- vim.keymap.set("n", "<leader>fe", function() require("mini.files").open() end)
