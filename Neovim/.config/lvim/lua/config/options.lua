vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = true
vim.o.laststatus = 3
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
vim.o.breakindent = true
vim.o.linebreak = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 50
vim.o.timeoutlen = 400
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.spell = false
vim.o.list = false
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.confirm = true
vim.o.wrap = false
vim.o.tabstop = 2 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 2 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 2 -- Number of spaces inserted when indenting
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmode = true
vim.o.showcmd = true
vim.o.showcmdloc = 'statusline'
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99
vim.o.swapfile = false
vim.o.path = vim.o.path .. "**"
vim.o.wildignore =  vim.o.wildignore .. "**/node_modules/**"
-- vim.o.winborder = "rounded"
vim.cmd.colorscheme 'retrobox'

if vim.fn.executable('rg')  then
  vim.o.grepprg = "rg --vimgrep -. --smart-case -g '!.git' -g '!node_modules/'"
  -- else
  --     vim.o.grepprg = "grep -R --exclude-dir=.git --exclude-dir=node_modules"
end

vim.g.netrw_banner = 0
vim.g.snacks_animate = false

-- Experimental
require('vim._extui').enable({
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    ---@type 'cmd'|'msg' Where to place regular messages, either in the
    ---cmdline or in a separate ephemeral message window.
    target = 'msg',
    timeout = 2000, -- Time a message is visible in the message window.
  },
})

if vim.fn.executable("zoxide") == 1 then
  vim.api.nvim_create_user_command("Cd", function(opts)
    local target = opts.args
    if target == "" then
      vim.cmd("cd ~")
      return
    end
    local handle = io.popen("zoxide query " .. vim.fn.shellescape(target))
    if handle then
      local result = handle:read("*l")
      handle:close()
      if result and #result > 0 then
        vim.cmd("cd " .. vim.fn.fnameescape(result))
        print("Changed directory to: " .. result)
      else
        print("zoxide: no match for '" .. target .. "'")
      end
    else
      print("Failed to run zoxide")
    end
  end, { nargs = "?" })
  vim.keymap.set("n", "<leader>z", ":Cd ")
end
