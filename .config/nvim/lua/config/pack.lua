vim.pack.add({
  -- Tokyonight
  { src = "https://github.com/folke/tokyonight.nvim" },
  -- Canola/Oil
  { src = "https://forge.barrettruth.com/barrettruth/canola.nvim", version = "canola" },

  "https://github.com/dstein64/vim-startuptime",
})

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/mason-org/mason.nvim",

  "https://github.com/ibhagwan/fzf-lua",

  { src = "https://github.com/folke/snacks.nvim" },

  { src = "https://github.com/nvim-mini/mini.nvim" },

  -- NeoGit
  { src = "https://github.com/nvim-lua/plenary.nvim" }, -- required
  { src = "https://github.com/esmuellert/codediff.nvim" }, -- optional
  { src = "https://github.com/m00qek/baleia.nvim" }, -- optional
  { src = "https://github.com/NeogitOrg/neogit" },

  "https://github.com/stevearc/conform.nvim",

  "https://github.com/folke/ts-comments.nvim",

  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/folke/lazydev.nvim",

  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",

  "https://github.com/folke/which-key.nvim",
  { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("v1") },

  "https://github.com/nvim-lua/plenary.nvim",
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },

  "https://github.com/folke/todo-comments.nvim",
}, { load = function() end })

vim.g.startuptime_tries = 10

require("tokyonight").setup({
  dim_inactive = false,
  light_style = "day", -- The theme is used when the background is set to light
  style = "night",
  transparent = false,
  styles = {
    sidebars = "transparent",
    floats = "transparent",
    functions = { bold = true },
    keywords = { bold = true },
  },
  on_colors = function(colors)
    -- colors.bg = "#000000" -- To check if its working try something like "#ff00ff" instead of colors.none
    colors.bg_statusline = colors.none -- To check if its working try something like "#ff00ff" instead of colors.none
    colors.bg_statusline = colors.none
  end,
})

vim.cmd.colorscheme("tokyonight")

vim.g.canola = {
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  cursor = true,
  watch = false,
  border = "rounded",

  hidden = { enabled = false, patterns = { "^%." }, always = {} },

  sort = "default",
  highlights = { filename = {}, columns = true },

  confirm = false,
  save = "prompt",
  delete = { wipe = false, recursive = true },
  create = { file_mode = 420, dir_mode = 493 },
  extglob = true,

  keymaps = {
    ["g?"] = { callback = "actions.show_help", mode = "n" },
    ["<CR>"] = "actions.select",
    ["<C-s>"] = { callback = "actions.select", opts = { vertical = true } },
    ["<C-h>"] = { callback = "actions.select", opts = { horizontal = true } },
    ["<C-t>"] = { callback = "actions.select", opts = { tab = true } },
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = { callback = "actions.close", mode = "n" },
    ["<C-l>"] = "actions.refresh",
    ["-"] = { callback = "actions.parent", mode = "n" },
    ["_"] = { callback = "actions.open_cwd", mode = "n" },
    ["`"] = { callback = "actions.cd", mode = "n" },
    ["g~"] = { callback = "actions.cd", opts = { scope = "tab" }, mode = "n" },
    ["gs"] = { callback = "actions.change_sort", mode = "n" },
    ["gx"] = "actions.open_external",
    ["g."] = { callback = "actions.toggle_hidden", mode = "n" },
    ["q"] = { callback = "actions.close", mode = "n" },
  },

  lsp = { enabled = true, timeout_ms = 1000, autosave = false },

  float = {
    default = false,
    title = true,
    padding = 2,
    max_width = 0,
    max_height = 0,
    border = nil,
    preview_split = "auto",
    win = { winblend = 0 },
  },

  preview = {
    follow = true,
    live = true,
    max_file_size_mb = 10,
    win = {},
  },

  confirmation = {
    max_width = 0.9,
    min_width = { 40, 0.4 },
    width = nil,
    max_height = 0.9,
    min_height = { 5, 0.1 },
    height = nil,
    border = nil,
    win = { winblend = 0 },
  },

  progress = {
    max_width = 0.9,
    min_width = { 40, 0.4 },
    width = nil,
    max_height = { 10, 0.9 },
    min_height = { 5, 0.1 },
    height = nil,
    border = nil,
    minimized_border = "rounded",
    win = { winblend = 0 },
  },

  buf = { buflisted = true, bufhidden = "hide" },
  win = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
}
vim.g.canola_trash = {}

