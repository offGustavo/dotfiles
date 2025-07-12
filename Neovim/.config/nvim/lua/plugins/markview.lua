return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  opts = {
    preview = {
      modes = { "n", "no", "c" },
      hybrid_modes = { "n" },
      linewise_hybrid_mode = true,
    },
    -- list_items
    list_items = {
      enable = true,
      wrap = false,
      indent_size = 2,
      shift_width = 4,
      marker_minus = {
        add_padding = true,
        conceal_on_checkboxes = true,
        text = "",
        hl = "MarkviewListItemMinus",
      },
      marker_plus = {
        add_padding = true,
        conceal_on_checkboxes = true,
        text = "",
        hl = "MarkviewListItemPlus",
      },
      marker_star = {
        add_padding = true,
        conceal_on_checkboxes = true,
        text = "",
        hl = "MarkviewListItemStar",
      },
      marker_dot = {
        add_padding = true,
        conceal_on_checkboxes = true,
      },
      marker_parenthesis = {
        add_padding = true,
        conceal_on_checkboxes = true,
      },
    },
  },
  keys = {
    { "<leader>omm", "<Cmd>Markview Toggle<Cr>", { desc = "Toggle Markview" } },
    { "<leader>omh", "<Cmd>Markview hybridToggle<Cr>", { desc = "Toggle Hybrid Mode" } },
    { "<leader>oms", "<Cmd>Markview splitToggle<Cr>", { desc = "Toggle Split View" } },
  },
}
