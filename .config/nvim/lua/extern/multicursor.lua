return {
	"brenton-leighton/multiple-cursors.nvim",
  lazy = true,
  event = "VeryLazy",
  enabled = true,
  config = function()
    require("multiple-cursors").setup({ }) -- This causes the plugin setup function to be called
    vim.keymap.set("n", "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<Cr>")
    vim.keymap.set("n", "<C-m>", "<Cmd>MultipleCursorsLock<Cr>")
    vim.keymap.set("n", "<C-S-m>", function()
      require("multiple-cursors.virtual_cursors").set_lock(true)
      local lnum, col, curswant = 1,1,1
      require("multiple-cursors").add_cursor(lnum, col, curswant)
    end)
    vim.keymap.set("n", "<C-S-d>", "<Cmd>MultipleCursorsAddMatches<Cr>")
    vim.keymap.set("n", "<C-S-k>", "<Cmd>MultipleCursorsAddUp<Cr>")
    vim.keymap.set("n", "<C-S-j>", "<Cmd>MultipleCursorsAddDown<Cr>")
    vim.keymap.set("x", "<C-;>", "<Cmd>MultipleCursorsAddVisualArea<Cr>")
    vim.keymap.set("n", "<C-;>", "<Cmd>MultipleCursorsAddMatchesV<Cr>")
    vim.keymap.set("n", "<C-.>", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>")
    vim.keymap.set("n", "<C-,>", "<Cmd>MultipleCursorsAddJumpPrevMatch<CR>")
    vim.keymap.set("n", "<C-p>", "<Cmd>MultipleCursorsJumpPrevMatch<Cr>")
    vim.keymap.set("n", "<C-n>", "<Cmd>MultipleCursorsJumpNextMatch<Cr>")

    vim.keymap.set("n", "<C-S-d>", "<Cmd>MultipleCursorsAddMatches<Cr>")
    vim.keymap.set("n", "<C-S-k>", "<Cmd>MultipleCursorsAddUp<Cr>")
    vim.keymap.set("n", "<C-S-j>", "<Cmd>MultipleCursorsAddDown<Cr>")
    -- vim.keymap.set("x", "<C-;>", "<Cmd>MultipleCursorsAddVisualArea<Cr>")
    -- vim.keymap.set("n", "<C-;>", "<Cmd>MultipleCursorsAddMatchesV<Cr>")
    vim.keymap.set("n", "gl", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>")
    vim.keymap.set("n", "g.", "<Cmd>MultipleCursorsAddJumpPrevMatch<CR>")
    vim.keymap.set("n", "gL", "<Cmd>MultipleCursorsJumpPrevMatch<Cr>")
    vim.keymap.set("n", "g>", "<Cmd>MultipleCursorsJumpNextMatch<Cr>")
  end,
}
