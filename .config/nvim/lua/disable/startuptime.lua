-- if true then return {} end
return {
  lazy = true,
  event = "VeryLazy",
  "https://github.com/dstein64/vim-startuptime",
  config = function()
    vim.g.startuptime_tries = 10
  end,
}



