return {
  "simifalaye/minibuffer.nvim",
  enabled = false,
  event = "VeryLazy",
  config = function()
    vim.ui.select = require("minibuffer.builtin.ui_select")
    vim.ui.input = require("minibuffer.builtin.ui_input")
    vim.keymap.set("n", "<M-;>", require("minibuffer.builtin.cmdline"))
    vim.keymap.set("n", "<M-.>", function()
      require("minibuffer").resume(true)
    end)
    vim.keymap.set("n", "<leader>.", require("minibuffer.examples.files"))
    vim.keymap.set("n", "<leader>,", require("minibuffer.examples.buffers"))
    vim.keymap.set("n", "<leader>/", require("minibuffer.examples.live-grep"))
    vim.keymap.set("n", "<leader>o", function()
      require("minibuffer.examples.oldfiles")({ cwd = vim.fn.getcwd() })
    end)
    vim.keymap.set("n", "<leader>O", require("minibuffer.examples.oldfiles"))
  end,
}
