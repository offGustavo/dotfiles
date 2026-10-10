return {
  "https://github.com/dstein64/vim-startuptime",
  enabled = false,
  cmd = "StartupTime",
  init = function()
    vim.g.startuptime_tries = 10
  end
}
