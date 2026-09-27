-- REF: https://www.reddit.com/r/NixOS/comments/1raqini/i_built_a_vs_code_extension_that_brings_syntax/
return {
  "https://github.com/nvim-treesitter/nvim-treesitter",
  enabled = function()
    -- If in windows, we dont use treesitter
    if vim.fn.has("win64") == 1 then
      return false
    end
    return true
  end,
  branch = "main",
  dependencies = {
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

      -- keymaps
      -- You can use the capture groups defined in `textobjects.scm`
      vim.keymap.set({ "x", "o" }, "am", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "im", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ac", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ic", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
      end)
      -- You can also use captures from other query groups like `locals.scm`
      vim.keymap.set({ "x", "o" }, "as", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
      end)
    end,
  },
  event = "VeryLazy",
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })
    -- ts.install("all", { summary = false }, { max_jobs = 24 }):wait(1000000)
  end,
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        if pcall(vim.treesitter.start) then
          -- Only highlight with treesitter
          vim.cmd("syntax off")
          -- Indent expérimental
          vim.bo[0].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          -- Folds
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
      end,
    })
  end,
}
