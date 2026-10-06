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
end)
