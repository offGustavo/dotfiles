-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.vscode then
else
  vim.cmd("colorscheme tokyonight-night")

  require("which-key").add({
    { "<leader>t", group = "Terminal" },
    { "<leader><space>", hidden = true }, -- hide this keymap
    { "<leader><Cr>", hidden = true }, -- hide this keymap
    { "<leader>L", hidden = true },
    { "<leader>-", hidden = true },
    { "<leader>|", hidden = true },
    { "<leader>?", hidden = true },
    { "<leader>`", hidden = true },
  })
end
