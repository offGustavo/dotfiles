return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  -- enabled = false,
  priority = 49,
  keys = {
    { "<leader>omm", "<Cmd>Markview Toggle<Cr>", { desc = "Toggle Markview" } },
    { "<leader>omh", "<Cmd>Markview hybridToggle<Cr>", { desc = "Toggle Hybrid Mode" } },
    { "<leader>oms", "<Cmd>Markview splitToggle<Cr>", { desc = "Toggle Split View" } },
  },
  config = function()
    -- Load the checkboxes module.
    require("markview.extras.checkboxes").setup()
    require("markview.extras.headings").setup()
    require("markview").setup({
    preview = {
      modes = { "n", "no", "c" },
      hybrid_modes = { "n" },
      linewise_hybrid_mode = true,
    },
    latex = {
      enable = false,
    },
    -- list_items
    markdown = {
      list_items = {
        enable = true,
        wrap = false,
        indent_size = 2,
        shift_width = 4,
        marker_minus = {
          add_padding = true,
          conceal_on_checkboxes = true,
          text = "-",
          hl = "MarkviewListItemMinus",
        },
        marker_plus = {
          add_padding = true,
          conceal_on_checkboxes = true,
          text = "+",
          hl = "MarkviewListItemPlus",
        },
        marker_star = {
          add_padding = true,
          conceal_on_checkboxes = true,
          text = "*",
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
  })
    -- require("markview.extras.editor").setup();
  end,
}
