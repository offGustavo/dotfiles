---@diagnostic disable vim
--- vim

-- vim: foldmethod=marker foldlevel=0

--{{{ -- Options --
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.g.plugin_enabled = true
vim.g.netrw_banner = 0
vim.g.snacks_animate = false

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = true
vim.o.laststatus = 3
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
vim.o.breakindent = true
vim.o.linebreak = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 50
vim.o.timeoutlen = 400
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.spell = false
vim.o.list = false
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.confirm = true
vim.o.wrap = false
vim.o.tabstop = 2      -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 2  -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 2   -- Number of spaces inserted when indenting
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmode = true
vim.o.showcmd = true
vim.o.showcmdloc = 'statusline'
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99
vim.o.swapfile = false
vim.o.path = vim.o.path .. "**"
vim.o.wildignore = vim.o.wildignore .. "**/node_modules/**"
-- vim.o.winborder = "rounded"
vim.cmd.colorscheme 'retrobox'

-- Experimental
require('vim._extui').enable({
  enable = true, -- Whether to enable or disable the UI.
  msg = {        -- Options related to the message module.
    ---@type 'cmd'|'msg' Where to place regular messages, either in the
    ---cmdline or in a separate ephemeral message window.
    target = 'msg',
    timeout = 2000, -- Time a message is visible in the message window.
  },
})

-- Better Grep and Find with ripgrep
if vim.fn.executable('rg') then
  vim.o.grepprg = "rg --vimgrep -. --smart-case -g '!.git' -g '!node_modules/'"
  function _G.RgFindFiles(cmdarg, _cmdcomplete)
    local fnames = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git" --glob="!node_modules/"')
    if #cmdarg == 0 then
      return fnames
    else
      return vim.fn.matchfuzzy(fnames, cmdarg)
    end
  end
  vim.o.findfunc = 'v:lua.RgFindFiles'
end

--}}}

--{{{ -- Keymaps --
vim.keymap.set({ 'n', "v", "i" }, '<C-s>', vim.cmd.write)

vim.keymap.set("n", "<leader>w", "<C-w>")

vim.keymap.set('v', '<C-k>', ":m '<-2<CR>gv=gv", { silent = true, desc = 'Move Line Up' })
vim.keymap.set('v', '<C-j>', ":m '>+1<CR>gv=gv", { silent = true, desc = 'Move Line Down' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { silent = true, desc = 'Go To Normal Mode in Terminal' })

vim.keymap.set('n', '<leader>qo', vim.cmd.copen, { desc = 'QuickFix Open', silent = true })
vim.keymap.set('n', '<leader>qc', vim.cmd.cclose, { desc = 'QuickFix Close', silent = true })

vim.keymap.set('n', '<leader>qq', vim.cmd.quit, { desc = 'Quit', silent = true })
vim.keymap.set('n', '<leader>qQ', ":qa!<Cr>", { desc = 'Force Quit All', silent = true })
vim.keymap.set('n', '<leader>qr', vim.cmd.restart, { desc = 'Restart', silent = true })

vim.keymap.set("n", "<leader>fc", ":e $MYVIMRC<Cr>", { silent = true })

vim.keymap.set('n', '<leader>bb', ':b #<Cr>', { desc = 'Alternative Buffer', silent = true })
vim.keymap.set("n", "<leader>bd", ":bd!<Cr>")
vim.keymap.set('n', '<leader>,', ':ls<Cr>:b! ')

vim.keymap.set('n', '<leader><Cr>', ':Ex<Cr>')
vim.keymap.set('n', '<leader>fd', ':Ex<Cr>')
vim.keymap.set('n', '<leader>e', ':Ex<Cr>')

vim.keymap.set('n', '<leader>sg', ':LiveGrep ')
vim.keymap.set('n', '<leader>/', ':grep ')

vim.keymap.set('n', '<leader><space>', ':find ')
vim.keymap.set('n', '<leader>ff', ':find ')

vim.keymap.set("n", "<leader>ll", function() vim.pack.update() end)
vim.keymap.set("n", "<leader>lg", ":term lazygit<Cr>:start<Cr>")

-- https://www.youtube.com/watch?v=UE6XQTAxwE0
vim.keymap.set("n", "<leader>fl", ":.lua<Cr>", { silent = true, desc = "Execute Line in Lua" })
vim.keymap.set("v", "<leader>fl", ":'<,'>lua<Cr>", { silent = true, desc = "Execute Selection in Lua" })

--}}}

--{{{ -- LSP --
-- lsp
--------------------------------------------------------------------------------
-- See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
-- of how the lsp setup works in neovim 0.11+.

-- This actually just enables the lsp servers.
-- The configuration is found in the lsp folder inside the nvim config folder,
-- so in ~.config/lsp/lua_ls.lua for lua_ls, for example.
vim.lsp.enable('lua_ls')
vim.lsp.enable('marksman')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable("ts_ls")

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end)
      vim.keymap.set('n', '<leader>ca', function()
        vim.lsp.buf.code_action()
      end, { desc = "Code Action" })
      vim.keymap.set('n', '<leader>cr', function()
        vim.lsp.buf.rename()
      end, { desc = "Code Action" })
      vim.keymap.set('n', '<leader>cf', function()
        vim.lsp.buf.format()
      end, { desc = "Code Format" })
      vim.keymap.set('n', '<leader>qd', function()
        vim.diagnostic.setqflist()
      end, { desc = 'Open Diagnostics Quickfix list' })
    end
  end,
})

-- Diagnostics
vim.diagnostic.config({
  -- Use the default configuration
  virtual_lines = false,
  virtual_text = true,

  -- signs = {
  --   text = {
  --     [vim.diagnostic.severity.ERROR] = "󰐼",
  --     [vim.diagnostic.severity.WARN] = "",
  --     [vim.diagnostic.severity.INFO] = "",
  --     [vim.diagnostic.severity.HINT] = "",
  --   }
  -- }
})
--}}}

