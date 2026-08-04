vim.pack.add({
  -- Tokyonight
  { src = "https://github.com/folke/tokyonight.nvim" },
  -- Canola/Oil
  { src = "https://github.com/barrettruth/canola.nvim", version = "canola" },
  -- Telescope
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
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

local telescope_builtin = require("telescope.builtin")
vim.keymap.set('n', "<M-o>", function() telescope_builtin.find_files() end ,  { desc = "Telescope find files" })
vim.keymap.set('n', "<M-s>", function() telescope_builtin.live_grep () end ,  { desc = "Telescope live grep" })
vim.keymap.set('n', "<M-b>", function() telescope_builtin.buffers   () end ,  { desc = "Telescope buffers" })
vim.keymap.set('n', "<leader>ff", function() telescope_builtin.find_files() end ,  { desc = "Telescope find files" })
vim.keymap.set('n', "<leader>ss", function() telescope_builtin.live_grep () end ,  { desc = "Telescope live grep" })
vim.keymap.set('n', "<leader>bb", function() telescope_builtin.buffers   () end ,  { desc = "Telescope buffers" })
vim.keymap.set('n', "<leader>vh", function() telescope_builtin.help_tags () end ,  { desc = "Telescope help tags" })
vim.keymap.set('n', "<leader>fa", function() telescope_builtin.builtin   () end ,  { desc = "Telescope" })
