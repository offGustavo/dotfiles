-- Security Things
vim.o.modeline       = true
vim.o.exrc           = false

-- vim.opt.mouse = ""
vim.o.number         = true
vim.o.relativenumber = true

vim.o.breakindent    = true
vim.o.linebreak      = true

vim.o.undofile       = true
vim.o.swapfile       = false

vim.o.updatetime     = 100
vim.o.timeoutlen     = 400
vim.o.splitright     = true
vim.o.splitbelow     = true
vim.o.inccommand     = "split"
vim.o.cursorline     = false
vim.o.confirm        = true
vim.o.wrap           = false

vim.o.tabstop        = 2    -- A TAB character looks like 4 spaces
vim.o.expandtab      = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop    = 2    -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth     = 2    -- Number of spaces inserted when indenting

vim.o.list           = false
vim.o.showbreak      = "↪"
vim.opt.listchars    = {
  space = "·",
  -- TODO: change the tab
  tab = "^I"
}

-- vim.cmd[[
--   set showbreak=↪\
--   set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
-- ]]

-- Mini Max
vim.o.iskeyword      = "@,48-57,192-255,-" -- _ works like an separate word
vim.o.shortmess      = "ICFOSWaco"         -- Disable some built-in completion messages
vim.o.virtualedit    = "block"             -- Allow going past end of line in blockwise mode

vim.o.cursorlineopt  = 'screenline,number' -- Show cursor line per screen line

vim.schedule(function()
  -- [Neovim native, built-in, LSP autocomplete · Tomas Vik](https://blog.viktomas.com/graph/neovim-native-built-in-lsp-autocomplete/)
  -- prevent the built-in vim.lsp.completion autotrigger from selecting the first item
  -- vim.o.autocomplete = true
  -- vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }
  -- Better Grep and Find with ripgrep
  if vim.fn.executable("rg") then
    vim.o.grepprg = "rg"
    -- [Native Fuzzy Finder in Neovim With Lua and Cool Bindings :: Cherry's Blog](https://cherryramatis.xyz/posts/native-fuzzy-finder-in-neovim-with-lua-and-cool-bindings/)
    function Fish.rg_find_files(cmdarg, _cmdcomplete)
      local fnames = vim.fn.systemlist("rg --files --hidden --color=never ")
      if #cmdarg == 0 then
        return fnames
      else
        return vim.fn.matchfuzzy(fnames, cmdarg)
      end
    end

    vim.o.findfunc = "v:lua.Fish.rg_find_files"
  end
end)

vim.filetype.add({
  extension = {
    kbd = "kbd", -- maps *.kbd → filetype=kbd
  },
})

vim.o.keymodel = "startsel,stopsel"
