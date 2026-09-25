vim.pack.add({
  -- Tokyonight
  { src = "https://github.com/folke/tokyonight.nvim" },
  -- Canola/Oil
  { src = "https://github.com/barrettruth/canola.nvim", version = "canola" },
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
  -- })
}, { load = function() end })

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

packadd("mini.nvim")
--- Mini
-- require("mini.statusline").setup()
-- require("mini.tabline").setup()
-- require('mini.statuscolumnsetup()

require("mini.icons").setup({
  -- -- Icon style: 'glyph' or 'ascii'
  -- style = 'ascii',
})
MiniIcons.mock_nvim_web_devicons()

-- Git
require("mini.git").setup({})
vim.keymap.set({ "n", "x" }, "<leader>gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", { desc = "Show at cursor" })

-- Use only HEAD name as summary string
local branch_format_summary = function(data)
  -- Utilize buffer-local table summary
  local summary = vim.b[data.buf].minigit_summary
  vim.b[data.buf].minigit_summary_string = summary.head_name or ""
end
local branch_au_opts = { pattern = "MiniGitUpdated", callback = branch_format_summary }
vim.api.nvim_create_autocmd("User", branch_au_opts)

local diff_summary = function(data)
  local summary = vim.b[data.buf].minidiff_summary
  local t = {}
  if summary.add > 0 then
    table.insert(t, "+" .. summary.add)
  end
  if summary.change > 0 then
    table.insert(t, "~" .. summary.change)
  end
  if summary.delete > 0 then
    table.insert(t, "-" .. summary.delete)
  end
  vim.b[data.buf].minidiff_summary_string = table.concat(t, " ")
end

local diff_au_opts = { pattern = "MiniDiffUpdated", callback = diff_summary }
vim.api.nvim_create_autocmd("User", diff_au_opts)

require("mini.diff").setup({
  -- Options for how hunks are visualized
  view = {
    -- Visualization style. Possible values are 'sign' and 'number'.
    -- Default: 'number' if line numbers are enabled, 'sign' otherwise.
    -- style = vim.go.number and 'number' or 'sign',
    style = "sign",
    -- Signs used for hunks with 'sign' view
    -- signs = { add = '▒', change = '▒', delete = '▒' },
    signs = { add = "+", change = "~", delete = "-" },
    -- Priority of used visualization extmarks
    priority = 1,
  },
})

require("mini.ai").setup({
  custom_textobjects = {
    -- Tweak argument textobject
    -- a = require("mini.ai").gen_spec.argument({ brackets = { "%b()" } }),

    -- Disable brackets alias in favor of builtin block textobject
    -- b = false,

    -- Now `vax` should select `xxx` and `vix` - middle `x`
    -- x = { "x()x()x" },

    -- Whole buffer
    g = function()
      local from = { line = 1, col = 1 }
      local to = {
        line = vim.fn.line("$"),
        col = math.max(vim.fn.getline("$"):len(), 1),
      }
      return { from = from, to = to }
    end,
  },
})

-- require("mini.sessions").setup({})
require("mini.surround").setup({
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    add = "sa", -- Add surrounding in Normal and Visual modes
    delete = "sd", -- Delete surrounding
    find = "sf", -- Find surrounding (to the right)
    find_left = "sF", -- Find surrounding (to the left)
    highlight = "sh", -- Highlight surrounding
    replace = "sr", -- Replace surrounding
    update_n_lines = "sn", -- Update `n_lines`
    suffix_last = "p", -- Suffix to search with "prev" method
    suffix_next = "n", -- Suffix to search with "next" method
  },
})

require("mini.move").setup({
  mappings = {
    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
    left = "<M-h>",
    right = "<M-l>",
    down = "<M-j>",
    up = "<M-k>",
  },
  -- Options which control moving behavior
  options = {
    -- Automatically reindent selection during linewise vertical move
    reindent_linewise = true,
  },
})

