-- vim: foldmethod=marker

-- PERF:
vim.loader.enable()

_G.Fish = {}

-- Custom AuGroup
_G.fish_group = vim.api.nvim_create_augroup("Fish.config", {
  clear = false,
})

-- {{{ Set a temp theme here to prevent light/dark flicker and for kitty_scroll_mode
if vim.o.background == "dark" then
  vim.cmd.colorscheme("tokyo")
else
  vim.cmd.colorscheme("tokyo-day")
end
-- }}}

-- {{{ Config Files
require("config.functions")

if os.getenv("SCROLL_MODE") then
  source("kitty")
  return
end

require("config.options")
require("config.autocmds")
require("config.commands")
require("config.keymaps")
require("config.emacs")
require("config.lsp")
require("config.multicursor")
require("config.syntax_highlight")

if vim.g.neovide then
  require("config.neovide")
end
-- }}}

-- {{{ Local Plugins
require("offGustavo.espeto.setup")
require("offGustavo.lazygit")
require("offGustavo.TabTerm.setup")
require("offGustavo.todo-comments")
require("offGustavo.yazi")
-- require("offGustavo.compile-mode")
require("Fish.git_branch").setup()

-- require("Tatr")
-- }}}

-- {{{ Lazy Plugins
require("config.lazy").add({

  -- -- add LazyVim and import its plugins
  -- { "LazyVim/LazyVim", import = "lazyvim.plugins" },

  -- General
  { import = "plugins.general.mini" },
  -- { import = "plugins.general.snacks" },

  -- Theme
  { import = "plugins.themes.tokyonight" },

  -- File Explorer
  -- { import = "plugins.canola" },
  { import = "plugins.editor.oil" },
  -- { import = "plugins.editor.yazi" },
  -- { import = "plugins.vim-dirvish" },
  -- { import = "plugins.dired" },

  -- Picker
  { import = "plugins.editor.fzf-lua" },
  -- { import = "plugins.editor.telescope" },

  -- Git
  { import = "plugins.editor.fugitive" },
  -- { import = "plugins.editor.neogit" },

  -- Quickfix
  { import = "plugins.editor.quicker" },

  -- LSP
  { import = "plugins.coding.mason-lspconfig" },

  -- Treesitter
  { import = "plugins.coding.treesitter" },

  -- Format
  { import = "plugins.coding.conform" },

  -- Completion
  { import = "plugins.coding.blink" },

  -- System
  -- { "https://github.com/tpope/vim-eunuch", lazy = true, event = "CmdLineEnter" },

  -- UI
  { import = "plugins.ui.which-key" },
  -- { import =  "plugins.nvim-colorizer" },

  -- Agenda
  { import = "plugins.util.org-nvim" },
  { import = "plugins.util.orgmode" },

  -- Markdown
  -- { import = "plugins.ui.markview" },
  -- { import = "plugins.util.md-agenda" },

  -- { import = "plugins.ui.baleia" },

  -- My Plugins
  { dir = "~/Projects/nvim-sessionizer", lazy = false },

  { dir = "~/Projects/tatr.vim/", lazy = false  },

  {
    dir = "~/Projects/cuik.vim/",
    lazy = false,
    cmd = "CuikCompile",
    init = function()
      vim.g.cuik = {
        default_cmd = "grep -rn ",
        run_async = true,
        short_cuik_cmds = true,
      }
    end,
    keys = {
      { "<M-C>", ":CuikCompile<Cr>" },
      { "<M-CR>", ":CuikRecompile<Cr>" },
      { "<M-g><M-n>", ":cn<Cr>" },
      { "<M-g><M-p>", ":cp<Cr>" },
      { "<M-g><M-n>", ":cn<Cr>" },
    },
  },

  -- On Demand
  -- { "https://github.com/nstefan002/screenkey.nvim" },
})
-- }}}
