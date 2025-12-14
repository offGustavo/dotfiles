-- vim: foldmethod=marker foldlevel=0

--{{{ -- Options
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
-- vim.g.netrw_banner = 0
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
vim.o.tabstop = 2 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 2 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 2 -- Number of spaces inserted when indenting
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmode = true
vim.o.showcmd = true
vim.o.showcmdloc = 'statusline'
vim.o.foldmethod = 'indent'
vim.o.foldlevel = 99
vim.o.swapfile = false
vim.o.path = vim.o.path .. '**'
vim.o.wildignore = vim.o.wildignore .. '**/node_modules/**'
vim.o.termguicolors = false
vim.o.autocomplete = true
--[Neovim native, built-in, LSP autocomplete · Tomas Vik](https://blog.viktomas.com/graph/neovim-native-built-in-lsp-autocomplete/)
-- prevent the built-in vim.lsp.completion autotrigger from selecting the first item
vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }
-- vim.o.acd = true
-- vim.cmd([[
-- autocmd BufEnter * lcd %:p:h
-- ]])

require('vim._extui').enable({
  enable = true, -- Whether to enable or disable the UI.
  msg = {        -- Options related to the message module.
    ---@type 'cmd'|'msg' Where to place regular messages, either in the
    ---cmdline or in a separate ephemeral message window.
    target = 'cmd',
    timeout = 2000, -- Time a message is visible in the message window.
  },
})

-- Better Grep and Find with ripgrep
if vim.fn.executable 'rg' then
  vim.o.grepprg = "rg --vimgrep -. --smart-case -g '!.git' -g '!node_modules/'"

  -- [Native Fuzzy Finder in Neovim With Lua and Cool Bindings :: Cherry's Blog](https://cherryramatis.xyz/posts/native-fuzzy-finder-in-neovim-with-lua-and-cool-bindings/)
  function _G.RgFindFiles(cmdarg, _cmdcomplete)
    local fnames = vim.fn.systemlist 'rg --files --hidden --color=never --glob="!.git" --glob="!node_modules/"'
    if #cmdarg == 0 then
      return fnames
    else
      return vim.fn.matchfuzzy(fnames, cmdarg)
    end
  end

  vim.o.findfunc = 'v:lua.RgFindFiles'
end

--}}}

--{{{ -- Keymaps
vim.keymap.set({ 'n', 'v', 'i' }, '<C-s>', vim.cmd.update)

vim.keymap.set('n', '<leader>w', '<C-w>')

vim.keymap.set('v', '<C-k>', ":m '<-2<CR>gv=gv", { silent = true, desc = 'Move Line Up' })
vim.keymap.set('v', '<C-j>', ":m '>+1<CR>gv=gv", { silent = true, desc = 'Move Line Down' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { silent = true, desc = 'Go To Normal Mode in Terminal' })

vim.keymap.set('n', '<leader>qo', vim.cmd.copen, { desc = 'QuickFix Open', silent = true })
vim.keymap.set('n', '<leader>qc', vim.cmd.cclose, { desc = 'QuickFix Close', silent = true })

vim.keymap.set('n', '<leader>qq', vim.cmd.quit, { desc = 'Quit', silent = true })
vim.keymap.set('n', '<leader>qQ', ':qa!<Cr>', { desc = 'Force Quit All', silent = true })
vim.keymap.set('n', '<leader>qr', vim.cmd.restart, { desc = 'Restart', silent = true })

vim.keymap.set('n', '<leader>fc', ':e $MYVIMRC<Cr>', { silent = true })
vim.keymap.set('n', '<leader>hdc', ':e $MYVIMRC<Cr>', { silent = true })

vim.keymap.set('n', '<leader>bb', ':b #<Cr>')
vim.keymap.set('n', '<leader>bd', ':bd!<Cr>')
vim.keymap.set('n', '<leader>,', ':ls<Cr>:b! ')

vim.keymap.set('n', '<leader>fd', ':Ex<Cr>')
vim.keymap.set('n', '<leader>fe', ':Ex<Cr>')
vim.keymap.set('n', '<leader>e', ':Ex<Cr>')
vim.keymap.set('n', '<leader>.', ':Ex<Cr>')
vim.keymap.set('n', '<leader><space>', ':find ')
vim.keymap.set('n', '<leader>ff', ':find ')
vim.keymap.set('n', '<leader>of', ':find ')
vim.keymap.set('n', '<leader>fF', ':find <C-R>=expand("%:h")<CR>/')
vim.keymap.set('n', '<leader>sg', ':grep ')
vim.keymap.set('n', '<leader>og', ':grep ')
vim.keymap.set('n', '<leader>sG', ':grep  %:h<left><left><left><left>')
vim.keymap.set('n', '<leader>/', ':LiveGrep  %:h<left><left><left><left>') -- Custom Autocmd
vim.keymap.set('n', '<leader>o/', ':LiveGrep  %:h<left><left><left><left>') -- Custom Autocmd

vim.keymap.set('n', '<leader>sw', ':grep <cword><Cr>')
vim.keymap.set('n', '<leader>sW', ':grep <cword> %:h<Cr>')
vim.keymap.set('n', '<leader>ow', ':grep <cWORD><Cr>')
vim.keymap.set('n', '<leader>oW', ':grep <cWORD> %:h<Cr>')

vim.keymap.set('n', '<leader>z', ':cd ')

vim.keymap.set('n', '<leader>tn', ':term ')

vim.keymap.set('n', '<leader>lg', ':term lazygit<Cr>:start<Cr>')
vim.keymap.set('n', '<leader>lu', function()
  vim.pack.update {}
end)
vim.keymap.set('n', '<leader>lx', function()
  vim.pack.del {}
end)
vim.keymap.set('n', '<leader>le', function()
  vim.cmd("e ~/.local/share/lvim/site/pack/core/opt/")
end)

-- [How to Use vim.pack - NeoVim's built-in Plugin Manager in Neovim 0.12+ - YouTube](https://www.youtube.com/watch?v=UE6XQTAxwE0)
vim.keymap.set('n', '<leader>fl', ':.lua<Cr>', { silent = true, desc = 'Execute Line in Lua' })
vim.keymap.set('v', '<leader>fl', ":'<,'>lua<Cr>", { silent = true, desc = 'Execute Selection in Lua' })

-- Poor man harpoon
vim.keymap.set('n', '<leader>ha', function()
  vim.cmd 'argadd %'
  vim.cmd 'argdedup'
end)

vim.keymap.set('n', '<leader>hd', function()
  vim.cmd 'argd %'
end)

-- assign arg to each number
for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, '<CMD>argu ' .. i .. '<CR>', { silent = true, desc = 'Go to arg ' .. i })
  vim.keymap.set('n', '<leader>h' .. i, '<CMD>' .. i - 1 .. 'arga<CR>',  { silent = true, desc = 'Add current to arg ' .. i })
  vim.keymap.set('n', '<leader>d' .. i, '<CMD>' .. i .. 'argd<CR>', { silent = true, desc = 'Delete current arg' })
end

-- to qf
vim.keymap.set('n', '<leader>he', function()
  local list = vim.fn.argv()
  if #list > 0 then
    local qf_items = {}
    for _, filename in ipairs(list) do
      table.insert(qf_items, {
        filename = filename,
        lnum = 1,
        text = filename,
      })
    end
    vim.fn.setqflist(qf_items, 'r')
    vim.cmd.copen()
  end
end, { silent = true, desc = 'Show args in qf' })

-- Convert quickfix list to argument list
vim.keymap.set('n', '<leader>hq', function()
  local qf_list = vim.fn.getqflist()
  if #qf_list == 0 then
    vim.notify("Quickfix list is empty", vim.log.levels.WARN)
    return
  end
  -- Clear current argument list
  vim.cmd '%argdelete'
  -- Add each quickfix item to argument list
  for _, item in ipairs(qf_list) do
    if item.filename and item.filename ~= '' then
      -- Use absolute path to avoid issues
      local filename = vim.fn.fnamemodify(item.filename, ':p')
      vim.cmd('argadd ' .. vim.fn.fnameescape(filename))
    elseif item.bufnr and vim.fn.bufexists(item.bufnr) > 0 then
      -- If we have a buffer number but no filename, use buffer name
      local bufname = vim.fn.bufname(item.bufnr)
      if bufname and bufname ~= '' then
        local filename = vim.fn.fnamemodify(bufname, ':p')
        vim.cmd('argadd ' .. vim.fn.fnameescape(filename))
      end
    end
  end
  -- Remove duplicates
  vim.cmd 'argdedup'
  vim.notify(string.format("Added %d files from quickfix to argument list", #qf_list))
end, { silent = true, desc = 'Quickfix to args' })

--}}}

--{{{ -- Autocmds
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
  end,
})

-- [:grep with live updating quickfix list : r/neovim](https://www.reddit.com/r/neovim/comments/1n2ln9w/grep_with_live_updating_quickfix_list/)
vim.api.nvim_create_autocmd('CmdlineChanged', {
  callback = function()
    local cmdline = vim.fn.getcmdline()
    local words = vim.split(cmdline, ' ', { trimempty = true })

    if words[1] == 'LiveGrep' or words[1] == 'live' and #words > 1 then
      vim.cmd('silent grep! ' .. vim.fn.escape(words[2], ' '))
      vim.cmd 'cwindow'
      vim.cmd.redraw()
    end
  end,
  pattern = ':',
})

-- https://stackoverflow.com/questions/42905008/quickfix-list-how-to-add-and-remove-entries
vim.cmd[[
" When using `dd` in the quickfix list, remove the item from the quickfix list.
function! RemoveQFItem()
let curqfidx = line('.') - 1
let qfall = getqflist()
call remove(qfall, curqfidx)
call setqflist(qfall, 'r')
execute curqfidx + 1 . "cfirst"
:copen
endfunction
:command! RemoveQFItem :call RemoveQFItem()
" Use map <buffer> to only map dd in the quickfix window. Requires +localmap
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>
]]

-- Função para remover item atual da Location List
local function remove_loc_item()
  local curidx = vim.fn.line(".") - 1
  local winid = vim.fn.win_getid()

  -- Pega a lista local da janela
  local loclist = vim.fn.getloclist(winid)

  if #loclist == 0 then
    vim.notify("Location List vazia", vim.log.levels.WARN)
    return
  end

  -- Remove o item atual
  table.remove(loclist, curidx + 1)

  -- Atualiza a loclist com a nova lista
  vim.fn.setloclist(winid, loclist, "r")

  -- Reabre para atualizar a janela
  vim.cmd.lwindow()
end

-- Cria comando para remover
vim.api.nvim_create_user_command("RemoveLocItem", remove_loc_item, {})

-- Autocmd: quando abrir uma janela de loclist, mapear `dd`
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(args)
    local wininfo = vim.fn.getwininfo(vim.fn.win_getid())[1]
    if wininfo and wininfo.loclist == 1 then
      vim.api.nvim_buf_set_keymap(
        args.buf,
        "n",
        "dd",
        ":RemoveLocItem<CR>",
        { noremap = true, silent = true }
      )
    end
  end,
})

--}}}

--{{{ -- LSP Config
-- lsp
--------------------------------------------------------------------------------
-- See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
-- of how the lsp setup works in neovim 0.11+.
-- This actually just enables the lsp servers.
-- The configuration is found in the lsp folder inside the nvim config folder,
-- so in ~.config/lsp/lua_ls.lua for lua_ls, for example.
vim.lsp.enable 'lua_ls'
vim.lsp.enable 'marksman'
vim.lsp.enable 'rust_analyzer'
vim.lsp.enable 'ts_ls'
vim.lsp.enable 'bash_ls'
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
      end, { desc = 'Code Action' })
      vim.keymap.set('n', '<leader>cr', function()
        vim.lsp.buf.rename()
      end, { desc = 'Code Action' })
      vim.keymap.set('n', '<leader>cf', function()
        vim.lsp.buf.format()
      end, { desc = 'Code Format' })
      vim.keymap.set('n', '<leader>qd', function()
        vim.diagnostic.setqflist()
      end, { desc = 'Open Diagnostics Quickfix list' })
    end
  end,
})
-- Diagnostics
vim.diagnostic.config {
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
}
--}}}

