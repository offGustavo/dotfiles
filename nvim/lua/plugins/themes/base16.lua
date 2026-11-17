return {
  "https://github.com/RRethy/base16-nvim",
  enabled = true,
  lazy = false,
  config = function ()
    vim.cmd.colorscheme("base16-nord")
  end
}
