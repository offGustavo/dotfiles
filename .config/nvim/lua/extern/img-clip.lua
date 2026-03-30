return {
  "HakonHarnes/img-clip.nvim",
  -- event = "VeryLazy",
  ft = { "Markdown", "md" },
  lazy = true,
  opts = {
  -- add options here
  -- or leave it empty to use the default settings
  default = {
    -- file and directory options
    dir_path = "assets", ---@type string | fun(): string
    use_absolute_path = false, ---@type boolean | fun(): boolean
  },
  },
  keys = {
    -- suggested keymap
    -- { "<localleader>ip", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard", ft = { "Markdown", "md" }, },
  },
}