--{{{ -- Plugins
local plugins = {
  'https://github.com/folke/tokyonight.nvim',
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
  },
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
  },
  'https://github.com/echasnovski/mini.nvim',
  "https://github.com/offGustavo/TabTerm.nvim",
  "https://github.com/offGustavo/nvim-sessionizer",
  {
    src = 'https://github.com/ThePrimeagen/harpoon',
    -- Git branch, tag, or commit hash
    version = 'harpoon2',
  },
  "https://github.com/OXY2DEV/markview.nvim",
  "https://github.com/zenarvus/md-agenda.nvim",
  "https://github.com/santhosh-tekuri/picker.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/NeogitOrg/neogit",
  "https://github.com/stevearc/oil.nvim",
  {
    src = "https://github.com/ej-shafran/compile-mode.nvim",
    branch = "latest",
  },
}

vim.pack.add(plugins)

---}}}

--{{{ -- Themes

require('tokyonight').setup {
  dim_inactive = false,
  style = 'night',
  transparent = false,
  styles = {
    -- sidebars = "transparent",
    -- floats = "transparent",
    -- functions = { bold = true },
    -- keywords = { bold = true },
  },
  on_colors = function(colors)
    colors.bg_statusline = colors.none -- To check if its working try something like "#ff00ff" instead of colors.none
    colors.bg_statusline = colors.none
  end,
}

vim.cmd.colorscheme 'tokyonight-night'
--}}}

