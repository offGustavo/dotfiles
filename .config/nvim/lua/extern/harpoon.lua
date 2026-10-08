later(function()
  packadd("plenary.nvim")
  packadd("harpoon")

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

  map {
    {
      "n",
      "<leader>ha",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Harpoon File",
    },
    {
      "n",
      "<leader>he",
      function()
        require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
      end,
      desc = "Harpoon Quick Menu",
    },
    {
      "n",
      "<leader>{i}",
      ":lua require('harpoon'):list():select({i})<Cr>",
      range = { 1, 9 },
      desc = "Harpoon to File {i}",
    },

    {
      "n",
      "<leader>h{i}",
      ":lua require('harpoon'):list():replace_at({i})<Cr>",
      desc = "Add {i}",
      range = { 1, 9 },
    },
  }
end)
