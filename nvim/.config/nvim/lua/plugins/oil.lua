return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- keys = {
  --   {
  --     "<leader><Cr>",
  --     function()
  --       require("oil").open()
  --     end,
  --     desc = "[F]ormat buffer",
  --   },
  -- },
  opts = {
    default_file_explorer = false,
    view_options = {
      show_hidden = true,
    },
  },
}
