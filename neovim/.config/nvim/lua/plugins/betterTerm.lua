return {
  "CRAG666/betterTerm.nvim",
  -- dir = "~/Projetos/betterTerm.nvim/",
  -- name = "betterTerm",
  -- "offGustavo/betterTerm.nvim",
  -- branch = "index_number",
  opts = {
    position = "bot",
    size = 15,
  },

  config = function()
    require("betterTerm").setup({
      prefix = "Term_",
      position = "bot",
      size = 18,
      startInserted = true,
      show_tabs = true,
      new_tab_mapping = "<A-n>", -- Create new terminal
      jump_tab_mapping = "<A-$tab>", -- Jump to tab terminal
      active_tab_hl = "TabLineSel", -- Highlight group for active tab
      inactive_tab_hl = "TabLine", -- Highlight group for inactive tabs
      new_tab_hl = "BetterTermSymbol", -- Highlight group for new term
      new_tab_icon = "+", -- Icon for new term
      index_base = 1, -- Index number for terminals
    })
    local betterTerm = require("betterTerm")
    -- toggle firts term
    vim.keymap.set({ "n", "t" }, "<A-/>", betterTerm.open, { desc = "Open terminal" })
    -- Select term focus
    vim.keymap.set({ "n" }, "<leader>tt", betterTerm.select, { desc = "Select terminal" })
  end,
}