vim.schedule(function()
  require "config.mini"

  vim.cmd [[
  packadd nvim-lspconfig
  packadd mason.nvim
  packadd mason-lspconfig.nvim
  ]]

  require("mason").setup({})
  require("mason-lspconfig").setup({
    automatic_enable = true,
  })

  packadd("conform.nvim")
  require("conform").setup({
    -- Define your formatters
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "nixfmt" },
      python = { "isort", "black" },
      javascript = {
        "prettierd",
        "prettier",
        stop_after_first = true,
      },
    },
    -- Set default options
    default_format_opts = {
      lsp_format = "fallback",
    },
    -- Set up format-on-save
    -- format_on_save = {},
    -- Customize formatters
    formatters = {
      shfmt = {
        append_args = { "-i", "2" },
      },
    },
  })
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  packadd "fzf-lua"
  require("fzf-lua").setup({
    {
      "ivy",
      -- "fzf-native",
      "telescope",
      "hide",
    },
    -- Window options for Ivy layout
    winopts = {
      -- Ivy style: no floating window borders
      border = "none",
      -- Height relative to screen (use full height)
      height = 1.0,
      -- Width relative to screen
      width = 1.0,
      -- Row position: 1.0 pushes it to bottom
      row = 1.0,
      -- Column position
      col = 0.5,
      -- Preview options
      preview = {
        hidden = true,
        -- Preview window position (ivy style: preview above results)
        vertical = "up:70%",
        -- Preview border
        border = "none",
        -- Preview layout
        layout = "vertical",
      },
      -- Disable Treesitter in the picker window for performance
      treesitter = false,
    },
    ui_select = {
      winopts = {
        height = 0.3,
      },
    },
    colorschemes = {
      winopts = { height = 0.55, width = 0.50, col = 0.5, row = 0.0, backdrop = false },
    },
    fzf_opts = {
      ["--sort"] = false,
    },
    fzf_colors = {
      true, -- inherit fzf colors that aren't specified below from
    },
  })

  packadd "neogit"
  require("neogit").setup({
    -- Hides the hints at the top of the status buffer
    disable_hint = true,
    -- Disables changing the buffer highlights based on where the cursor is.
    disable_context_highlighting = true,
    -- Disables signs for sections/items/hunks
    disable_signs = true,
    -- Path to git executable. Defaults to "git". Can be used to specify a custom git binary or wrapper script.
    git_executable = "git",
    -- Offer to force push when branches diverge
    prompt_force_push = true,
    -- Request confirmation when amending already published commits
    prompt_amend_commit = true,
    -- Changes what mode the Commit Editor starts in. `true` will leave nvim in normal mode, `false` will change nvim to
    -- insert mode, and `"auto"` will change nvim to insert mode IF the commit message is empty, otherwise leaving it in
    -- normal mode.
    disable_insert_on_commit = false,
    -- When enabled, will watch the `.git/` directory for changes and refresh the status buffer in response to filesystem
    -- events.
    filewatcher = {
      interval = 1000,
      enabled = true,
    },
    -- "ascii"   is the graph the git CLI generates
    -- "unicode" is the graph like https://github.com/rbong/vim-flog
    -- "kitty"   is the graph like https://github.com/isakbm/gitgraph.nvim - use https://github.com/rbong/flog-symbols if you don't use Kitty
    graph_style = "kitty",
    -- Show relative date by default. When set, use `strftime` to display dates
    commit_date_format = nil,
    log_date_format = nil,
    -- When set, used to format the diff. Requires `baleia` to colorize text with ANSI escape sequences. An example for
    -- `Delta` is `{ 'delta', '--width', '117' }`. For `Delta`, hyperlinks must be disabled when called by `neogit`, for text to be colorized properly.
    log_pager = nil,
    -- Used to generate URL's for branch popup action "pull request" or opening a commit.
    git_services = {
      ["github.com"] = {
        pull_request = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
        commit = "https://github.com/${owner}/${repository}/commit/${oid}",
        tree = "https://${host}/${owner}/${repository}/tree/${branch_name}",
      },
      ["bitbucket.org"] = {
        pull_request = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
        commit = "https://bitbucket.org/${owner}/${repository}/commits/${oid}",
        tree = "https://bitbucket.org/${owner}/${repository}/branch/${branch_name}",
      },
      ["gitlab.com"] = {
        pull_request = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
        commit = "https://gitlab.com/${owner}/${repository}/-/commit/${oid}",
        tree = "https://gitlab.com/${owner}/${repository}/-/tree/${branch_name}?ref_type=heads",
      },
      ["azure.com"] = {
        pull_request = "https://dev.azure.com/${owner}/_git/${repository}/pullrequestcreate?sourceRef=${branch_name}&targetRef=${target}",
        commit = "",
        tree = "",
      },
      ["codeberg.org"] = {
        pull_request = "https://${host}/${owner}/${repository}/compare/${branch_name}",
        commit = "https://${host}/${owner}/${repository}/commit/${oid}",
        tree = "https://${host}/${owner}/${repository}/src/branch/${branch_name}",
      },
    },
    -- Allows a different telescope sorter. Defaults to 'fuzzy_with_index_bias'. The example below will use the native fzf
    -- sorter instead. By default, this function returns `nil`.
    telescope_sorter = function()
      return require("telescope").extensions.fzf.native_fzf_sorter()
    end,
    -- Persist the values of switches/options within and across sessions
    remember_settings = true,
    -- Scope persisted settings on a per-project basis
    use_per_project_settings = true,
    -- Table of settings to never persist. Uses format "Filetype--cli-value"
    ignored_settings = {},
    -- Configure highlight group features
    highlight = {
      italic = true,
      bold = true,
      underline = true,
    },
    -- Set to false if you want to be responsible for creating _ALL_ keymappings
    use_default_keymaps = true,
    -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
    -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
    auto_refresh = true,
    -- Value used for `--sort` option for `git branch` command
    -- By default, branches will be sorted by commit date descending
    -- Flag description: https://git-scm.com/docs/git-branch#Documentation/git-branch.txt---sortltkeygt
    -- Sorting keys: https://git-scm.com/docs/git-for-each-ref#_options
    sort_branches = "-committerdate",
    -- Value passed to the `--<commit_order>-order` flag of the `git log` command
    -- Determines how commits are traversed and displayed in the log / graph:
    --   "topo"         topological order (parents always before children, good for graphs, slower on large repos)
    --   "date"         chronological order by commit date
    --   "author-date"  chronological order by author date
    --   ""             disable explicit ordering (fastest, recommended for very large repos)
    commit_order = "topo",
    -- Default for new branch name prompts
    initial_branch_name = "",
    -- Default for rename branch prompt. If not set, the current branch name is used
    initial_branch_rename = nil,
    -- Change the default way of opening neogit
    kind = "tab",
    -- Floating window style
    floating = {
      relative = "editor",
      width = 0.8,
      height = 0.7,
      style = "minimal",
      border = "rounded",
    },
    -- Disable line numbers
    disable_line_numbers = true,
    -- Disable relative line numbers
    disable_relative_line_numbers = true,
    -- The time after which an output console is shown for slow running commands
    console_timeout = 2000,
    -- Automatically show console if a command takes more than console_timeout milliseconds
    auto_show_console = true,
    -- Automatically close the console if the process exits with a 0 (success) status
    auto_close_console = true,
    notification_icon = "󰊢",
    status = {
      show_head_commit_hash = true,
      recent_commit_count = 10,
      HEAD_padding = 10,
      HEAD_folded = false,
      mode_padding = 3,
      mode_text = {
        M = "modified",
        N = "new file",
        A = "added",
        D = "deleted",
        C = "copied",
        U = "updated",
        R = "renamed",
        T = "changed",
        DD = "unmerged",
        AU = "unmerged",
        UD = "unmerged",
        UA = "unmerged",
        DU = "unmerged",
        AA = "unmerged",
        UU = "unmerged",
        ["?"] = "",
      },
    },
    commit_editor = {
      kind = "tab",
      show_staged_diff = true,
      -- Accepted values:
      -- "split" to show the staged diff below the commit editor
      -- "vsplit" to show it to the right
      -- "split_above" Like :top split
      -- "vsplit_left" like :vsplit, but open to the left
      -- "auto" "vsplit" if window would have 80 cols, otherwise "split"
      staged_diff_split_kind = "split",
      spell_check = true,
    },
    commit_select_view = {
      kind = "tab",
    },
    commit_view = {
      kind = "vsplit",
      verify_commit = vim.fn.executable("gpg") == 1, -- Can be set to true or false, otherwise we try to find the binary
    },
    log_view = {
      kind = "tab",
    },
    rebase_editor = {
      kind = "auto",
    },
    reflog_view = {
      kind = "tab",
    },
    merge_editor = {
      kind = "auto",
    },
    preview_buffer = {
      kind = "floating_console",
    },
    popup = {
      kind = "split",
    },
    stash = {
      kind = "tab",
    },
    refs_view = {
      kind = "tab",
    },
    signs = {
      -- { CLOSED, OPENED }
      hunk = { "", "" },
      item = { ">", "v" },
      section = { ">", "v" },
    },
    -- Each Integration is auto-detected through plugin presence, however, it can be disabled by setting to `false`
    integrations = {
      -- If enabled, use telescope for menu selection rather than vim.ui.select.
      -- Allows multi-select and some things that vim.ui.select doesn't.
      telescope = nil,
      -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `diffview`.
      -- The diffview integration enables the diff popup.
      --
      -- Requires you to have `sindrets/diffview.nvim` installed.
      diffview = nil,

      -- Alternative diff viewer integration.
      -- Requires you to have `esmuellert/codediff.nvim` installed.
      codediff = nil,

      -- If enabled, uses fzf-lua for menu selection. If the telescope integration
      -- is also selected then telescope is used instead
      -- Requires you to have `ibhagwan/fzf-lua` installed.
      fzf_lua = nil,

      -- If enabled, uses mini.pick for menu selection. If the telescope integration
      -- is also selected then telescope is used instead
      -- Requires you to have `echasnovski/mini.pick` installed.
      mini_pick = nil,

      -- If enabled, uses snacks.picker for menu selection. If the telescope integration
      -- is also selected then telescope is used instead
      -- Requires you to have `folke/snacks.nvim` installed.
      snacks = nil,
    },
    -- Which diff viewer to use. nil = auto-detect (tries diffview first, then codediff).
    -- Can be "diffview" or "codediff".
    diff_viewer = nil,
    sections = {
      -- Reverting/Cherry Picking
      sequencer = {
        folded = false,
        hidden = false,
      },
      untracked = {
        folded = false,
        hidden = false,
      },
      unstaged = {
        folded = false,
        hidden = false,
      },
      staged = {
        folded = false,
        hidden = false,
      },
      stashes = {
        folded = true,
        hidden = false,
      },
      unpulled_upstream = {
        folded = true,
        hidden = false,
      },
      unmerged_upstream = {
        folded = false,
        hidden = false,
      },
      unpulled_pushRemote = {
        folded = true,
        hidden = false,
      },
      unmerged_pushRemote = {
        folded = false,
        hidden = false,
      },
      recent = {
        folded = true,
        hidden = false,
      },
      rebase = {
        folded = true,
        hidden = false,
      },
    },
  })

  packadd("ts-comments.nvim")
  require("ts-comments").setup()

  packadd("which-key.nvim")
  require("which-key").setup({
    ---@type false | "classic" | "modern" | "helix"
    preset = "helix",
    -- Delay before showing the popup. Can be a number or a function that returns a number.
    ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
    -- delay = function(ctx)
    -- 	return ctx.plugin and 0 or 200
    -- end,
    delay = 1000,
    ---@param mapping wk.Mapping
    filter = function(mapping)
      -- example to exclude mappings without a description
      -- return mapping.desc and mapping.desc ~= "whichkey_ignore"
      return true
    end,
    --- You can add any mappings here, or use `require('which-key').add()` later
    ---@type wk.Spec
    spec = {
      { "<leader><space>", group = "<localleader>", icon = "" }, -- group
      { "<leader>v", group = "Vim", icon = "" }, -- group
      { "<leader>f", group = "File", icon = "" }, -- group
      { "<leader>s", group = "Search/Replace", icon = "" }, -- group
      { "<leader>g", group = "Git", icon = "" }, -- group
      { "Z", group = "Session", icon = "" }, -- group
      { "s", group = "substitute", icon = "" }, -- group
      { "S", group = "substitute", icon = "" }, -- group
      { "<leader>a", group = "Agenda", icon = "󱨰" }, -- group
      { "<leader>u", group = "Ui", icon = "" }, -- group
      { "<leader>c", group = "Code", icon = "" }, -- group
      { "<leader>l", group = "Location list", icon = "" }, -- group
      { "<leader>q", group = "Quickfix list", icon = "" }, -- group
      { "<leader>h", group = "Harpoon/Espeto", icon = "⇁" }, -- group
      { "<leader>b", group = "Buffer", icon = "" }, -- group
      { "<leader>t", group = "Terminal/Todo", icon = "" }, -- group
      -- { "<leader>r", group = "Rep0lace", icon = "󰛔" }, -- group
      { "<leader><tab>", group = "Tabs/Workspaces", icon = "" }, -- group
    },
    -- show a warning when issues were detected with your mappings
    notify = true,
    -- Which-key automatically sets up triggers for your mappings.
    -- But you can disable this and setup the triggers manually.
    -- Check the docs for more info.
    ---@type wk.Spec
    triggers = {
      { "<auto>", mode = "nxsoi" },
      { "<M-i>", mode = "i" },
    },
    -- Start hidden and wait for a key to be pressed before showing the popup
    -- Only used by enabled xo mapping modes.
    ---@param ctx { mode: string, operator: string }
    defer = function(ctx)
      return ctx.mode == "V" or ctx.mode == "<C-V>"
    end,
    plugins = {
      marks = true, -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      spelling = {
        enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        suggestions = 20, -- how many suggestions should be shown in the list?
      },
      presets = {
        operators = true, -- adds help for operators like d, y, ...
        motions = true, -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = true, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
      },
    },
    ---@type wk.Win.opts
    win = {
      -- don't allow the popup to overlap with the cursor
      no_overlap = true,
      -- width = 1,
      -- height = { min = 4, max = 25 },
      -- col = 0,
      -- row = math.huge,
      -- border = "none",
      padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
      title = true,
      title_pos = "center",
      zindex = 1000,
      -- Additional vim.wo and vim.bo options
      bo = {},
      wo = {
        -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
      },
    },
    layout = {
      width = { min = 20, max = 40 }, -- min and max width of the columns
      spacing = 2, -- spacing between columns
    },
    keys = {
      scroll_down = "<c-d>", -- binding to scroll down inside the popup
      scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    ---@type (string|wk.Sorter)[]
    --- Mappings are sorted using configured sorters and natural sort of the keys
    --- Available sorters:
    --- * local: buffer-local mappings first
    --- * order: order of the items (Used by plugins like marks / registers)
    --- * group: groups last
    --- * alphanum: alpha-numerical first
    --- * mod: special modifier keys last
    --- * manual: the order the mappings were added
    --- * case: lower-case first
    sort = { "local", "order", "group", "alphanum", "mod" },
    ---@type number|fun(node: wk.Node):boolean?
    expand = 0, -- expand groups when <= n mappings
    -- expand = function(node)
    --   return not node.desc -- expand all nodes without a description
    -- end,
    -- Functions/Lua Patterns for formatting the labels
    ---@type table<string, ({[1]:string, [2]:string}|fun(str:string):string)[]>
    replace = {
      key = {
        function(key)
          return require("which-key.view").format(key)
        end,
        -- { "<Space>", "SPC" },
        -- { "<Space>", "<leader>" },
      },
      desc = {
        { "<Plug>%(?(.*)%)?", "%1" },
        { "^%+", "" },
        { "<[cC]md>", "" },
        { "<[cC][rR]>", "" },
        { "<[sS]ilent>", "" },
        { "^lua%s+", "" },
        { "^call%s+", "" },
        { "^:%s*", "" },
      },
    },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
      ellipsis = "…",
      -- set to false to disable all mapping icons,
      -- both those explicitly added in a mapping
      -- and those from rules
      mappings = true,
      --- See `lua/which-key/icons.lua` for more details
      --- Set to `false` to disable keymap icons from rules
      ---@type wk.IconRule[]|false
      rules = {},
      -- use the highlights from mini.icons
      -- When `false`, it will use `WhichKeyIcon` instead
      colors = true,
      -- used by key format
      keys = {
        Up = " ",
        Down = " ",
        Left = " ",
        Right = " ",
        C = "󰘴 ",
        M = "󰘵 ",
        D = "󰘳 ",
        S = "󰘶 ",
        CR = "󰌑 ",
        Esc = "󱊷 ",
        ScrollWheelDown = "󱕐 ",
        ScrollWheelUp = "󱕑 ",
        NL = "󰌑 ",
        BS = "󰁮",
        Space = "󱁐 ",
        Tab = "󰌒 ",
        F1 = "󱊫",
        F2 = "󱊬",
        F3 = "󱊭",
        F4 = "󱊮",
        F5 = "󱊯",
        F6 = "󱊰",
        F7 = "󱊱",
        F8 = "󱊲",
        F9 = "󱊳",
        F10 = "󱊴",
        F11 = "󱊵",
        F12 = "󱊶",
      },
    },
    show_help = true, -- show a help message in the command line for using WhichKey
    show_keys = true, -- show the currently pressed key and its label as a message in the command line
    -- disable WhichKey for certain buf types and file types.
    disable = {
      ft = {},
      bt = {},
    },
    debug = false, -- enable wk.log in the current directory
  })

  packadd("nvim-treesitter-textobjects")
  packadd("nvim-treesitter")

  local ts = require("nvim-treesitter")
  ts.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })
  -- ts.install("all", { summary = false }, { max_jobs = 24 }):wait(1000000)

  vim.g.no_plugin_maps = true
  -- configuration
  require("nvim-treesitter-textobjects").setup {
    select = {
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        -- ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = false,
    },
  }

  packadd("plenary.nvim")
  packadd("harpoon")

  local harpoon = require("harpoon")
  harpoon.setup({
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  })
  local harpoon_extensions = require("harpoon.extensions")
  harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
end)
