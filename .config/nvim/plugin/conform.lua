vim.schedule(function()
  vim.pack.add({
    "https://github.com/stevearc/conform.nvim",
  })
  vim.keymap.set("n",   -- Customize or remove this keymap to your liking
  "<leader>cf", function()
    require("conform").format({
      async = true
    })
  end, {
  desc = "Format buffer"
})

  require("conform").setup({
    -- Define your formatters
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "nixfmt" },
      python = { "isort", "black" },
      javascript = {
        "prettierd",
        "prettier",
        stop_after_first = true
      }
    },
    -- Set default options
    default_format_opts = {
      lsp_format = "fallback"
    },
    -- Set up format-on-save
    -- format_on_save = {},
    -- Customize formatters
    formatters = {
      shfmt = {
        append_args = { "-i", "2" }
      }
    }
  })

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end)
