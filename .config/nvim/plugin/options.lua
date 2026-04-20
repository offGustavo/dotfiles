vim.o.modeline = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.breakindent = true
vim.o.linebreak = true
vim.o.undofile = true
-- vim.o.ignorecase = true
-- vim.o.smartcase = true
vim.o.updatetime = 100
vim.o.timeoutlen = 400
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = false
vim.o.inccommand = "split"
vim.o.cursorline = false
vim.o.confirm = true
vim.o.wrap = false
vim.o.tabstop = 2      -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 2  -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 2   -- Number of spaces inserted when indenting
vim.o.swapfile = false
-- vim.o.path = vim.o.path .. "**"
-- vim.cmd([[
--   set wildignore=*.o,*.obj,**/node_modules/**,/
-- ]])
vim.o.termguicolors = true
if vim.uv.os_uname().sysname == "Windows_NT" then
  vim.o.shell = "pwsh.exe"
  vim.o.shellcmdflag =
  "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
end

-- Mini Max
vim.o.iskeyword = "@,48-57,192-255,-" -- _ works like an separate word
vim.o.shortmess = "ICFOSWaco"         -- Disable some built-in completion messages
vim.o.virtualedit = "block"           -- Allow going past end of line in blockwise mode

-- vim.o.cursorlineopt  = 'screenline,number' -- Show cursor line per screen line

-- Special UI symbols. More is set via 'mini.basics' later.
-- vim.o.list = true
-- vim.o.fillchars = "eob:$,fold:-"

vim.api.nvim_create_autocmd({ "VimEnter", "VimResume", "UIEnter" }, {
  group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
  callback = function()
    if vim.api.nvim_ui_send then
      vim.api.nvim_ui_send("\x1b]1337;SetUserVar=in_editor=MQo\007")
    else
      io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\007")
    end
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
  callback = function()
    if vim.api.nvim_ui_send then
      vim.api.nvim_ui_send("\x1b]1337;SetUserVar=in_editor=MQo\007")
    else
      io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
    end
  end,
})

vim.schedule(function()
  -- vim.o.clipboard = "unnamed,unnamedplus"

  -- [Neovim native, built-in, LSP autocomplete · Tomas Vik](https://blog.viktomas.com/graph/neovim-native-built-in-lsp-autocomplete/)
  -- prevent the built-in vim.lsp.completion autotrigger from selecting the first item
  -- vim.o.autocomplete = true
  -- vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }

  -- vim.o.acd = true
  -- vim.g.netrw_keepdir = 0
  -- vim.cmd([[
  -- autocmd BufEnter * lcd %:p:h
  -- ]])

  -- Better Grep and Find with ripgrep
  if vim.fn.executable("rg") then
    vim.o.grepprg = "rg"
    -- [Native Fuzzy Finder in Neovim With Lua and Cool Bindings :: Cherry's Blog](https://cherryramatis.xyz/posts/native-fuzzy-finder-in-neovim-with-lua-and-cool-bindings/)
    function _G.RgFindFiles(cmdarg, _cmdcomplete)
      local fnames = vim.fn.systemlist("rg --files --hidden --color=never ")
      if #cmdarg == 0 then
        return fnames
      else
        return vim.fn.matchfuzzy(fnames, cmdarg)
      end
    end

    vim.o.findfunc = "v:lua.RgFindFiles"
  end
end)

vim.filetype.add({
  extension = {
    kbd = "kbd", -- maps *.kbd → filetype=kbd
  },
})

vim.o.keymodel = "startsel,stopsel"
