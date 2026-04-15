require("forge.yazi").setup({
  enable_cmds = true,
  replace_netrw = true,
  ui = {
    border = "rounded",
    height = 0.9,
    width = 0.9,
    x = 0.5,
    y = 0.5,
  },
  keybindings = {},
})

vim.schedule(function ()
-- require("forge.easymode")

-- require("forge.espeto").setup()

-- vim.keymap.set("n", "<leader>v", function()
--   require("forge.vidir").open()
-- end)

-- require("forge.statusline")

-- require("forge.tabline")

require("forge.compile").setup()

require("forge.commands")

vim.keymap.set("n", "<M-e>", ":Yazi<CR>")

vim.keymap.set("n", "<M-S-g>", ":Lazygit<CR>")
require("forge.lazygit").setup({
    ui = {
        border = "rounded",
        height = 0.9,
        width = 0.9,
    },
    keybindings = {
        -- ["<C-h>"] = "<C-\\><C-n><C-w>h", -- navigate left
        -- ["<C-l>"] = "<C-\\><C-n><C-w>l", -- navigate right
    },
    on_exit = function()
        vim.cmd("checktime") -- refresh buffers if files changed
    end,
    enable_cmds = true,
})


local TabTerm = require("forge.tabterm")
TabTerm.setup({
    -- Winbar Config
    separator_right = "",
    separator_left = "",
    separator_first = "",
    center = true,
    default_highlight = "%#Tabline#",
    tab_highlight = "%#TablineSel#",
    -- Window Config
    vertical_size = 20,
    float = false,
})
-- Define Keys
vim.keymap.set({ "n", "i", "x", "t" }, "<A-n>", function()
    TabTerm.new()
end, { desc = "TabTerm New" })
vim.keymap.set({ "n", "i", "x", "t" }, "<A-z>", function()
    TabTerm.close()
end, { desc = "TabTerm Close" })
vim.keymap.set({ "n", "i", "x", "t" }, "<A-/>", function()
    TabTerm.toggle()
end, { desc = "TabTerm Toggle" })
for i = 1, 9, 1 do
    vim.keymap.set({ "n", "i", "x", "t" }, "<A-" .. i .. ">", function()
        TabTerm.go(i)
    end, { desc = "TabTerm Toggle" })
end


local toggle = require('forge.toggle')
-- vim.keymap.set('n', '<C-a>', function() toggle.increase() end)
-- vim.keymap.set('n', '<C-x>', function() toggle.decrease() end)
vim.keymap.set('n', '<leader>tt', function() toggle.toggle() end)
end)
