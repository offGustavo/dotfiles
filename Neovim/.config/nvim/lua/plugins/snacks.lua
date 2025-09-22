return {
  "folke/snacks.nvim",
  opts = {
    -- indent = { enabled = false },
    -- scope = { enabled = false },
    explorer = {
      replace_netrw = false,
    },
    input = { enabled = false },
    picker = {
      -- layout = "ivy",
      -- layout = "telescope",
      -- layout = "ivy_split",
        layout = {
          preset = "ivy_split",
          hidden = { "preview" }, -- Isso esconde o preview inicialmente
        },
        preview = "main", -- Garante que o preview vai para a main window
      -- layout = {
      --   preview = false,
      --   layout = {
      --     box = "vertical",
      --     backdrop = false,
      --     width = 0,
      --     height = 0.4,
      --     position = "bottom",
      --     border = "top",
      --     title = " {title} {live} {flags}",
      --     title_pos = "left",
      --     { win = "input", height = 1, border = "none" },
      --     {
      --       box = "horizontal",
      --       { win = "list", border = "none" },
      --       { win = "preview", title = "{preview}", width = 0.6, border = "rounded" },
      --     },
      --   },
      -- },
      -- ui_select = false,
    },
    animate = {
      duration = 10, -- ms per step
      easing = "linear",
      fps = 60, -- frames per second. Global setting for all animations
    },
    -- scope = {
    -- enabled = false,
    -- },
  },
}
