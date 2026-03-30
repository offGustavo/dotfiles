if true then return {} end
return {
    "OXY2DEV/markview.nvim",
    -- For some reason we should't lazy loaded this.
    lazy = true,
    ft = { "Markdown", "md" },
    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
    opts = {
    preview = {
      modes = { "n", "no", "c" },
      hybrid_modes = { "n", "i" },
      linewise_hybrid_mode = true,
    },
    latex = {
      enable = true,
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
  },
};
