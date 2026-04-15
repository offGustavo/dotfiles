return {
  "nvim-mini/mini.nvim",
  version = false,
  config = function()
    require("mini.git").setup({})
    require("mini.pick").setup({})
    require("mini.files").setup({
      -- Customization of shown content
      content = {
        -- Predicate for which file system entries to show
        filter = nil,
        -- Highlight group to use for a file system entry
        highlight = nil,
        -- Prefix text and highlight to show to the left of file system entry
        prefix = nil,
        -- Order in which to show file system entries
        sort = nil,
      },

      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      mappings = {
        close = "q",
        go_in = "+",
        go_in_plus = "<Cr>",
        go_out = "-",
        go_out_plus = "<BS>",
        mark_goto = "'",
        mark_set = "m",
        reset = "!",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
      },

      -- General options
      options = {
        -- Whether to delete permanently or move into module-specific trash
        permanent_delete = true,
        -- Whether to use for editing directories
        use_as_default_explorer = false,
      },

      -- Customization of explorer windows
      windows = {
        -- Maximum number of windows to show side by side
        max_number = math.huge,
        -- Whether to show preview of file/directory under cursor
        preview = true,
        -- Width of focused window
        width_focus = 50,
        -- Width of non-focused window
        width_nofocus = 15,
        -- Width of preview window
        width_preview = 25,
      },
    })

    local MiniFiles = require("mini.files")
    vim.keymap.set("n", "<leader>.", function()
      local buf_name = vim.api.nvim_buf_get_name(0)
      local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
      MiniFiles.open(path)
      MiniFiles.reveal_cwd()
    end, { desc = "Open Mini Files" })
  end,
}
