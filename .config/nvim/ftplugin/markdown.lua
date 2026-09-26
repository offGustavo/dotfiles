-- vim.cmd([[
-- let g:markdown_syntax_conceal = 0
-- let g:markdown_recommended_style = 0
-- let g:markdown_folding = 1
-- ]])

vim.lsp.enable("marksman")

map {
  -- TODO: Modificar esse atalho e adicionar uma função para fazer o "toggle" do TODO
  { "i", "<M-i><M-l>", "- [ ] ", buf = 0 },
  { "i", "<M-i><M-1>", "# TODO: ", buf = 0 },
  { "i", "<M-i><M-2>", "## TODO: ", buf = 0 },
  { "i", "<M-i><M-3>", "### TODO: ", buf = 0 },
  { "i", "<M-i><M-4>", "#### TODO: ", buf = 0 },
  { "i", "<M-i><M-5>", "##### TODO: ", buf = 0 },

  { "<localleader>ic", ":Editor create<Cr>", desc = "Create a code block", ft = "markdown" },
  { "<localleader>H", ":Headings increase<Cr>", desc = "Headings increase", ft = "markdown" },
  { "<localleader>h", ":Headings decrease<Cr>", desc = "Headings decrease", ft = "markdown" },
  { "<Cr>", "<Cmd>Checkbox toggle<Cr>", desc = "Checkbox", ft = "markdown" },
  { "<localleader>i<Cr>", ":Checkbox interactive<Cr>", desc = "Checkbox interactive", ft = "markdown" },
  { "<localleader>mm", "<Cmd>Markview Toggle<Cr>", desc = "Toggle Markview", ft = "markdown" },
  { "<localleader>mh", "<Cmd>Markview hybridToggle<Cr>", desc = "Toggle Hybrid Mode", ft = "markdown" },
  { "<localleader>ms", "<Cmd>Markview splitToggle<Cr>", desc = "Toggle Split View", ft = "markdown" },
}

vim.pack.add {
  "https://github.com/OXY2DEV/markview.nvim",
}

require("markview").setup({
  preview = {
    modes = { "n", "no", "c" },
    hybrid_modes = { "n", "i" },
    linewise_hybrid_mode = true,
  },
  latex = {
    enable = true,
  },
  -- list_items
  ---@diagnostic disable-next-line: missing-fields
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
require("markview.extras.checkboxes").setup()
require("markview.extras.headings").setup()
require("markview.extras.editor").setup()