--{{{ -- Mason LSP
require('mason').setup()

require('mason-lspconfig').setup {
  ensure_installed = { 'lua_ls', 'rust_analyzer', 'marksman' },
}
--}}}

--{{{ -- Treesitter
require('nvim-treesitter').setup {
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
      init_selection = '<C-space>',
      node_incremental = '<C-space>',
      scope_incremental = false,
      node_decremental = '<BS>',
    },
  },
  textobjects = {
    move = {
      enable = true,
      goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
      goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
      goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
      goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },
    },
  },
}

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
--}}}

--{{{ -- Mini
require("mini.pick").setup()
vim.keymap.set("n", "<leader>ff", ":Pick files<Cr>")
vim.keymap.set("n", "<leader>f/", ":Pick grep_live<Cr>")
require("mini.ai").setup()
require("mini.surround").setup()
require("mini.icons").setup()
require("mini.move").setup({
  mappings = {
    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
    left = "<C-h>",
    right = "<C-l>",
    down = "<C-j>",
    up = "<C-k>",
  },
  -- Options which control moving behavior
  options = {
    -- Automatically reindent selection during linewise vertical move
    reindent_linewise = true,
  },
})


--}}}

--{{{ -- nvim-sessionizer
  require("nvim-sessionizer").setup({
  ui = {
    keymap = {
      quit = "q",         -- Key to quit the session window
      attach = "<CR>",    -- Key to attach to a session
      delete = "<S-d>",   -- Key to delete a session
      move_up = "<C-k>",  -- Move session up
      move_down = "<S-j>",-- Move session down
    },
    win = {
      width = 0.6,        -- Window width ratio (0-1)
      height = 0.4,       -- Window height ratio (0-1)
      winbar = {
        hl_left = "Title",      -- Highlight for left section text
        hl_right = "Comment",   -- Highlight for right section text
        hl_separator = "Comment", -- Highlight for separators
        sep_left = "/",         -- Separator between left items
        sep_mid = "%=",         -- Separator for center alignment
        sep_right = "│",        -- Separator for right items
        format = function(config) -- Function to format winbar items
          return {
            left = {
              " " .. config.ui.keymap.quit .. " close",
              config.ui.keymap.delete .. " delete session",
            },
            right = {
              config.ui.keymap.attach .. " attach session",
              config.ui.keymap.move_up .. "/" .. config.ui.keymap.move_down .. " move session",
            },
          }
        end,
      },
    },
    current = {
      mark = ">",          -- Marker for the current session
      hl = "MatchParen",   -- Highlight group for the marker
    },
  },
})

vim.keymap.set("n", "<A-o>", function()
  require("nvim-sessionizer").sessionizer()
end, { silent = true, desc = "Create an new session wiht zoxide" })
vim.keymap.set("n", "<A-S-w>", function()
  require("nvim-sessionizer").new_session()
end, { silent = true, desc = "Create an new session in the current dir" })
vim.keymap.set("n", "<A-u>", function()
  require("nvim-sessionizer").attach_session()
end, { silent = true, desc = "Attach to and sessins with vim.ui.select" })
vim.keymap.set("n", "<A-S-0>", function()
  require("nvim-sessionizer").attach_session("+1")
end, { silent = true, desc = "Go to next session" })
vim.keymap.set("n", "<A-S-9>", function()
  require("nvim-sessionizer").attach_session("-1")
end, { silent = true, desc = "Go to previous session" })
vim.keymap.set("n", "<A-x>", function()
  require("nvim-sessionizer").remove_session()
end, { silent = true })
vim.keymap.set("n", "<A-s>", function()
  require("nvim-sessionizer").manage_sessions()
end, { silent = true, desc = "List sessions" })
vim.keymap.set("n", "<A-d>", ":detach<CR>", { silent = true, desc = "Detach current session" })
for i = 1, 9 do
  vim.keymap.set("n", "<C-" .. i .. ">", function()
    require("nvim-sessionizer").attach_session(i)
  end, { silent = true, desc = "which_key_ignore" })
end
--}}}

