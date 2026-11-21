return {
  dir = "~/Projects/tatr.vim/",
  enabled = not is_windows(),
  lazy = true,
  cmd = { "TT", "Tatr" },
  init = function()
    vim.g.tatr_short_cmd = true
  end,
}
