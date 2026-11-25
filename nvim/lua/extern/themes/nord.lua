return {
  "https://github.com/shaunsingh/nord.nvim",
  lazy = true,
  event = "VeryLazy",
  config = function()
    colorscheme({
      dark = "nord",
      light = "default",
    })
  end,
}


--   return {
--   "dupeiran001/nord.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("nord").setup()
--     colorscheme({
--       dark = "nord",
--       light = "default",
--     })
--   end,
-- }
