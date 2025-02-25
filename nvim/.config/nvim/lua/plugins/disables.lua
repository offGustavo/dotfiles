local minimal = false

if minimal then
  return {
    -- {
    --   "akinsho/bufferline.nvim",
    --   enabled = false,
    -- },
    {
      "nvim-lualine/lualine.nvim",
      enabled = false,
    },
    {
      "folke/noice.nvim",
      enabled = false,
    },
  }
else
  return {}
end
