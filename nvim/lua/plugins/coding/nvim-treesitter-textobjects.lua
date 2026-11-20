-- REF: https://www.reddit.com/r/NixOS/comments/1raqini/i_built_a_vs_code_extension_that_brings_syntax/
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = "VeryLazy",
  init = function()
    vim.g.no_plugin_maps = true
  end,
  config = function()
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
  end,
  -- keymaps
  -- You can use the capture groups defined in `textobjects.scm`

  -- keys = function()
  --   local select_textobject = require("nvim-treesitter-textobjects.select").select_textobject
  --   return {
  --     -- stylua: ignore start
  --     { "am", function() select_textobject("@function.outer", "textobjects") end, mode = { "x", "o" }, },
  --     { "im", function() select_textobject("@function.inner", "textobjects") end, mode = { "x", "o" }, },
  --     { "ac", function() select_textobject("@class.outer", "textobjects")    end, mode = { "x", "o" }, },
  --     { "ic", function() select_textobject("@class.inner", "textobjects")    end, mode = { "x", "o" }, },
  --     { "as", function() select_textobject("@local.scope", "locals")         end, mode = { "x", "o" }, },
  --     -- You can also use captures from other query groups like `locals.scm`
  --     --- stylua: ignore end
  --   }
  -- end,
}

-- {
--   "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
--   lazy = true,
--   event = "VeryLazy",
--   config = function()
--     -- vim.g.no_plugin_maps = true
--     -- configuration
--     require("nvim-treesitter-textobjects").setup {
--       select = {
--         -- Automatically jump forward to textobj, similar to targets.vim
--         lookahead = true,
--         -- You can choose the select mode (default is charwise 'v')
--         --
--         -- Can also be a function which gets passed a table with the keys
--         -- * query_string: eg '@function.inner'
--         -- * method: eg 'v' or 'o'
--         -- and should return the mode ('v', 'V', or '<c-v>') or a table
--         -- mapping query_strings to modes.
--         selection_modes = {
--           ["@parameter.outer"] = "v", -- charwise
--           ["@function.outer"] = "V", -- linewise
--           -- ['@class.outer'] = '<c-v>', -- blockwise
--         },
--         -- If you set this to `true` (default is `false`) then any textobject is
--         -- extended to include preceding or succeeding whitespace. Succeeding
--         -- whitespace has priority in order to act similarly to eg the built-in
--         -- `ap`.
--         --
--         -- Can also be a function which gets passed a table with the keys
--         -- * query_string: eg '@function.inner'
--         -- * selection_mode: eg 'v'
--         -- and should return true of false
--         include_surrounding_whitespace = false,
--       },
--     }
--   end,
--   -- You can also use captures from other query groups like `locals.scm`
--   -- vim.keymap.set({ "x", "o" }, "as", function() require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals") end)
--   keys = {
--     {
--       "am",
--       function()
--         require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
--       end,
--       mode = { "x", "o" },
--     },
--     {
--       "im",
--       function()
--         require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
--       end,
--       mode = { "x", "o" },
--     },
--     {
--       "ac",
--       function()
--         require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
--       end,
--       mode = { "x", "o" },
--     },
--     {
--       "ic",
--       function()
--         require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
--       end,
--       mode = { "x", "o" },
--     },
--   },
-- },
