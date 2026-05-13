vim.schedule(function()
  require("fish.yazi").setup({
    enable_cmds = true,
    replace_netrw = false,
    ui = {
      border = "rounded",
      height = 0.9,
      width = 0.9,
      x = 0.5,
      y = 0.5,
    },
    keybindings = {},
  })

  -- require("forge.easymode")

  -- require("forge.espeto").setup()

  -- vim.keymap.set("n", "<leader>v", function()
  --   require("forge.vidir").open()
  -- end)

  -- require("forge.align")

  require("fish.lazygit").setup({
    ui = {
      border = "rounded",
      height = 0.9,
      width = 0.9,
    },
    keybindings = {
      -- ["<C-h>"] = "<C-\\><C-n><C-w>h", -- navigate left
      -- ["<C-l>"] = "<C-\\><C-n><C-w>l", -- navigate right
    },
    on_exit = function()
      vim.cmd("checktime")    -- refresh buffers if files changed
    end,
    enable_cmds = true,
  })

  require("fish.tabterm").setup({
    -- Winbar Config
    separator_right = "",
    separator_left = "",
    separator_first = "",
    center = true,
    default_highlight = "%#Normal#",
    tab_highlight = "%#TablineSel#",
    -- Window Config
    vertical_size = 20,
    float = false,
    default_maps = true
  })
end)
