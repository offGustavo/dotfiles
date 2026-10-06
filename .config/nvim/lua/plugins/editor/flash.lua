return {
  "folke/flash.nvim",
  ---@type Flash.Config
  opts = {},
  keys = {
    { "se",    mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    { "SE",    mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "sr",     mode = { "o", "x" },               function() require("flash").remote() end,            desc = "Remote Flash" },
    { "SR",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    {
      "<c-space>",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter({
          actions = {
            ["<c-space>"] = "next",
            ["<BS>"] = "prev"
          }
        })
      end,
      desc = "Treesitter Incremental Selection"
    },
  },
}
