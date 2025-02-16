-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.vscode then
  -- VS CODE CONFIGS
else
  vim.cmd("colorscheme tokyonight-night")
end
