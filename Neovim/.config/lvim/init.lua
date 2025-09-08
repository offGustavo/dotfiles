-- vim: foldmethod=marker foldlevel=0

--{{{ -- Options --
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.g.plugin_enabled = true
vim.g.ui_plugins = true
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

vim.keymap.set('v', '<S-k>', ":m '<-2<CR>gv=gv", { silent = true, desc = 'Move Line Up' })
vim.keymap.set('v', '<S-j>', ":m '>+1<CR>gv=gv", { silent = true, desc = 'Move Line Down' })

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
vim.keymap.set('n', '<leader><space>', ':find ')
vim.keymap.set('n', '<leader>ff', ':find ')
vim.keymap.set("n", "<leader>/", ":grep ")

vim.keymap.set('n', '<leader>z', ':cd ')

vim.keymap.set("n", "<leader>1", " `1")
vim.keymap.set("n", "<leader>2", " `2")
vim.keymap.set("n", "<leader>3", " `3")
vim.keymap.set("n", "<leader>4", " `4")
vim.keymap.set("n", "<leader>5", " `5")
vim.keymap.set("n", "<leader>6", " `6")
vim.keymap.set("n", "<leader>7", " `7")
vim.keymap.set("n", "<leader>8", " `8")
vim.keymap.set("n", "<leader>9", " `9")
vim.keymap.set("n", "<leader>0", " `0")

vim.keymap.set("n", "<leader>l", function() vim.pack.update() end)

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
local function is_cmdline_type_find()
  local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]

  return cmdline_cmd == 'find' or cmdline_cmd == 'fin'
end

vim.api.nvim_create_autocmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
  pattern = { '*' },
  group = vim.api.nvim_create_augroup('CmdlineAutocompletion', { clear = true }),
  callback = function(ev)
    vim.opt.wildmenu = true
    vim.opt.wildmode = 'noselect:lastused,full'
    local function should_enable_autocomplete()
      local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]

      return is_cmdline_type_find() or cmdline_cmd == 'help' or cmdline_cmd == 'h'
    end

    if ev.event == 'CmdlineChanged' and should_enable_autocomplete() then
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
if vim.g.plugin_enabled then
  --{{{ Themes
  vim.pack.add {
    "https://github.com/folke/tokyonight.nvim",
  }

  require('tokyonight').setup {
    dim_inactive = false,
    style = "night",
    transparent = false,
    styles = {
      -- sidebars = "transparent",
      -- floats = "transparent",
      -- functions = { bold = true },
      -- keywords = { bold = true },
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

  if vim.g.ui_plugins then
    --{{{ Neogit
    vim.pack.add {
      "https://github.com/nvim-lua/plenary.nvim",  -- required
      "https://github.com/sindrets/diffview.nvim", -- optional - Diff integration
      "https://github.com/NeogitOrg/neogit"
    }

    vim.keymap.set("n", "<leader>gg", ":Neogit kind=replace<Cr>", { silent = true, desc = "Neogit" })
    --}}}

    ---{{{ Mini
    vim.pack.add { 'https://github.com/echasnovski/mini.nvim' }

    require("mini.ai").setup()
    require("mini.surround").setup()
    require("mini.icons").setup()
    --}}}

    --{{{ Oil
    vim.pack.add({
      "https://github.com/stevearc/oil.nvim"
    })

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
          ["_"] = { "actions.open_cwd", mode = "n" },
          ["`"] = { "actions.cd", mode = "n" },
          ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
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

    vim.keymap.set("n", "<leader><Cr>", vim.cmd.Oil)
    --}}}

    --{{{ Snacks
    vim.pack.add { 'https://github.com/folke/snacks.nvim' }

    require("snacks").setup({
      input = {
        enabled = true,
      },
      notifier = {
        enabled = true,
        timeout = 2000,
      },
      picker = {
        prompt = " ",
        sources = {
        },
        focus = "input",
        layout = "ivy_split",
        matcher = {
          fuzzy = true,          -- use fuzzy matching
          smartcase = true,      -- use smartcase
          ignorecase = true,     -- use ignorecase
          sort_empty = false,    -- sort results when the search string is empty
          filename_bonus = true, -- give bonus for matching file names (last part of the path)
          file_pos = true,       -- support patterns like `file:line:col` and `file:line`
          -- the bonusses below, possibly require string concatenation and path normalization,
          -- so this can have a performance impact for large lists and increase memory usage
          cwd_bonus = true,      -- give bonus for matching files in the cwd
          frecency = true,       -- frecency bonus
          history_bonus = false, -- give more weight to chronological order
        },
        sort = {
          -- default sort is by score, text length and index
          fields = { "score:desc", "#text", "idx" },
        },
        ui_select = true, -- replace `vim.ui.select` with the snacks picker
        ---@class snacks.picker.formatters.Config
        formatters = {
          text = {
            ft = nil, ---@type string? filetype for highlighting
          },
          file = {
            hidden = true,
            filename_first = false, -- display filename before the file path
            truncate = 40,          -- truncate the file path to (roughly) this length
            filename_only = false,  -- only show the filename
            icon_width = 2,         -- width of the icon (in characters)
            git_status_hl = true,   -- use the git status highlight group for the filename
          },
          selected = {
            show_always = true, -- only show the selected column when there are multiple selections
            unselected = true,  -- use the unselected icon for unselected items
          },
          severity = {
            icons = true,  -- show severity icons
            level = false, -- show severity level
            ---@type "left"|"right"
            pos = "left",  -- position of the diagnostics
          },
        },
        ---@class snacks.picker.previewers.Config
        previewers = {
          diff = {
            builtin = true,    -- use Neovim for previewing diffs (true) or use an external tool (false)
            cmd = { "delta" }, -- example to show a diff with delta
          },
          git = {
            builtin = true, -- use Neovim for previewing git output (true) or use git (false)
            args = {},      -- additional arguments passed to the git command. Useful to set pager options usin `-c ...`
          },
          file = {
            max_size = 1024 * 1024, -- 1MB
            max_line_length = 500,  -- max line length
            ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
          },
          man_pager = nil, ---@type string? MANPAGER env to use for `man` preview
        },
        ---@class snacks.picker.jump.Config
        jump = {
          jumplist = true,   -- save the current position in the jumplist
          tagstack = false,  -- save the current position in the tagstack
          reuse_win = false, -- reuse an existing window if the buffer is already open
          close = true,      -- close the picker when jumping/editing to a location (defaults to true)
          match = false,     -- jump to the first match position. (useful for `lines`)
        },
        toggles = {
          follow = "f",
          hidden = "h",
          ignored = "i",
          modified = "m",
          regex = { icon = "R", value = false },
        },
        win = {
          -- input window
          input = {
            keys = {
              -- to close the picker on ESC instead of going to normal mode,
              -- add the following keymap to your config
              -- ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["/"] = "toggle_focus",
              ["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
              ["<C-Up>"] = { "history_back", mode = { "i", "n" } },
              ["<C-c>"] = { "cancel", mode = "i" },
              ["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
              ["<CR>"] = { "confirm", mode = { "n", "i" } },
              ["<Down>"] = { "list_down", mode = { "i", "n" } },
              ["<Esc>"] = "cancel",
              ["<S-CR>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
              ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
              ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
              ["<Up>"] = { "list_up", mode = { "i", "n" } },
              ["<a-d>"] = { "inspect", mode = { "n", "i" } },
              ["<a-f>"] = { "toggle_follow", mode = { "i", "n" } },
              ["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
              ["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
              ["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
              ["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
              ["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
              ["<c-a>"] = { "select_all", mode = { "n", "i" } },
              ["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
              ["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-g>"] = { "toggle_live", mode = { "i", "n" } },
              ["<c-j>"] = { "list_down", mode = { "i", "n" } },
              ["<c-k>"] = { "list_up", mode = { "i", "n" } },
              ["<c-n>"] = { "list_down", mode = { "i", "n" } },
              ["<c-p>"] = { "list_up", mode = { "i", "n" } },
              ["<c-q>"] = { "qflist", mode = { "i", "n" } },
              ["<c-s>"] = { "edit_split", mode = { "i", "n" } },
              ["<c-t>"] = { "tab", mode = { "n", "i" } },
              ["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
              ["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
              ["<c-r>#"] = { "insert_alt", mode = "i" },
              ["<c-r>%"] = { "insert_filename", mode = "i" },
              ["<c-r><c-a>"] = { "insert_cWORD", mode = "i" },
              ["<c-r><c-f>"] = { "insert_file", mode = "i" },
              ["<c-r><c-l>"] = { "insert_line", mode = "i" },
              ["<c-r><c-p>"] = { "insert_file_full", mode = "i" },
              ["<c-r><c-w>"] = { "insert_cword", mode = "i" },
              ["<c-w>H"] = "layout_left",
              ["<c-w>J"] = "layout_bottom",
              ["<c-w>K"] = "layout_top",
              ["<c-w>L"] = "layout_right",
              ["?"] = "toggle_help_input",
              ["G"] = "list_bottom",
              ["gg"] = "list_top",
              ["j"] = "list_down",
              ["k"] = "list_up",
              ["q"] = "close",
            },
            b = {
              minipairs_disable = true,
            },
          },
          -- result list window
          list = {
            keys = {
              ["/"] = "toggle_focus",
              ["<2-LeftMouse>"] = "confirm",
              ["<CR>"] = "confirm",
              ["<Down>"] = "list_down",
              ["<Esc>"] = "cancel",
              ["<S-CR>"] = { { "pick_win", "jump" } },
              ["<S-Tab>"] = { "select_and_prev", mode = { "n", "x" } },
              ["<Tab>"] = { "select_and_next", mode = { "n", "x" } },
              ["<Up>"] = "list_up",
              ["<a-d>"] = "inspect",
              ["<a-f>"] = "toggle_follow",
              ["<a-h>"] = "toggle_hidden",
              ["<a-i>"] = "toggle_ignored",
              ["<a-m>"] = "toggle_maximize",
              ["<a-p>"] = "toggle_preview",
              ["<a-w>"] = "cycle_win",
              ["<c-a>"] = "select_all",
              ["<c-b>"] = "preview_scroll_up",
              ["<c-d>"] = "list_scroll_down",
              ["<c-f>"] = "preview_scroll_down",
              ["<c-j>"] = "list_down",
              ["<c-k>"] = "list_up",
              ["<c-n>"] = "list_down",
              ["<c-p>"] = "list_up",
              ["<c-q>"] = "qflist",
              ["<c-s>"] = "edit_split",
              ["<c-t>"] = "tab",
              ["<c-u>"] = "list_scroll_up",
              ["<c-v>"] = "edit_vsplit",
              ["<c-w>H"] = "layout_left",
              ["<c-w>J"] = "layout_bottom",
              ["<c-w>K"] = "layout_top",
              ["<c-w>L"] = "layout_right",
              ["?"] = "toggle_help_list",
              ["G"] = "list_bottom",
              ["gg"] = "list_top",
              ["i"] = "focus_input",
              ["j"] = "list_down",
              ["k"] = "list_up",
              ["q"] = "close",
              ["zb"] = "list_scroll_bottom",
              ["zt"] = "list_scroll_top",
              ["zz"] = "list_scroll_center",
            },
            wo = {
              conceallevel = 2,
              concealcursor = "nvc",
            },
          },
          -- preview window
          preview = {
            keys = {
              ["<Esc>"] = "cancel",
              ["q"] = "close",
              ["i"] = "focus_input",
              ["<a-w>"] = "cycle_win",
            },
          },
        },
        ---@class snacks.picker.icons
        icons = {
          files = {
            enabled = true, -- show file icons
            dir = "󰉋 ",
            dir_open = "󰝰 ",
            file = "󰈔 "
          },
          keymaps = {
            nowait = "󰓅 "
          },
          tree = {
            vertical = "│ ",
            middle   = "├╴",
            last     = "└╴",
          },
          undo = {
            saved = " ",
          },
          ui = {
            live       = "󰐰 ",
            hidden     = "h",
            ignored    = "i",
            follow     = "f",
            selected   = "● ",
            unselected = "○ ",
            -- selected = " ",
          },
          git = {
            enabled   = true, -- show git icons
            commit    = "󰜘 ", -- used by git log
            staged    = "●", -- staged changes. always overrides the type icons
            added     = "",
            deleted   = "",
            ignored   = " ",
            modified  = "○",
            renamed   = "",
            unmerged  = " ",
            untracked = "?",
          },
          diagnostics = {
            Error = " ",
            Warn  = " ",
            Hint  = " ",
            Info  = " ",
          },
          lsp = {
            unavailable = "",
            enabled = " ",
            disabled = " ",
            attached = "󰖩 "
          },
          kinds = {
            Array         = " ",
            Boolean       = "󰨙 ",
            Class         = " ",
            Color         = " ",
            Control       = " ",
            Collapsed     = " ",
            Constant      = "󰏿 ",
            Constructor   = " ",
            Copilot       = " ",
            Enum          = " ",
            EnumMember    = " ",
            Event         = " ",
            Field         = " ",
            File          = " ",
            Folder        = " ",
            Function      = "󰊕 ",
            Interface     = " ",
            Key           = " ",
            Keyword       = " ",
            Method        = "󰊕 ",
            Module        = " ",
            Namespace     = "󰦮 ",
            Null          = " ",
            Number        = "󰎠 ",
            Object        = " ",
            Operator      = " ",
            Package       = " ",
            Property      = " ",
            Reference     = " ",
            Snippet       = "󱄽 ",
            String        = " ",
            Struct        = "󰆼 ",
            Text          = " ",
            TypeParameter = " ",
            Unit          = " ",
            Unknown       = " ",
            Value         = " ",
            Variable      = "󰀫 ",
          },
        },
        ---@class snacks.picker.db.Config
        db = {
          -- path to the sqlite3 library
          -- If not set, it will try to load the library by name.
          -- On Windows it will download the library from the internet.
          sqlite3_path = nil, ---@type string?
        },
        ---@class snacks.picker.debug
        debug = {
          scores = false,   -- show scores in the list
          leaks = false,    -- show when pickers don't get garbage collected
          explorer = true,  -- show explorer debug info
          files = false,    -- show file debug info
          grep = false,     -- show file debug info
          proc = false,     -- show proc debug info
          extmarks = false, -- show extmarks errors
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      animate = {
        duration = 5, -- ms per step
        easing = 'linear',
        fps = 120,    -- frames per second. Global setting for all animations
      },
      styles = {
        notification = {
          -- wo = { wrap = true } -- Wrap notifications
        },
      },
    })

    Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
    Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
    Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
    Snacks.toggle.diagnostics():map '<leader>ud'
    Snacks.toggle.line_number():map '<leader>ul'
    Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
    Snacks.toggle.treesitter():map '<leader>uT'
    Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
    Snacks.toggle.inlay_hints():map '<leader>uh'
    Snacks.toggle.indent():map '<leader>ug'
    Snacks.toggle.dim():map '<leader>uD'
    Snacks.toggle.option('cursorline', { off = false, on = true }):map '<leader>ol'
    Snacks.toggle.animate():map '<leader>ua'

    local snacks_keys = {
      {
        '<leader><space>',
        function()
          Snacks.picker.smart {
            matcher = {
              frequency = true,
            },
            win = {
              input = {
                keys = {
                  ['d'] = 'bufdelete',
                  ['J'] = 'preview_scroll_down',
                  ['K'] = 'preview_scroll_up',
                  ['H'] = 'preview_scroll_left',
                  ['L'] = 'preview_scroll_right',
                },
              },
              list = {
                keys = {
                  ['d'] = 'bufdelete',
                  ['J'] = 'preview_scroll_down',
                  ['K'] = 'preview_scroll_up',
                  ['H'] = 'preview_scroll_left',
                  ['L'] = 'preview_scroll_right',
                },
              },
            },
          }
        end,
        desc = 'which_key_ignore',
      },

      {
        '<leader>e',
        function()
          Snacks.explorer()
        end,
        desc = 'which_key_ignore',
      },

      {
        '<leader>fa',
        function()
          Snacks.picker()
        end,
        desc = 'which_key_ignore',
      },
      {
        '<leader>,',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'which_key_ignore',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.grep()
        end,
        desc = 'which_key_ignore',
      },
      {
        '<leader>fe',
        function()
          Snacks.explorer()
        end,
        desc = 'File Explorer',
      },
      -- find
      {
        '<leader>fb',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      -- {
      --   '<leader>fc',
      --   function()
      --     Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      --   end,
      --   desc = 'Find Config File',
      -- },
      {
        '<leader>ff',
        function()
          Snacks.picker.files()
        end,
        desc = 'Find Files',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.git_files()
        end,
        desc = 'Find Git Files',
      },
      {
        '<leader>fp',
        function()
          Snacks.picker.projects()
        end,
        desc = 'Projects',
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.recent()
        end,
        desc = 'Recent',
      },
      -- git
      {
        '<leader>gb',
        function()
          Snacks.picker.git_branches()
        end,
        desc = 'Git Branches',
      },
      {
        '<leader>gl',
        function()
          Snacks.picker.git_log()
        end,
        desc = 'Git Log',
      },
      {
        '<leader>gL',
        function()
          Snacks.picker.git_log_line()
        end,
        desc = 'Git Log Line',
      },
      {
        '<leader>gs',
        function()
          Snacks.picker.git_status()
        end,
        desc = 'Git Status',
      },
      {
        '<leader>gS',
        function()
          Snacks.picker.git_stash()
        end,
        desc = 'Git Stash',
      },
      {
        '<leader>gd',
        function()
          Snacks.picker.git_diff()
        end,
        desc = 'Git Diff (Hunks)',
      },
      {
        '<leader>gf',
        function()
          Snacks.picker.git_log_file()
        end,
        desc = 'Git Log File',
      },
      -- Grep
      {
        '<leader>sb',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Buffer Lines',
      },
      {
        '<leader>sB',
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = 'Grep Open Buffers',
      },
      {
        '<leader>sg',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep',
      },
      {
        '<leader>sw',
        function()
          Snacks.picker.grep_word()
        end,
        desc = 'Visual selection or word',
        mode = { 'n', 'x' },
      },
      -- search
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = 'Registers',
      },
      {
        '<leader>s/',
        function()
          Snacks.picker.search_history()
        end,
        desc = 'Search History',
      },
      {
        '<leader>sa',
        function()
          Snacks.picker.autocmds()
        end,
        desc = 'Autocmds',
      },
      {
        '<leader>sb',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Buffer Lines',
      },
      {
        '<leader>sc',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command History',
      },
      {
        '<leader>sC',
        function()
          Snacks.picker.commands()
        end,
        desc = 'Commands',
      },
      {
        '<leader>sd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = 'Diagnostics',
      },
      {
        '<leader>sD',
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = 'Buffer Diagnostics',
      },
      {
        '<leader>sh',
        function()
          Snacks.picker.help()
        end,
        desc = 'Help Pages',
      },
      {
        '<leader>sH',
        function()
          Snacks.picker.highlights()
        end,
        desc = 'Highlights',
      },
      {
        '<leader>si',
        function()
          Snacks.picker.icons()
        end,
        desc = 'Icons',
      },
      {
        '<leader>sj',
        function()
          Snacks.picker.jumps()
        end,
        desc = 'Jumps',
      },
      {
        '<leader>sk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = 'Keymaps',
      },
      {
        '<leader>sl',
        function()
          Snacks.picker.loclist()
        end,
        desc = 'Location List',
      },
      {
        '<leader>sm',
        function()
          Snacks.picker.marks()
        end,
        desc = 'Marks',
      },
      {
        '<leader>sM',
        function()
          Snacks.picker.man()
        end,
        desc = 'Man Pages',
      },
      {
        '<leader>sp',
        function()
          Snacks.picker.lazy()
        end,
        desc = 'Search for Plugin Spec',
      },
      {
        '<leader>sq',
        function()
          Snacks.picker.qflist()
        end,
        desc = 'Quickfix List',
      },
      {
        '<leader>sR',
        function()
          Snacks.picker.resume()
        end,
        desc = 'Resume',
      },
      {
        '<leader>su',
        function()
          Snacks.picker.undo()
        end,
        desc = 'Undo History',
      },
      {
        '<leader>uC',
        function()
          Snacks.picker.colorschemes()
        end,
        desc = 'Colorschemes',
      },
      -- LSP
      {
        'gd',
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = 'Goto Definition',
      },
      {
        'gD',
        function()
          Snacks.picker.lsp_declarations()
        end,
        desc = 'Goto Declaration',
      },
      {
        'gr',
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = 'References',
      },
      {
        'gI',
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = 'Goto Implementation',
      },
      {
        'gy',
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = 'Goto T[y]pe Definition',
      },
      {
        '<leader>ss',
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = 'LSP Symbols',
      },
      {
        '<leader>sS',
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = 'LSP Workspace Symbols',
      },
      -- Other
      {
        '<leader>z',
        function()
          Snacks.picker.zoxide()
        end,
        desc = 'which_key_ignore',
      },
      {
        '<leader>uz',
        function()
          Snacks.zen()
        end,
        desc = 'Toggle Zen Mode',
      },
      {
        '<leader>uZ',
        function()
          Snacks.zen.zoom()
        end,
        desc = 'Toggle Zoom',
      },
      {
        '<leader>bd',
        function()
          Snacks.bufdelete()
        end,
        desc = 'Delete Buffer',
      },
      {
        '<leader>cR',
        function()
          Snacks.rename.rename_file()
        end,
        desc = 'Rename File',
      },
      {
        '<leader>gB',
        function()
          Snacks.gitbrowse()
        end,
        desc = 'Git Browse',
        mode = { 'n', 'v' },
      },
      {
        '<leader>gG',
        function()
          Snacks.lazygit()
        end,
        desc = 'Lazygit',
      },
      {
        '<leader>un',
        function()
          Snacks.notifier.hide()
        end,
        desc = 'Dismiss All Notifications',
      },
      {
        '<c-/>',
        function()
          Snacks.terminal()
        end,
        desc = 'Toggle Terminal',
      },
      {
        '<c-_>',
        function()
          Snacks.terminal()
        end,
        desc = 'which_key_ignore',
      },
      {
        ']]',
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = 'Next Reference',
        mode = { 'n', 't' },
      },
      {
        '[[',
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = 'Prev Reference',
        mode = { 'n', 't' },
      },
    }



    --- Registra keymaps a partir de uma tabela estruturada
    --- @param maps table Lista de keymaps
    local function set_keymaps(maps)
      for _, map in ipairs(maps) do
        -- valores obrigatórios
        local mode, lhs, rhs

        -- Caso o primeiro campo seja uma string (ex: "<leader>f")
        -- ou uma função/comando, significa que o "mode" não foi declarado
        if type(map[1]) == "string" and (type(map[2]) == "string" or type(map[2]) == "function") then
          mode = "n"
          lhs = map[1]
          rhs = map[2]
        else
          -- Se o primeiro campo for "n" ou {"n", "v"}
          mode = map[1] or "n"
          lhs = map[2]
          rhs = map[3]
        end

        if type(lhs) ~= "string" then
          vim.notify("Keymap inválido: lhs deve ser string", vim.log.levels.ERROR)
          goto continue
        end

        if not (type(rhs) == "string" or type(rhs) == "function") then
          vim.notify("Keymap inválido: rhs deve ser string ou function", vim.log.levels.ERROR)
          goto continue
        end

        -- monta opções extras (desc, silent, buffer, nowait, etc.)
        local opts = {}
        for k, v in pairs(map) do
          if type(k) == "string" then
            if k ~= "mode" then
              opts[k] = v
            end
          end
        end

        vim.keymap.set(mode, lhs, rhs, opts)

        ::continue::
      end
    end

    set_keymaps(snacks_keys)
    --}}}
  end
  --{{{ nvim-sessionizer

  vim.pack.add { "https://github.com/offGustavo/nvim-sessionizer" }
  require("nvim-sessionizer").setup({
    -- Disable Zoxide integration.
    -- Set this to true if:
    --   1. You don't have Zoxide installed, or
    --   2. You prefer not to use Zoxide for project selection.
    no_zoxide = false,

    -- A list of directories where Sessionizer will search for projects.
    -- Each entry should be an absolute path or use ~ for the home directory.
    -- Example:
    --   { "~/Projects", "~/Work" }
    search_dirs = { "~/Projects" },

    -- Maximum search depth for fd or find when listing projects.
    -- This controls how many directory levels are scanned.
    -- Example:
    --   max_depth = 3 means: search up to 3 subdirectory levels deep.
    max_depth = 1,
  })
  vim.keymap.set("n", "<A-o>", function()
    require("nvim-sessionizer").sessionizer()
  end, { silent = true, desc = "Create an new session wiht zoxide" })
  vim.keymap.set("n", "<A-w>", function()
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
    require("nvim-sessionizer").get_sessions()
  end, { silent = true, desc = "List sessions" })
  vim.keymap.set("n", "<A-d>", ":detach<CR>", { silent = true, desc = "Detach current session" })
  for i = 1, 9, 1 do
    vim.keymap.set("n", "<C-" .. i .. ">", function()
      require("nvim-sessionizer").attach_session(i)
    end, { silent = true, desc = "Go to " .. i .. "session" })
  end
  --}}}

  ---{{{ TabTerm
  vim.pack.add({
    "https://github.com/offGustavo/TabTerm.nvim"
  })

  require("TabTerm").setup()

  -- Define Keys
  vim.keymap.set({ "n", "i", "v" }, "<A-n>", function() TabTerm.new() end, { desc = "TabTerm New" })
  vim.keymap.set({ "n", "i", "v" }, "<A-.>", function() TabTerm.close() end, { desc = "TabTerm Close" })
  vim.keymap.set({ "n", "i", "v" }, "<A-,>", function() TabTerm.rename() end, { desc = "TabTerm Rename" })
  vim.keymap.set({ "n", "i", "v" }, "<A-/>", function() TabTerm.toggle() end, { desc = "TabTerm Toggle" })
  ---}}}
end
--}}}
