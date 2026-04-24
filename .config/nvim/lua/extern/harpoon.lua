if true then return {} end

for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    require("harpoon"):list():select(i)
  end, { desc = "Go to " .. i .. " File" })
  vim.keymap.set("n", "<leader>h" .. i, function()
    require("harpoon"):list():replace_at(i)
  end, { desc = "Add File to " .. i })
end

return {
  "https://github.com/ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "https://github.com/nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")
    harpoon.setup({
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    })

    local harpoon_extensions = require("harpoon.extensions")
    harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
  end,
  keys = {
    { "<leader>ha", function() require("harpoon"):list():add() end,                                    desc = "Harpoon File" },
    { "<leader>he", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon Quick Menu" }

  },
}
