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
    }):wait(300000) -- max. 5 minutes
  end,
}