local hipatterns = require("mini.hipatterns")
hipatterns.setup({
  highlighters = {
    fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
    hack = { pattern = "HACK", group = "MiniHipatternsHack" },
    todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
    note = { pattern = "NOTE", group = "MiniHipatternsNote" },
    perf = { pattern = "PERF", group = "MiniIconsPurple" },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = { "n", "x" }, keys = "<Leader>" },
    { mode = { "n", "x" }, keys = "<localleader>" },
    -- `[` and `]` keys
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
    -- Built-in completion
    { mode = "i", keys = "<C-x>" },
    -- `g` key
    { mode = { "n", "x" }, keys = "g" },
    -- Marks
    { mode = { "n", "x" }, keys = "'" },
    { mode = { "n", "x" }, keys = "`" },
    -- Registers
    { mode = { "n", "x" }, keys = '"' },
    { mode = { "i", "c" }, keys = "<C-r>" },
    -- Window commands
    { mode = "n", keys = "<C-w>" },
    -- `z` key
    { mode = { "n", "x" }, keys = "z" },
  },
  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
    { mode = "n", keys = "<Leader>s", desc = "+Search" },
    { mode = "n", keys = "<Leader>f", desc = "+Find" },
    { mode = "n", keys = "<Leader>g", desc = "+Git" },
    { mode = "n", keys = "<Leader>gc", desc = "+Commit" },
    { mode = "n", keys = "<Leader>c", desc = "+Code" },
    { mode = "n", keys = "<Leader>u", desc = "+Ui" },
    -- TODO: improve this
    { mode = "n", keys = "<Leader>o", desc = "+Other" },
    { mode = "n", keys = "<Leader>t", desc = "+Terminal" },
    { mode = "n", keys = "<Leader>r", desc = "+Replace" },
    { mode = "n", keys = "<Leader>h", desc = "+Harpoon" },
    { mode = "n", keys = "<Leader><Tab>", desc = "+Tabs" },
    { mode = "n", keys = "<Leader>l", desc = "+Location List" },
    { mode = "n", keys = "<Leader>q", desc = "+Quickfix/Quit" },
  },
})

require("mini.extra").setup()
-- Centered on screen
local win_config = function()
  local height = math.floor(0.618 * vim.o.lines)
  local width = math.floor(0.618 * vim.o.columns)
  return {
    anchor = "NW",
    height = height,
    width = width,
    row = math.floor(0.5 * (vim.o.lines - height)),
    col = math.floor(0.5 * (vim.o.columns - width)),
  }
end
require("mini.pick").setup({ window = { config = win_config } })
-- vim.ui.select = ui_select_orig
vim.cmd([[
      nmap <M-o> :Pick files<Cr>
      nmap <M-s> :Pick grep_live<Cr>
      nmap <M-b> :Pick buffers<Cr>
      nmap <M-r> :Pick oldfiles<Cr>
    ]])

-- TODO: move back to blink.nvim
-- require("mini.snippets").setup()
require("mini.completion").setup()
-- require("mini.cmdline").setup()

require("mini.files").setup()
vim.keymap.set("n", "<leader>fe", function()
  require("mini.files").open()
end)

require("mini.align").setup({
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    start = "sl",
    start_with_preview = "sL",
  },

  -- -- Modifiers changing alignment steps and/or options
  -- modifiers = {
  --   -- Main option modifiers
  --   ['s'] = --<function: enter split pattern>,
  --   ['j'] = --<function: choose justify side>,
  --   ['m'] = --<function: enter merge delimiter>,
  --
  --   -- Modifiers adding pre-steps
  --   ['f'] = --<function: filter parts by entering Lua expression>,
  --   ['i'] = --<function: ignore some split matches>,
  --   ['p'] = --<function: pair parts>,
  --   ['t'] = --<function: trim parts>,
  --
  --   -- Delete some last pre-step
  --   ['<BS>'] = --<function: delete some last pre-step>,
  --
  --   -- Special configurations for common splits
  --   ['='] = --<function: enhanced setup for '='>,
  --   [','] = --<function: enhanced setup for ','>,
  --   ['|'] = --<function: enhanced setup for '|'>,
  --   [' '] = --<function: enhanced setup for ' '>,
  -- },

  -- -- Default options controlling alignment process
  -- options = {
  --   split_pattern = '',
  --   justify_side = 'left',
  --   merge_delimiter = '',
  -- },

  -- -- Default steps performing alignment (if `nil`, default is used)
  -- steps = {
  --   pre_split   = {},
  --   split       = nil,
  --   pre_justify = {},
  --   justify     = nil,
  --   pre_merge   = {},
  --   merge       = nil,
  -- },

  -- Whether to disable showing non-error feedback
  -- This also affects (purely informational) helper messages shown after
  -- idle time if user input is required.
  silent = false,
})

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

later(function()
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
end)
packadd"neogit"

