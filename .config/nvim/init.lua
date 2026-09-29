-- vim: foldmethod=marker
_G.Fish = {}

-- PERF:
vim.loader.enable()

-- {{{ Map Leader and Local Leader
-- <space> as leader
vim.g.mapleader = " "
-- <space><space> as local leader
vim.g.maplocalleader = "  "
-- }}}

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

-- {{{ Config Files
if os.getenv("SCROLL_MODE") then
  require("config.kitty_scroll_mode")
  return
end

require("config.functions")
-- require("config.autocmds")
-- require("config.commands")
-- require("config.options")
-- require("config.keymaps")
-- require("config.lsp")
if vim.g.neovide then
  require("config.neovide")
end

-- -- TODO: remover quando 0.13 ser estavel
-- if vim.fn.has("nvim-0.13") == 1 then
--   -- MultiCursor
--   require("config.multicursor")
-- end

-- -- Intern plugins
-- require("config.intern")

-- External plugins
-- require("config.lazy")
require("config.pack")

-- }}}

-- vim.pack.add({
--   "https://github.com/wurli/servery.nvim",
--   -- "https://github.com/chrisbra/csv.vim",
--   -- "https://github.com/hat0uma/csvview.nvim",
-- })

-- require("csvview").setup({
--   parser = { comments = { "#", "//" } },
--   keymaps = {
--     -- Text objects for selecting fields
--     textobject_field_inner = { "if", mode = { "o", "x" } },
--     textobject_field_outer = { "af", mode = { "o", "x" } },
--     -- Excel-like navigation:
--     -- Use <Tab> and <S-Tab> to move horizontally between fields.
--     -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
--     -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
--     jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
--     jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
--     jump_next_row = { "<Enter>", mode = { "n", "v" } },
--     jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
--   },
-- })

-- -- The following are the defaults - you don't need to change them
-- -- but you probably should at least set `dirs` and `ui.provider`.
-- require("servery").setup({
--   -- Either supply the directories as an array of strings, or a function
--   -- which returns an array. Shorthands like `~` are expanded.
--   dirs = { "~" }, ---@type string[] | fun(): string[]
--   session_dir = vim.fs.joinpath(cache_dir, "servery.nvim"),
--   ui = {
--     -- Options: "builtin" | "snacks" | "fzf" | "telescope" | "mini_pick"
--     provider = "fzf", ---@type servery.ui_provider
--     prompt = "Switch Nvim Session",
--     icons = {
--       current = "",
--       active = "",
--       inactive = "",
--     },
--     actions = {
--       ["<enter>"] = "switch",
--       ["<c-g>"] = "switch_and_detach",
--       ["<c-x>"] = "detach",
--       ["<c-s>"] = "spawn",
--     },
--     -- fzf-lua uses fzf's keymap notation, so it gets its own actions table
--     fzf_actions = {
--       ["enter"] = "switch",
--       ["ctrl-g"] = "switch_and_detach",
--       ["ctrl-x"] = "detach",
--       ["ctrl-s"] = "spawn",
--     },
--   },
-- })