--{{{ -- Autocmds --
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [Native Fuzzy Finder in Neovim With Lua and Cool Bindings :: Cherry's Blog](https://cherryramatis.xyz/posts/native-fuzzy-finder-in-neovim-with-lua-and-cool-bindings/)

vim.api.nvim_create_autocmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
  pattern = { '*' },
  group = vim.api.nvim_create_augroup('CmdlineAutocompletion', { clear = true }),
  callback = function(ev)
    vim.opt.wildmenu = true
    vim.opt.wildmode = 'noselect:lastused,full'

    if ev.event == 'CmdlineChanged' then
      vim.opt.wildmode = 'noselect:lastused,full'
      vim.schedule(function()
        vim.fn.wildtrigger()
      end)
    end

    if ev.event == 'CmdlineLeave' then
      vim.opt.wildmode = 'full'
    end
  end
})
-- [:grep with live updating quickfix list : r/neovim](https://www.reddit.com/r/neovim/comments/1n2ln9w/grep_with_live_updating_quickfix_list/)
vim.api.nvim_create_autocmd("CmdlineChanged", {
  callback = function()
    local cmdline = vim.fn.getcmdline()
    local words = vim.split(cmdline, " ", { trimempty = true })

    if words[1] == "LiveGrep" and #words > 1 then
      vim.cmd("silent grep! " .. vim.fn.escape(words[2], " "))
      vim.cmd("cwindow")
      vim.cmd.redraw()
    end
  end,
  pattern = ":",
})

--}}}

--{{{ -- Plugins --

  --{{{ Themes
  vim.pack.add {
    "https://github.com/folke/tokyonight.nvim",
  }
  require('tokyonight').setup {
    dim_inactive = false,
    style = "night",
    transparent = false,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
    on_colors = function(colors)
      colors.bg_statusline = colors
          .none -- To check if its working try something like "#ff00ff" instead of colors.none
      colors.bg_statusline = colors.none
    end,
  }
  vim.cmd.colorscheme 'tokyonight-night'
  --}}}

  --{{{ Mason LSP
  vim.pack.add { "https://github.com/williamboman/mason.nvim" }
  require("mason").setup()

  vim.pack.add { "https://github.com/neovim/nvim-lspconfig" }

  vim.pack.add { "https://github.com/mason-org/mason-lspconfig.nvim", }
  require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "rust_analyzer", "marksman" },
  })
  --}}}

  ---{{{ Treesitter
  vim.pack.add({
    {
      src = 'https://github.com/nvim-treesitter/nvim-treesitter',
      -- Git branch, tag, or commit hash
      version = 'main',
    },
  })

  require("nvim-treesitter").setup({
    folds = {
      enable = true,
    },
    ensure_installed = {
      'java',
      'javadoc',
      'bash',
      'c',
      'diff',
      'html',
      'css',
      'javascript',
      'jsdoc',
      'json',
      'jsonc',
      'lua',
      'luadoc',
      'luap',
      'markdown',
      'markdown_inline',
      'printf',
      'python',
      'query',
      'regex',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'xml',
      'yaml',
      'rust',
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<BS>",
      },
    },
    textobjects = {
      move = {
        enable = true,
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      },
    },
  })

  -- vim.cmd("TSUpdate")

  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "nvim_treesitter#foldexpr()"
  --}}}
