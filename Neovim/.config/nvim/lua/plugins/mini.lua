return {
  "nvim-mini/mini.nvim",
  version = false,
  config = function()
    require("mini.pick").setup()
    local MiniFiles = require("mini.files")
    vim.keymap.set("n", "<leader>.", function()
      local buf_name = vim.api.nvim_buf_get_name(0)
      local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
      MiniFiles.open(path)
      MiniFiles.reveal_cwd()
    end, { desc = "Open Mini Files" })
  end,
}
