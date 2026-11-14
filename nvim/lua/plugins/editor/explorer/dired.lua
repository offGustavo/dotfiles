return {
  -- "https://github.com/X3eRo0/dired.nvim",
  dir = "~/Projects/dired.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  lazy = false,
  cmd = "Dired",
  event = "VeryLazy",
  -- Set up the 'dired' plugin with custom options
  opts = {
    path_separator = "/", -- Use '/' as the path separator
    show_hidden = true, -- Show hidden files
    show_icons = false, -- Show icons (patched font required)
    show_banner = false, -- Do not show the banner
    hide_details = false, -- Show file details by default
    sort_order = "name", -- Sort files by name by default
    override_cwd = false, -- Override cwd by default

    -- Define keybindings for various 'dired' actions
    keybinds = {
      dired_enter = "<CR>",
      dired_back = "-",
      dired_up = "_",
      dired_rename = "R",
      -- ... (add more keybindings as needed)
      dired_quit = "q",
    },

    -- -- Define colors for different file types and attributes
    -- colors = {
    --   DiredDimText = { link = {}, bg = "NONE", fg = "505050", gui = "NONE" },
    --   DiredDirectoryName = { link = {}, bg = "NONE", fg = "9370DB", gui = "NONE" },
    --   -- ... (define more colors as needed)
    --   DiredMoveFile = { link = {}, bg = "NONE", fg = "ff3399", gui = "bold" },
    -- },
  },
}
