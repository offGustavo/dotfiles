vim.g.lazygit_config = {
  ui = {
    border = "rounded",
    height = 0.9,
    width = 0.9,
  },
  keybindings = {
    -- ["<C-h>"] = "<C-\\><C-n><C-w>h", -- navigate left
    -- ["<C-l>"] = "<C-\\><C-n><C-w>l", -- navigate right
  },
  lazygit = {
    theme = true,
  },
  on_exit = function()
    vim.cmd("checktime") -- refresh buffers if files changed
  end,
  enable_cmds = true,
}

vim.cmd('command! Lazygit lua require("fish.lazygit").open()')
vim.keymap.set("n", "<leader>gg", function()
  require("fish.lazygit").open()
end, { desc = "Open lazygit" })

-- -- Optional: commands that open lazygit in different directories
-- -- e.g., current file's directory, Neovim's cwd, etc.
-- vim.cmd('command! LazygitCwd lua require("fish.lazygit").open(vim.loop.cwd())')
-- vim.cmd('command! LazygitFileDir lua require("fish.lazygit").open(vim.fn.expand("%:p:h"))')
