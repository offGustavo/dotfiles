return {
  "nvim-mini/mini.surround",
  vscode = true,
  keys = function(_, keys)
    -- Populate the keys based on the user's options
    local opts = LazyVim.opts("mini.surround")
    local mappings = {
      { opts.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
      { opts.mappings.delete, desc = "Delete Surrounding" },
      { opts.mappings.find, desc = "Find Right Surrounding" },
      { opts.mappings.find_left, desc = "Find Left Surrounding" },
      { opts.mappings.highlight, desc = "Highlight Surrounding" },
      { opts.mappings.replace, desc = "Replace Surrounding" },
      { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
    }
    mappings = vim.tbl_filter(function(m)
      return m[1] and #m[1] > 0
    end, mappings)
    return vim.list_extend(mappings, keys)
  end,
  opts = {
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      add = "<localleader>sa", -- Add surrounding in Normal and Visual modes
      delete = "<localleader>sd", -- Delete surrounding
      find = "<localleader>sf", -- Find surrounding (to the right)
      find_left = "<localleader>sF", -- Find surrounding (to the left)
      highlight = "<localleader>sh", -- Highlight surrounding
      replace = "<localleader>sr", -- Replace surrounding
      update_n_lines = "<localleader>sn", -- Update `n_lines`
      suffix_last = "p", -- Suffix to search with "prev" method
      suffix_next = "n", -- Suffix to search with "next" method
    },
  },
}