map {
  -- Neogit
  { "n", "<M-G>", ":Neogit<Cr>", load = "neogit", silent = true, desc = "Neogit" },
  {
    "n",
    "<leader>cf",
    function()
      require("conform").format({
        async = true,
      })
    end,
    desc = "Format buffer",
  },

  { "<M-e>", "<Cmd>Canola<Cr>", desc = "Oil" },
  { "<leader><M-e>", "<Cmd>e.<Cr>", desc = "Open cwd" },
  { "<leader>fd", ":Canola<Cr>", desc = "Oil Explore" },

  -- FZF-lua
  { "<M-o>", "<Cmd>FzfLua files<Cr>", desc = "Find" },
  { "<M-s>", "<Cmd>FzfLua live_grep<Cr>", desc = "Grep" },
  { "<M-b>", "<Cmd>FzfLua buffers<Cr>", desc = "Buffers" },
  { "<M-r>", "<Cmd>FzfLua oldfiles<Cr>", desc = "Oldfiles" },
  { "<M-p>", "<Cmd>FzfLua global<Cr>", desc = "Global" },

  -- Builtin
  { "<leader>fa", "<Cmd>FzfLua<Cr>", desc = "Builtin" },

  -- Find
  {
    "<leader>ff",
    function()
      require("fzf-lua").files()
    end,
    desc = "Find",
  },
  {
    "<leader>fo",
    function()
      require("fzf-lua").oldfiles()
    end,
    desc = "Oldfiles",
  },
  {
    "<leader>fr",
    function() end,
    desc = "Recent",
  },

  -- Search
  {
    "<leader>ss",
    function()
      require("fzf-lua").live_grep()
    end,
    desc = "Grep",
  },
  {
    "<leader>st",
    function()
      require("fzf-lua").live_grep({
        regex = "TODO:",
      })
    end,
    desc = "Grep 'TODO:'",
  },
  {
    "<leader>sw",
    function()
      require("fzf-lua").grep_cword()
    end,
    desc = "Grep <cword>",
  },
  {
    mode = "x",
    "<leader>sw",
    function()
      require("fzf-lua").live_grep({
        -- FIXME: this can have a better parser...
        regex = require("fzf-lua").utils.get_visual_selection(),
      })
    end,
    desc = "Grep <cword>",
  },
  {
    "<leader>sW",
    function()
      require("fzf-lua").grep_cWORD()
    end,
    desc = "Grep <cWORD>",
  },
  {
    "<leader>s=",
    "<Cmd>FzfLua spell_suggest<Cr>",
    desc = "Spell suggest",
  },

  -- Buffers
  {
    "<leader>bb",
    function()
      require("fzf-lua").buffers()
    end,
    desc = "Buffers",
  },
  {
    "<leader>bs",
    function()
      require("fzf-lua").lines()
    end,
    desc = "Buffers",
  },
  {
    "<leader>bw",
    function()
      require("fzf-lua").grep_curbuf({
        regex = vim.fn.expand("<cWord>"),
      })
    end,
    desc = "Vimgrep TODO: mod after",
  },
  {
    "<leader>bW",
    function()
      require("fzf-lua").grep_curbuf({
        regex = vim.fn.expand("<cWORD>"),
      })
    end,
    desc = "Vimgrep TODO: mod after",
  },
  {
    mode = "x",
    "<leader>bw",
    function()
      require("fzf-lua").grep_curbuf({
        -- regex = vim.fn.expand("<cWORD>"),
        search = require("fzf-lua").utils.get_visual_selection(),
      })
    end,
    desc = "Vimgrep TODO: mod after",
  },
  -- TODO: use lgrep_curbuf or locxation

  -- Git
  {
    "<leader>gf",
    "<Cmd>FzfLua git_files<Cr>",
    desc = "Git files",
  },
  {
    "<leader>gb",
    "<Cmd>FzfLua git_branches<Cr>",
    desc = "Git Branches",
  },
  {
    "<leader>gl",
    false,
  },
  -- TODO: add more git things...

  -- Vim
  {
    "<leader>vf",
    function()
      require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
    end,
    desc = "Find in config files",
  },
  {
    "<leader>vs",
    function()
      require("fzf-lua").live_grep({ cwd = vim.fn.stdpath("config") })
    end,
    desc = "Grep in config files",
  },
  {
    "<leader>vh",
    "<Cmd>FzfLua helptags<Cr>",
    desc = "Helptags",
  },
  {
    "<leader>vH",
    "<Cmd>FzfLua highlights<Cr>",
    desc = "Highlights",
  },
  {
    "<leader>vt",
    function()
      require("fzf-lua").colorschemes()
    end,
    desc = "Colorschemes",
  },

  --- Agenda/Notes
  {
    "<leader>af",
    function()
      require("fzf-lua").files({ cwd = "~/Notes/" })
    end,
    desc = "Find in ~/Notes",
  },
  {
    "<leader>as",
    function()
      require("fzf-lua").live_grep({ cwd = "~/Notes/" })
    end,
    desc = "Grep in ~/Notes",
  },
  {
    "<leader>at",
    function()
      require("fzf-lua").live_grep({
        cwd = "~/Notes/",
        regex = "TODO:",
      })
    end,
    desc = "Search TODO's in ~/Notes",
  },
}
