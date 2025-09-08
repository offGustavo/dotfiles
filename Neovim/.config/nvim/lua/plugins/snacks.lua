return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      replace_netrw = false,
    },
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
  },
}
