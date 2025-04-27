-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.snacks_animate = false

-- vim.opt.scrolloff = 999
vim.opt.scrolloff = 0

vim.o.wrap = false

vim.o.list = false

vim.opt.spelllang = { "pt_br", "en_us", "es" }

-- local function Winbar()
--   local normal_color = "%#Normal#"
--   local mode = "%-5{%v:lua.string.upper(v:lua.vim.fn.mode())%}"
--   local file_name = "%-.16t"
--   local buf_nr = "[%n]"
--   local modified = "%#MiniIconsRed% %-M"
--   local file_type = " %y"
--   local right_align = "%="
--   local line_no = "%10([%l/%L%)]"
--   local pct_thru_file = "%5p%%"
--   return string.format("%s%s%s", normal_color, file_name, modified)
-- end
-- vim.opt.winbar = Winbar()

----------------------
-- NEOVIDE          --
----------------------

if vim.g.neovide then
  vim.g.neovide_padding_top = 8
  vim.g.neovide_padding_bottom = 8
  vim.g.neovide_padding_right = 8
  vim.g.neovide_padding_left = 8
end
