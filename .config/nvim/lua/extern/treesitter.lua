if is_windows() then
  return
end

later(function()
  packadd { "ts-comments.nvim", "nvim-treesitter-textobjects", "nvim-treesitter" }

  local ts = require("nvim-treesitter")
  ts.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })

  ts.install("all", { summary = false }, { max_jobs = 24 }):wait(1000000)

  -- ts.install({
  --   "rust",
  --   "javascript",
  --   "zig",
  --   "lua",
  --   "markdown",
  --   "vim",
  --   "c"
  -- }):wait(300000) -- max. 5 minutes

  require("ts-comments").setup()

  -- vim.g.no_plugin_maps = true
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

  map {

    -- FIX: move this keymaps to map {}
    -- You can use the capture groups defined in `textobjects.scm`
    {
      { "x", "o" },
      "am",
      function()
        require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
      end,
    },
    {
      { "x", "o" },
      "im",
      function()
        require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
      end,
    },
    {
      { "x", "o" },
      "ac",
      function()
        require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
      end,
    },
    {
      { "x", "o" },
      "ic",
      function()
        require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
      end,
    },
  }
  -- You can also use captures from other query groups like `locals.scm`
  -- vim.keymap.set({ "x", "o" }, "as", function() require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals") end)
end)
