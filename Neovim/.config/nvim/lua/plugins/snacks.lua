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
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
          explorer = { hidden = true },
        },
      layout = {
        preview = false,
        layout = {
          box = "vertical",
          backdrop = false,
          row = -1,
          width = 0,
          height = 0.4,
          border = "top",
          title = " {title} {live} {flags}",
          title_pos = "left",
          { win = "input", height = 1, border = "none" },
          {
            box = "horizontal",
            { win = "list", border = "none" },
            { win = "preview", width = 0.6, border = "rounded" },
          },
        },
      },
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
