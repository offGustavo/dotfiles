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

vim.api.nvim_create_user_command("LazyGit", function(o)
  require("Fish.lazygit").open({ subcmd = o.fargs[1] })
end, {
  nargs = "*",
  complete = function()
    return {
      "log",
      "stash",
      "branch",
      "status",
    }
  end,
})

vim.api.nvim_create_user_command("LazyGitDir", function(o)
  require("Fish.lazygit").open({ path = o.fargs[1] })
end, {
  nargs = "*",
  complete = "dir",
})

vim.api.nvim_create_user_command("LazyGitCwd", function()
  require("Fish.lazygit").open({ path = vim.loop.cwd() })
end, {
  nargs = 0,
})

vim.api.nvim_create_user_command("LazyGitFileDir", function()
  require("Fish.lazygit").open({ path = vim.fn.expand("%:p:h") })
end, {
  nargs = 0,
})

vim.keymap.set("n", "<leader>gg", function()
  require("Fish.lazygit").open()
end, { desc = "Open lazygit" })
