return {
  { "https://github.com/folke/lazydev.nvim", ft = "lua", opts = {} },
  {
    "https://github.com/Saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        per_filetype = { lua = { inherit_defaults = true, "lazydev" } },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
    },
  },
}
