return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    ---@class snacks.animate.Config
    ---@field easing? snacks.animate.easing|snacks.animate.easing.Fn
    animate = {
      ---@type snacks.animate.Duration|number
      duration = 10, -- ms per step
      easing = "linear",
      fps = 60, -- frames per second. Global setting for all animations
    },
  },
}
