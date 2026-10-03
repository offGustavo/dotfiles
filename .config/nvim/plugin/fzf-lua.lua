later(function()
  packadd "fzf-lua"
  require("fzf-lua").setup({
    {
      "ivy",
      -- "fzf-native",
      "telescope",
      "hide",
    },
    -- Window options for Ivy layout
    winopts = {
      -- Ivy style: no floating window borders
      border = "none",
      -- Height relative to screen (use full height)
      height = 1.0,
      -- Width relative to screen
      width = 1.0,
      -- Row position: 1.0 pushes it to bottom
      row = 1.0,
      -- Column position
      col = 0.5,
      -- Preview options
      preview = {
        hidden = true,
        -- Preview window position (ivy style: preview above results)
        vertical = "up:70%",
        -- Preview border
        border = "none",
        -- Preview layout
        layout = "vertical",
      },
      -- Disable Treesitter in the picker window for performance
      treesitter = false,
    },
    ui_select = {
      winopts = {
        height = 0.3,
      },
    },
    colorschemes = {
      winopts = { height = 0.55, width = 0.50, col = 0.5, row = 0.0, backdrop = false },
    },
    fzf_opts = {
      ["--sort"] = false,
    },
    fzf_colors = {
      true, -- inherit fzf colors that aren't specified below from
    },
  })
end)