--{{{ -- TabTerm

-- Define Keys
require('TabTerm').setup({
  separator_right = "",
  separator_left = "",
  separator_first = "█",
})
vim.keymap.set({ "n", "i", "v", "t" }, "<A-n>", function() require("TabTerm").new() end, { desc = "TabTerm New" })
vim.keymap.set({ "n", "i", "v", "t" }, "<A-.>", function() require("TabTerm").close() end, { desc = "TabTerm Close" })
vim.keymap.set({ "n", "i", "v", "t" }, "<A-,>", function() require("TabTerm").rename() end, { desc = "TabTerm Rename" })
vim.keymap.set({ "n", "i", "v", "t" }, "<A-/>", function() require("TabTerm").toggle() end, { desc = "TabTerm Toggle" })
for i = 1, 9 do
  vim.keymap.set({ "n", "i", "v", "t" }, "<A-" .. i .. ">", function() require("TabTerm").go(i) end,
    { desc = "which_key_ignore" })
end
---}}}

--{{{ -- Markview
vim.keymap.set("n", "<leader>omm", "<Cmd>Markview Toggle<Cr>", { desc = "Toggle Markview" })
vim.keymap.set("n", "<leader>omh", "<Cmd>Markview hybridToggle<Cr>", { desc = "Toggle Hybrid Mode" })
vim.keymap.set("n", "<leader>oms", "<Cmd>Markview splitToggle<Cr>", { desc = "Toggle Split View" })
require("markview.extras.checkboxes").setup()
require("markview.extras.headings").setup()
require("markview").setup({
  preview = {
    modes = { "n", "no", "c" },
    hybrid_modes = { "n" },
    linewise_hybrid_mode = true,
  },
  latex = {
    enable = false,
  },
  -- list_items
  markdown = {
    list_items = {
      enable = true,
      wrap = false,
      indent_size = 2,
      shift_width = 4,
      marker_minus = {
        add_padding = true,
        conceal_on_checkboxes = true,
        text = "-",
        hl = "MarkviewListItemMinus",
      },
      marker_plus = {
        add_padding = true,
        conceal_on_checkboxes = true,
        text = "+",
        hl = "MarkviewListItemPlus",
      },
      marker_star = {
        add_padding = true,
        conceal_on_checkboxes = true,
        text = "*",
        hl = "MarkviewListItemStar",
      },
      marker_dot = {
        add_padding = true,
        conceal_on_checkboxes = true,
      },
      marker_parenthesis = {
        add_padding = true,
        conceal_on_checkboxes = true,
      },
    },
  },
})
--}}}

