-- return {}

return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  config = function()
    require("markview").setup({
      preview = {
        modes = { "n", "no", "c" },
        hybrid_modes = { "n", "v" },
        linewise_hybrid_mode = true,
      },
    })

    -- -- Markview Keymaps
    -- require("which-key").add({
    --   { "<leader>m", group = "Markdown", mode = "n", icon = "" },
    --
    -- })
    vim.keymap.set({ "n", "v" }, "<leader>omm", "<cmd>Markview Toggle<CR>", { silent = true, desc = "Toggle Markview" })
    vim.keymap.set(
      { "n", "v" },
      "<leader>omh",
      "<cmd>Markview hybridToggle<CR>",
      { silent = true, desc = "Toggle Hybrid Mode" }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>omp",
      "<cmd>Markview splitToggle<CR>",
      { silent = true, desc = "Toggle Split View" }
    )
  end,
}
