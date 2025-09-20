return {
  "folke/snacks.nvim",
  opts = {
    -- indent = { enabled = false },
    -- scope = { enabled = false },
    explorer = {
      replace_netrw = false,
      layout = "ivy",
    },
    input = { enabled = false },
    picker = {
      -- layout = "ivy",
      -- layout = "telescope",
      layout = "ivy_split",
    },
    animate = {
      duration = 10, -- ms per step
      easing = "linear",
      fps = 60, -- frames per second. Global setting for all animations
    },
    scope = {
      enabled = false
    },
  },
}