--{{{ -- Md-agenda
require("md-agenda").setup({
  --- REQUIRED ---
  agendaFiles = {
    -- "~/notes/agenda.md", "~/notes/habits.md", -- Single Files
    "~/Notes/", -- Folders
  },
  habit = {
    "~/Notes/habits/",
    "habits.md",
  },

  --- OPTIONAL ---
  -- Number of days to display on one agenda view page. Default: 10
  agendaViewPageItems = 10,
  -- Number of days before the deadline to show a reminder for the task in the agenda view. Default: 30
  remindDeadlineInDays = 30,
  -- Number of days before the scheduled time to show a reminder for the task in the agenda view. Default: 10
  remindScheduledInDays = 10,

  -- Number of past days to show in the habit view. Default: 24
  habitViewPastItems = 24,
  -- Number of future days to show in the habit view. Default: 3
  habitViewFutureItems = 3,

  -- For folding logbook entries. Default: {{{,}}}
  foldmarker = "{{{,}}}",

  -- Custom types that you can use instead of TODO. Default: {}
  -- The plugin will give an error if you use RGB colors (e.g. #ffffff)
  customTodoTypes = { SOMEDAY = "magenta" }, -- A map of custom item type and its color

  dashboard = {
    {
      "All TODO Items", -- Group name
      {
        -- Item types, e.g., {"TODO", "INFO"}. Gets the items that match one of the given types. Ignored if empty.
        type = { "TODO" },

        -- List of tags to filter. Use AND/OR conditions, e.g., {AND = {"tag1", "tag2"}, OR = {"tag1", "tag2"}}. Ignored if empty.
        tags = {},

        -- Both, deadline and scheduled filters can take the same parameters.
        -- "none", "today", "past", "nearFuture", "before-yyyy-mm-dd", "after-yyyy-mm-dd".
        -- Ignored if empty.
        deadline = "",
        scheduled = "",
      },
      --{...}, Additional filter maps can be added in the same group.
    },
    --{"Other Group", {...}, ...}
    --...
  },

  -- Optional: Change agenda colors.
  tagColor = "white",
  titleColor = "yellow",

  todoTypeColor = "cyan",
  habitTypeColor = "cyan",
  infoTypeColor = "lightgreen",
  dueTypeColor = "red",
  doneTypeColor = "green",
  cancelledTypeColor = "red",

  completionColor = "lightgreen",
  scheduledTimeColor = "cyan",
  deadlineTimeColor = "red",

  habitScheduledColor = "yellow",
  habitDoneColor = "green",
  habitProgressColor = "lightgreen",
  habitPastScheduledColor = "darkyellow",
  habitFreeTimeColor = "blue",
  habitNotDoneColor = "red",
  habitDeadlineColor = "gray",
})

-- Optional: Set keymaps for commands
vim.keymap.set("n", "<leader>oac", "<Cmd>CheckTask<CR>", { silent = true })
-- vim.keymap.set("n", "<CR>", "<Cmd>CheckTask<CR>", { silent = true })
vim.keymap.set("n", "<leader>oaC", "<Cmd>CancelTask<CR>", { silent = true })
vim.keymap.set("n", "<leader>oah", "<Cmd>HabitView<CR>", { silent = true })
vim.keymap.set("n", "<leader>oad", "<Cmd>AgendaDashboard<CR>", { silent = true })
vim.keymap.set("n", "<leader>oaa", "<Cmd>AgendaView<CR>", { silent = true })
vim.keymap.set("n", "<leader>oaS", "<Cmd>TaskScheduled<CR>", { silent = true })
vim.keymap.set("n", "<leader>oaD", "<Cmd>TaskDeadline<CR>", { silent = true })
vim.keymap.set("n", "<leader>ood", function()
  local current_date = os.date("%Y-%m-%d")
  local daily_note_date = "~/Notes/DailyNotes/" .. current_date .. ".md"
  vim.cmd("e " .. daily_note_date)
end, { desc = "Daily Note" })
--}}}

--{{{ -- Neogit
vim.keymap.set("n", "<leader>gg", ":Neogit kind=replace<Cr>", { silent = true, desc = "Neogit" })
--}}}

--{{{ -- Oil
require("oil").setup(
  {
    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
    -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
    default_file_explorer = false,
    -- Id is automatically added at the beginning, and name at the end
    -- See :help oil-columns
    columns = {
      "icon",
      -- "permissions",
      -- "size",
      -- "mtime",
    },
    -- Buffer-local options to use for oil buffers
    buf_options = {
      buflisted = false,
      bufhidden = "hide",
    },
    -- Window-local options to use for oil buffers
    win_options = {
      wrap = false,
      signcolumn = "no",
      cursorcolumn = false,
      foldcolumn = "0",
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = "nvic",
      relativenumber = false
    },
    -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
    delete_to_trash = true,
    -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
    skip_confirm_for_simple_edits = true,
    -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
    -- (:help prompt_save_on_select_new_entry)
    prompt_save_on_select_new_entry = true,
    -- Oil will automatically delete hidden buffers after this delay
    -- You can set the delay to false to disable cleanup entirely
    -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
    cleanup_delay_ms = 2000,
    lsp_file_methods = {
      -- Enable or disable LSP file operations
      enabled = true,
      -- Time to wait for LSP file operations to complete before skipping
      timeout_ms = 1000,
      -- Set to true to autosave buffers that are updated with LSP willRenameFiles
      -- Set to "unmodified" to only save unmodified buffers
      autosave_changes = false,
    },
    -- Constrain the cursor to the editable parts of the oil buffer
    -- Set to `false` to disable, or "name" to keep it on the file names
    constrain_cursor = "editable",
    -- Set to true to watch the filesystem for changes and reload oil
    watch_for_changes = false,
    -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
    -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
    -- Additionally, if it is a string that matches "actions.<name>",
    -- it will use the mapping at require("oil.actions").<name>
    -- Set to `false` to remove a keymap
    -- See :help oil-actions for a list of all available actions
    keymaps = {
      ["g?"] = { "actions.show_help", mode = "n" },
      ["<CR>"] = "actions.select",
      ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-t>"] = { "actions.select", opts = { tab = true } },
      ["gp"] = "actions.preview",
      ["<C-c>"] = { "actions.close", mode = "n" },
      ["<Esc><Esc>"] = { "actions.close", mode = "n" },
      ["gq"] = { "actions.close", mode = "n" },
      ["<C-l>"] = "actions.refresh",
      ["-"] = { "actions.parent", mode = "n" },
      ["<Bs>"] = { "actions.parent", mode = "n" },
      ["~"] = { "actions.open_cwd", mode = "n" },
      ["`"] = { "actions.cd", mode = "n" },
      ["g`"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      ["gs"] = { "actions.change_sort", mode = "n" },
      ["gx"] = "actions.open_external",
      ["g."] = { "actions.toggle_hidden", mode = "n" },
      ["g\\"] = { "actions.toggle_trash", mode = "n" },
      ["gd"] = {
        desc = "Toggle file detail view",
        callback = function()
          detail = not detail
          if detail then
            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
          else
            require("oil").set_columns({ "icon" })
          end
        end,
      },
    },
    -- Set to false to disable all of the above keymaps
    use_default_keymaps = true,
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
      -- This function defines what is considered a "hidden" file
      is_hidden_file = function(name, bufnr)
        local m = name:match("^%.")
        return m ~= nil
      end,
      -- This function defines what will never be shown, even when `show_hidden` is set
      is_always_hidden = function(name, bufnr)
        return false
      end,
      -- Sort file names with numbers in a more intuitive order for humans.
      -- Can be "fast", true, or false. "fast" will turn it off for large directories.
      natural_order = "fast",
      -- Sort file and directory names case insensitive
      case_insensitive = false,
      sort = {
        -- sort order can be "asc" or "desc"
        -- see :help oil-columns to see which columns are sortable
        { "type", "asc" },
        { "name", "asc" },
      },
      -- Customize the highlight group for the file name
      highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
        return nil
      end,
    },
    -- Extra arguments to pass to SCP when moving/copying files over SSH
    extra_scp_args = {},
    -- EXPERIMENTAL support for performing file operations with git
    git = {
      -- Return true to automatically git add/mv/rm files
      add = function(path)
        return false
      end,
      mv = function(src_path, dest_path)
        return false
      end,
      rm = function(path)
        return false
      end,
    },
    -- Configuration for the floating window in oil.open_float
    float = {
      -- Padding around the floating window
      padding = 5,
      -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      max_width = 0.5,
      max_height = 0.5,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
      -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
      get_win_title = nil,
      -- preview_split: Split direction: "auto", "left", "right", "above", "below".
      preview_split = "bellow",
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      override = function(conf)
        return conf
      end,
    },
    -- Configuration for the file preview window
    preview_win = {
      -- Whether the preview window is automatically updated when the cursor is moved
      update_on_cursor_moved = true,
      -- How to open the preview window "load"|"scratch"|"fast_scratch"
      preview_method = "fast_scratch",
      -- A function that returns true to disable preview on a file e.g. to avoid lag
      disable_preview = function(filename)
        return false
      end,
      -- Window-local options to use for preview window buffers
      win_options = {},
    },
    -- Configuration for the floating action confirmation window
    confirmation = {
      -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      -- min_width and max_width can be a single value or a list of mixed integer/float types.
      -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
      max_width = 0.9,
      -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
      min_width = { 40, 0.4 },
      -- optionally define an integer/float for the exact width of the preview window
      width = nil,
      -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      -- min_height and max_height can be a single value or a list of mixed integer/float types.
      -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
      max_height = 0.9,
      -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
      min_height = { 5, 0.1 },
      -- optionally define an integer/float for the exact height of the preview window
      height = nil,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
    -- Configuration for the floating progress window
    progress = {
      max_width = 0.6,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = { 10, 0.9 },
      min_height = { 5, 0.1 },
      height = nil,
      border = "rounded",
      minimized_border = "none",
      win_options = {
        winblend = 0,
      },
    },
    -- Configuration for the floating SSH window
    ssh = {
      border = "rounded",
    },
    -- Configuration for the floating keymaps help window
    keymaps_help = {
      border = "rounded",
    },
  }
)
vim.keymap.set("n", "<leader>fd", vim.cmd.Oil, { desc = "Dired(Oil)" })
vim.keymap.set("n", "<leader>.", vim.cmd.Oil, { desc = "Oil" })
--}}}

--{{{ -- Harpoon
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>he", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)

for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end, { desc = "which_key_ignore" })
  vim.keymap.set("n", "<leader>h" .. i, function() harpoon:list():replace_at(i) end, { desc = "which_key_ignore" })
end

-- }}}

--{{{ -- Compile
  vim.g.compile_mode = {
    -- if you use something like `nvim-cmp` or `blink.cmp` for completion,
    -- set this to fix tab completion in command mode:
    -- input_word_completion = true,
    -- to add ANSI escape code support, add:
    -- baleia_setup = true,
    -- to make `:Compile` replace special characters (e.g. `%`) in
    -- the command (and behave more like `:!`), add:
    bang_expansion = true,
  }
  vim.keymap.set("n", "<leader>cc", ":Compile<Cr>")
  vim.keymap.set("n", "<leader>cC", ":Recompile<Cr>")
  ---}}}
