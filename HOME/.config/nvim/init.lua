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
require("offGustavo.cuik")
require("Fish.git_branch").setup()

-- require("Tatr")
-- }}}

-- {{{ Lazy Plugins
require("config.lazy").add({

  -- -- add LazyVim and import its plugins
  -- { "LazyVim/LazyVim", import = "lazyvim.plugins" },

  -- -- import/override with your plugins
  -- { import = "plugins" },
  -- { import = "plugins.coding" },
  -- { import = "plugins.editor" },
  -- { import = "plugins.util" },
  -- { import = "plugins.coding" },
  -- { import = "plugins.themes" },
  -- { import = "plugins.ui" },
  -- { import = "plugins.general" },

  -- General
  { import = "plugins.mini" },
  -- { import = "plugins.snacks" },

  -- Theme
  { import = "plugins.tokyonight" },

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
  -- { import = "plugins.fugitive" },
  { import = "plugins.neogit" },

  -- Quickfix
  { import = "plugins.quicker" },

  -- LSP
  { import = "plugins.mason-lspconfig" },

  -- Treesitter
  { import = "plugins.treesitter" },

  -- Format
  { import = "plugins.conform" },

  -- Completion
  { import = "plugins.blink" },

  -- System
  -- { "https://github.com/tpope/vim-eunuch", lazy = true, event = "CmdLineEnter" },

  -- UI
  { import = "plugins.which-key" },
  -- { import =  "plugins.nvim-colorizer" },

  -- Agenda
  { import = "plugins.org-nvim" },
  { import = "plugins.orgmode" },

  -- Markdown
  -- { import = "plugins.markview" },
  -- { import = "plugins.md-agenda" },

  -- { import = "plugins.baleia" },

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
      { "<M-C>", ":CuikCompile " },
      { "<M-g><M-n>", ":cn<Cr>" },
      { "<M-g><M-p>", ":cp<Cr>" },
      { "<M-g><M-n>", ":cn<Cr>" },
    },
  },

  -- On Demand
  -- { "https://github.com/nstefan002/screenkey.nvim" },
})
-- }}}
