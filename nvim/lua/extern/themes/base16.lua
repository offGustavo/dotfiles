return {
  "https://github.com/RRethy/base16-nvim",
  enabled = true,
  lazy = false,
  config = function ()
    -- colorscheme({
    --   dark = "base16-nord",
    --   light = "base16-nord-light"
    -- })

    colorscheme({
      dark = "base16-tokyo-night-dark",
      light = "base16-tokyo-night-light"
    })
    -- vim.cmd.colorscheme("base16-nord")
  end
}
