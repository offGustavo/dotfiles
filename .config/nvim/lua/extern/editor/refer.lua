return {
  "juniorsundar/refer.nvim",
  enabled = true,
  dependencies = {
    -- Optional:
    -- "saghen/blink.cmp",
    -- "nvim-mini/mini.fuzzy",
  },
  opts = {
    -- General Settings
    max_height_percent = 0.4, -- Window height (0.1 - 1.0)
    min_height = 1, -- Minimum lines

    -- Async Settings
    debounce_ms = 10, -- Delay for async searching
    min_query_len = 1, -- Min chars to start async search

    -- Sorting
    available_sorters = { "blink", "mini", "native", "lua" },
    default_sorter = "blink",

    -- Preview Settings
    preview = {
      enabled = true,
      max_lines = 1000,
    },

    -- UI Customization
    ui = {
      mark_char = ">",
      mark_hl = "LineNrStrine",
      input_position = "bottom", -- "top" or "bottom"
      reverse_result = false,
      winhighlight = "Normal:Normal,FloatBorder:Normal,WinSeparator:Normal,StatusLine:Normal,StatusLineNC:Normal",
      highlights = {
        prompt = "Title",
        selection = "Visual",
        header = "WarningMsg",
      },
    },

    -- Provider Configuration
    providers = {
      files = {
        ignored_dirs = { ".git", ".jj", "node_modules", ".cache" },
        find_command = { "fd", "-H", "--type", "f", "--color", "never" },
      },
      grep = {
        grep_command = { "rg", "--vimgrep" },
      },
    },

    -- Extras (all disabled by default)
    extras = {
      find_file = true, -- set to true to register :Refer Extras FindFile
    },

    -- See "Tutorials" section for keymaps, custom_sorters, and custom_parsers
  },
  keys = {
    { "<leader>pa", ":Refer<Space>" },
    { "<leader>pf", "<Cmd>Refer Files<Cr>" },
    { "<leader>ps", "<Cmd>Refer Grep<Cr>" },
    { "<leader>p.", "<Cmd>Refer Extra FindFile<Cr>" },
    { "<leader>pw", "<Cmd>Refer Selection<Cr>" },
  },
}
