vim.pack.add({
  -- Tokyonight
  { src = "https://github.com/folke/tokyonight.nvim" },
  -- Canola/Oil
  { src = "https://github.com/barrettruth/canola.nvim", version = "canola" },
  -- Snacks
  { src = "https://github.com/folke/snacks.nvim" },
})

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

require("snacks").setup({
    bigfile = { enabled = true },
    dashboard = {
      enabled = false,
      preset = {
        header = [[
 ███     █████                       ███  ████ 
░███    ░░███                       ░░░  ░░███ 
░███  ███████   ██████  █████ █████ ████  ░███ 
░███ ███░░███  ███░░███░░███ ░░███ ░░███  ░███ 
░███░███ ░███ ░███████  ░███  ░███  ░███  ░███ 
░░░ ░███ ░███ ░███░░░   ░░███ ███   ░███  ░███ 
 ███░░████████░░██████   ░░█████    █████ █████
░░░  ░░░░░░░░  ░░░░░░     ░░░░░    ░░░░░ ░░░░░ 
        ]],
      },
      sections = {
        { section = "header" },
        {
          section = "startup",
          padding = { 1, 0 },
        },
      },
    },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = false },
    image = { enabled = true },
    notifier = {
      enabled = false,
      timeout = 3000,
    },
    picker = {
      enabled = true,
      layout = "ivy_split",
    },
    layout = {
      ivy_split = {
        preview = "main",
        layout = {
          box = "vertical",
          backdrop = false,
          width = 0,
          height = 0.4,
          position = "bottom",
          border = "top",
          title = " {title} {live} {flags}",
          title_pos = "left",
          { win = "input", height = 1, border = "none" },
          {
            box = "horizontal",
            { win = "list",    border = "none" },
            { win = "preview", title = "{preview}", width = 0.6, border = "left" },
          },
        },
      },
    },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = {
      enabled = false,
      left = { "mark", "sign" }, -- priority of signs on the left (high to low)
      right = { "fold", "git" }, -- priority of signs on the right (high to low)
      folds = {
        open = false,         -- show open fold icons
        git_hl = true,        -- use Git Signs hl for fold icons
      },
      git = {
        -- patterns to match Git signs
        patterns = { "GitSign", "MiniDiffSign" },
      },
      refresh = 50, -- refresh at most every 50ms
    },
    words = { enabled = false },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      },
    },
  })

  map({
  	-- Top Pickers & Explorer
  	{
  		"<M-p>",
  		function()
  			Snacks.picker.smart()
  		end,
  		desc = "Smart Find Files",
  	},
  	{
  		"<M-o>",
  		function()
  			Snacks.picker.files()
  		end,
  		desc = "Smart Find Files",
  	},
  	{
  		"<M-b>",
  		function()
  			Snacks.picker.buffers()
  		end,
  		desc = "Buffers",
  	},
  	{
  		"<M-s>",
  		function()
  			Snacks.picker.grep()
  		end,
  		desc = "Grep",
  	},
  	{
  		"<leader>fa",
  		function()
  			Snacks.picker()
  		end,
  		desc = "Builtin",
  	},
  	{
  		"<leader>s:",
  		function()
  			Snacks.picker.command_history()
  		end,
  		desc = "Command History",
  	},
  	{
  		"<leader>sn",
  		function()
  			Snacks.picker.notifications()
  		end,
  		desc = "Notification History",
  	},
  	{
  		"<leader>fe",
  		function()
  			Snacks.explorer()
  		end,
  		desc = "File Explorer",
  	},
  	-- find
  	{
  		"<leader>fc",
  		function()
  			Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
  		end,
  		desc = "Find Config File",
  	},
  	{
  		"<leader>ff",
  		function()
  			Snacks.picker.files()
  		end,
  		desc = "Find Files",
  	},
  	{
  		"<leader>fg",
  		function()
  			Snacks.picker.git_files()
  		end,
  		desc = "Find Git Files",
  	},
  	{
  		"<leader>fp",
  		function()
  			Snacks.picker.projects()
  		end,
  		desc = "Projects",
  	},
  	{
  		"<leader>fr",
  		function()
  			Snacks.picker.recent()
  		end,
  		desc = "Recent",
  	},

  	-- git
  	{
  		"<leader>gb",
  		function()
  			Snacks.picker.git_branches()
  		end,
  		desc = "Git Branches",
  	},
  	{
  		"<leader>gl",
  		function()
  			Snacks.picker.git_log()
  		end,
  		desc = "Git Log",
  	},
  	{
  		"<leader>gL",
  		function()
  			Snacks.picker.git_log_line()
  		end,
  		desc = "Git Log Line",
  	},
  	{
  		"<leader>gs",
  		function()
  			Snacks.picker.git_status()
  		end,
  		desc = "Git Status",
  	},
  	{
  		"<leader>gS",
  		function()
  			Snacks.picker.git_stash()
  		end,
  		desc = "Git Stash",
  	},
  	{
  		"<leader>gd",
  		function()
  			Snacks.picker.git_diff()
  		end,
  		desc = "Git Diff (Hunks)",
  	},
  	{
  		"<leader>gf",
  		function()
  			Snacks.picker.git_log_file()
  		end,
  		desc = "Git Log File",
  	},

  	-- gh
  	{
  		"<leader>gi",
  		function()
  			Snacks.picker.gh_issue()
  		end,
  		desc = "GitHub Issues (open)",
  	},
  	{
  		"<leader>gI",
  		function()
  			Snacks.picker.gh_issue({ state = "all" })
  		end,
  		desc = "GitHub Issues (all)",
  	},
  	{
  		"<leader>gp",
  		function()
  			Snacks.picker.gh_pr()
  		end,
  		desc = "GitHub Pull Requests (open)",
  	},
  	{
  		"<leader>gP",
  		function()
  			Snacks.picker.gh_pr({ state = "all" })
  		end,
  		desc = "GitHub Pull Requests (all)",
  	},

  	-- Grep
  	{
  		"<leader>sb",
  		function()
  			Snacks.picker.lines()
  		end,
  		desc = "Buffer Lines",
  	},
  	{
  		"<leader>sg",
  		function()
  			Snacks.picker.grep()
  		end,
  		desc = "Grep",
  	},
  	{
  		"<leader>sw",
  		function()
  			Snacks.picker.grep_word()
  		end,
  		desc = "Visual selection or word",
  		mode = { "n", "x" },
  	},

  	-- search
  	{
  		'<leader>s"',
  		function()
  			Snacks.picker.registers()
  		end,
  		desc = "Registers",
  	},
  	{
  		"<leader>s/",
  		function()
  			Snacks.picker.search_history()
  		end,
  		desc = "Search History",
  	},
  	{
  		"<leader>sa",
  		function()
  			Snacks.picker.autocmds()
  		end,
  		desc = "Autocmds",
  	},
  	{
  		"<leader>sb",
  		function()
  			Snacks.picker.lines()
  		end,
  		desc = "Buffer Lines",
  	},
  	{
  		"<leader>sc",
  		function()
  			Snacks.picker.command_history()
  		end,
  		desc = "Command History",
  	},
  	{
  		"<leader>sC",
  		function()
  			Snacks.picker.commands()
  		end,
  		desc = "Commands",
  	},
  	{
  		"<leader>sd",
  		function()
  			Snacks.picker.diagnostics()
  		end,
  		desc = "Diagnostics",
  	},
  	{
  		"<leader>sh",
  		function()
  			Snacks.picker.help()
  		end,
  		desc = "Help Pages",
  	},
  	{
  		"<leader>sH",
  		function()
  			Snacks.picker.highlights()
  		end,
  		desc = "Highlights",
  	},
  	{
  		"<leader>si",
  		function()
  			Snacks.picker.icons()
  		end,
  		desc = "Icons",
  	},
  	{
  		"<leader>sj",
  		function()
  			Snacks.picker.jumps()
  		end,
  		desc = "Jumps",
  	},
  	{
  		"<leader>sk",
  		function()
  			Snacks.picker.keymaps()
  		end,
  		desc = "Keymaps",
  	},
  	{
  		"<leader>sl",
  		function()
  			Snacks.picker.loclist()
  		end,
  		desc = "Location List",
  	},
  	{
  		"<leader>sm",
  		function()
  			Snacks.picker.marks()
  		end,
  		desc = "Marks",
  	},
  	{
  		"<leader>sM",
  		function()
  			Snacks.picker.man()
  		end,
  		desc = "Man Pages",
  	},
  	{
  		"<leader>sp",
  		function()
  			Snacks.picker.lazy()
  		end,
  		desc = "Search for Plugin Spec",
  	},
  	{
  		"<leader>sq",
  		function()
  			Snacks.picker.qflist()
  		end,
  		desc = "Quickfix List",
  	},
  	{
  		"<leader>sR",
  		function()
  			Snacks.picker.resume()
  		end,
  		desc = "Resume",
  	},
  	{
  		"<leader>su",
  		function()
  			Snacks.picker.undo()
  		end,
  		desc = "Undo History",
  	},

  	{
  		"<leader>uC",
  		function()
  			Snacks.picker.colorschemes()
  		end,
  		desc = "Colorschemes",
  	},

  	-- LSP
  	{
  		"gd",
  		function()
  			Snacks.picker.lsp_definitions()
  		end,
  		desc = "Goto Definition",
  	},
  	{
  		"gD",
  		function()
  			Snacks.picker.lsp_declarations()
  		end,
  		desc = "Goto Declaration",
  	},
  	{
  		"gr",
  		function()
  			Snacks.picker.lsp_references()
  		end,
  		nowait = true,
  		desc = "References",
  	},
  	{
  		"gI",
  		function()
  			Snacks.picker.lsp_implementations()
  		end,
  		desc = "Goto Implementation",
  	},
  	{
  		"gy",
  		function()
  			Snacks.picker.lsp_type_definitions()
  		end,
  		desc = "Goto T[y]pe Definition",
  	},
  	{
  		"gai",
  		function()
  			Snacks.picker.lsp_incoming_calls()
  		end,
  		desc = "C[a]lls Incoming",
  	},
  	{
  		"gao",
  		function()
  			Snacks.picker.lsp_outgoing_calls()
  		end,
  		desc = "C[a]lls Outgoing",
  	},
  	{
  		"<leader>ss",
  		function()
  			Snacks.picker.lsp_symbols()
  		end,
  		desc = "LSP Symbols",
  	},
  	{
  		"<leader>sS",
  		function()
  			Snacks.picker.lsp_workspace_symbols()
  		end,
  		desc = "LSP Workspace Symbols",
  	},

  	-- Buffers
  	{
  		"<leader>bd",
  		function()
  			Snacks.bufdelete()
  		end,
  		desc = "Delete Buffer",
  	},
  	{
  		"<leader>bc",
  		function()
  			Snacks.picker.diagnostics_buffer()
  		end,
  		desc = "Buffer Diagnostics",
  	},
  	{
  		"<leader>bg",
  		function()
  			Snacks.picker.grep_buffers()
  		end,
  		desc = "Grep Open Buffers",
  	},
  	{
  		"<leader>bl",
  		function()
  			Snacks.picker.buffers()
  		end,
  		desc = "Buffers",
  	},

  	-- Other
  	{
  		"<leader>uz",
  		function()
  			Snacks.zen()
  		end,
  		desc = "Toggle Zen Mode",
  	},
  	{
  		"<leader>uZ",
  		function()
  			Snacks.zen.zoom()
  		end,
  		desc = "Toggle Zoom",
  	},
  	{
  		"<leader>fs",
  		function()
  			Snacks.scratch()
  		end,
  		desc = "Toggle Scratch Buffer",
  	},
  	{
  		"<leader>fS",
  		function()
  			Snacks.scratch.select()
  		end,
  		desc = "Select Scratch Buffer",
  	},
  	{
  		"<leader>uN",
  		function()
  			Snacks.notifier.show_history()
  		end,
  		desc = "Notification History",
  	},
  	{
  		"<leader>fR",
  		function()
  			Snacks.rename.rename_file()
  		end,
  		desc = "Rename File",
  	},
  	{
  		"<leader>gB",
  		function()
  			Snacks.gitbrowse()
  		end,
  		desc = "Git Browse",
  		mode = { "n", "v" },
  	},
  	{
  		"<leader>gg",
  		function()
  			Snacks.lazygit()
  		end,
  		desc = "Lazygit",
  	},
  	{
  		"<leader>un",
  		function()
  			Snacks.notifier.hide()
  		end,
  		desc = "Dismiss All Notifications",
  	},
  	{
  		"<c-/>",
  		function()
  			Snacks.terminal()
  		end,
  		desc = "Toggle Terminal",
  	},
  	{
  		"<c-_>",
  		function()
  			Snacks.terminal()
  		end,
  		desc = "which_key_ignore",
  	},
  	{
  		"]]",
  		function()
  			Snacks.words.jump(vim.v.count1)
  		end,
  		desc = "Next Reference",
  		mode = { "n", "t" },
  	},
  	{
  		"[[",
  		function()
  			Snacks.words.jump(-vim.v.count1)
  		end,
  		desc = "Prev Reference",
  		mode = { "n", "t" },
  	},
  	{
  		"<leader>N",
  		desc = "Neovim News",
  		function()
  			Snacks.win({
  				file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
  				width = 0.6,
  				height = 0.6,
  				wo = {
  					spell = false,
  					wrap = false,
  					signcolumn = "yes",
  					statuscolumn = " ",
  					conceallevel = 3,
  				},
  			})
  		end,
  	},
  })

vim.keymap.set("n", "<M-e>", "<Cmd>Canola<CR>", { desc = "Canola.nvim"})

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
