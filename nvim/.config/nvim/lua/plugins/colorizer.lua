return {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      DEFAULT_OPTIONS = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        mode = "background", -- Set the display mode.
      },
    })

    -- Colorizer Config
    vim.keymap.set(
      "n",
      "<leader>oca",
      "<Cmd>ColorizerAttachToBuffer<Cr>",
      { silent = true, desc = "Colorizer Attach To Buffer" }
    )
    vim.keymap.set(
      "n",
      "<leader>ocr",
      "<Cmd>ColorizerReloadAllBuffers<Cr>",
      { silent = true, desc = "Colorizer Reload All Buffers" }
    )
    vim.keymap.set(
      "n",
      "<leader>ocd",
      "<Cmd>ColorizerDetachFromBuffer<Cr>",
      { silent = true, desc = "Colorizer Detach To Buffer" }
    )

    vim.keymap.set("n", "<leader>oct", "<Cmd>ColorizerToggle<Cr>", { silent = true, desc = "Colorizer Toggle" })
  end,
}
