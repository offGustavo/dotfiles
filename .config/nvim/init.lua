-- Our Global thing
_G.Fish = {}

-- PERF:
vim.loader.enable()

-- {{{ Set a temp theme here to prevent light/dark flicker
if vim.o.background == "dark" then
  vim.cmd.colorscheme("tokyo")
else
  vim.cmd.colorscheme("tokyo-day")
end
-- }}}

-- {{{ Security Things
vim.o.modeline = true
vim.o.exrc = false
--- }}}

-- {{{ Disable Plugins
-- disable custom nix/arch fzf.vim
vim.cmd("let g:loaded_fzf = 1")
-- }}}

-- Config Files
if os.getenv("SCROLL_MODE") then
  require("config.kitty_scroll_mode")
  return
end

require("config.autocmds")
require("config.functions")
require("config.commands")
require("config.options")
require("config.keymaps")
require("config.lsp")
require("config.neovide")

-- TODO: remover quando 0.13 ser estavel
if vim.fn.has("nvim-0.13") == 1 then
  -- MultiCursor
  require("config.multicursor")
end

-- Intern plugins
require("config.intern")

-- External plugins
require("config.lazy")
-- require("config.pack")
