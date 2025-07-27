return {
  {
    "jghauser/kitty-runner.nvim",
    config = function()
      require("kitty-runner").setup()
    end,
  },
  -- Lua (chameleon.lua)
  {
    "shaun-mathew/Chameleon.nvim",
    config = function()
      require("chameleon").setup()
    end,
  },
}
