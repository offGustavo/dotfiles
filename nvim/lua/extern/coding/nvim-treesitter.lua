return {
  "https://github.com/nvim-treesitter/nvim-treesitter",
  enabled = executable("tree-sitter"),
  lazy = true,
  event = "VeryLazy",
  build = function()
    require("nvim-treesitter").update()
  end,
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- ts.install("all", { summary = false }, { max_jobs = 24 }):wait(1000000)

    ts.install({
      "rust",
      "java",
      "javascript",
      "zig",
      "lua",
      "markdown",
      "vim",
      "c",
      "kdl",
      "bash",
      "html",
      "css",
      "json",
      "nix",
    }):wait(300000) -- max. 5 minutes

    --- Initial default and runtime state tracker for syntax highlighting mode.
    --- Controls if Treesitter and LSP semantic highlighting are enabled.
    ---
    --- @type boolean
    ---
    --- @usage
    --- ```lua
    --- -- Enable Treesitter + LSP semantic tokens
    --- Fish.highlight_state = true
    ---
    --- -- Fallback to classic Vim syntax only
    --- Fish.highlight_state = false
    --- ```
    Fish.highlight_state = true

    require("config.syntax_highlight")
  end,
}
