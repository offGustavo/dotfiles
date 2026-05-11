-- vim: foldmethod=marker
-- {{{ Security Things
vim.o.modeline       = true
vim.o.exrc           = false
--- }}}

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

-- -- [Neovim native, built-in, LSP autocomplete · Tomas Vik](https://blog.viktomas.com/graph/neovim-native-built-in-lsp-autocomplete/)
-- -- prevent the built-in vim.lsp.completion autotrigger from selecting the first item
-- vim.o.autocomplete = true
-- vim.opt.completeopt = { "menuone", "noinsert", "popup" }
-- vim.o.complete = "o,.,b"

vim.schedule(function()
  -- Better Grep and Find with ripgrep
  if vim.fn.executable("rg") then
    vim.o.grepprg = "rg"
    -- [Native Fuzzy Finder in Neovim With Lua and Cool Bindings :: Cherry's Blog](https://cherryramatis.xyz/posts/native-fuzzy-finder-in-neovim-with-lua-and-cool-bindings/)
    function fish.rg_find_files(cmdarg, _cmdcomplete)
      local fnames = vim.fn.systemlist("rg --files --hidden --color=never ")
      if #cmdarg == 0 then
        return fnames
      else
        return vim.fn.matchfuzzy(fnames, cmdarg)
      end
    end

    vim.o.findfunc = "v:lua.fish.rg_find_files"
  end
end)

vim.filetype.add({
  extension = {
    kbd = "kbd", -- maps *.kbd → filetype=kbd
  },
})

vim.o.keymodel = "startsel,stopsel"

vim.schedule(function()
  vim.o.spelllang = "pt_br,en_us,es"
  vim.o.spell = true
  vim.o.spelloptions = "camel" -- Treat camelCase word parts as separate words

  local spell_on_choice = vim.schedule_wrap(function(_, idx)
    if type(idx) == "number" then
      vim.cmd("normal! " .. idx .. "z=")
    end
  end)
  local spellsuggest_select = function()
    if vim.v.count > 0 then
      spell_on_choice(nil, vim.v.count)
      return
    end
    local cword = vim.fn.expand("<cword>")
    local prompt = "Change " .. vim.inspect(cword) .. " to:"
    vim.ui.select(vim.fn.spellsuggest(cword, vim.o.lines), { prompt = prompt }, spell_on_choice)
  end
  vim.keymap.set("n", "Z=", spellsuggest_select, { desc = "Custom spelling suggestions" })
end)

-- {{{ foldtext
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99

-- vim.o.foldtext = ""
vim.o.foldtext = "v:lua.require('fish.foldtext').build_fold_text()"

function fish.clean_folded_hi()
  vim.api.nvim_set_hl(0, "Folded", { link = "Comment" })
end

vim.api.nvim_create_autocmd({ "UiEnter", "ColorScheme" }, {
  callback = function()
    fish.clean_folded_hi()
  end
})
--- }}}

--- {{{ statuscolumn
vim.o.foldcolumn = "1"
vim.o.signcolumn = "yes:1"

-- Status column settings
vim.opt.fillchars:append({
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  foldinner = " ",
})

-- vim.o.statuscolumn = "%s%l %C "
vim.o.statuscolumn = "%!v:lua.require('fish.statuscolumn').build()"

-- }}}

-- {{{ statusline
-- FIXME: Quero usar o laststatus = 0, mas o nome do arquivo não fica salvo per janela
vim.o.laststatus = 3
vim.o.showmode = false

-- vim.opt.fillchars:append({
--   stl = "-",
--   stlnc = "-"
-- })

-- set statusline=%<%f\ %h%w%m%r\ %{%\ v:lua.require('vim._core.util').term_exitcode()\ %}%=%{%\ luaeval('(package.loaded[''vim.ui'']\ and\ vim.api.nvim_get_current_win()\ ==\ tonumber(vim.g.actual_curwin\ or\ -1)\ and\ vim.ui.progress_status())\ or\ ''''\ ')%}%{%\ &showcmdloc\ ==\ 'statusline'\ ?\ '%-10.S\ '\ :\ ''\ %}%{%\ exists('b:keymap_name')\ ?\ '<'..b:keymap_name..'>\ '\ :\ ''\ %}%{%\ &busy\ >\ 0\ ?\ '◐\ '\ :\ ''\ %}%{%\ luaeval('(package.loaded[''vim.diagnostic'']\ and\ next(vim.diagnostic.count())\ and\ vim.diagnostic.status()\ ..\ ''\ '')\ or\ ''''\ ')\ %}%{%\ &ruler\ ?\ (\ &rulerformat\ ==\ ''\ ?\ '%-14.(%l,%c%V%)\ %P'\ :\ &rulerformat\ )\ :\ ''\ %}

-- vim.o.statusline = "%!v:lua.require('fish.statusline').build_statusline()"

-- From mini.statusline
-- -- Set statusline globally and dynamically decide which content to use
vim.go.statusline =
[[ %{%(nvim_get_current_win()==#g:actual_curwin || &laststatus==3) ? v:lua.require('fish.statusline').build_statusline() : v:lua.require('fish.statusline').build_statusline_inactive()%} ]]

-- }}}

-- {{{ tabline
vim.o.showtabline = 0
vim.o.tabline = "%!v:lua.require('fish.tabline').build_tabline()"
-- Update when windows or tabs change
vim.api.nvim_create_autocmd({ "VimEnter", "UiEnter", "WinNew", "WinClosed", "TabNew", "TabClosed" }, {
  callback = function()
    local ignore_ft = {
      "neo-tree", "NvimTree", "nvimtree",
      "toggleterm", "terminal",
      "lazy", "mason",
      "trouble", "qf",
      "help",
      "nofile",
      "TelescopePrompt", "telescope",
      "notify", "noice",
      "aerial", "outline",
      "dap-repl", "dapui_watches", "dapui_stacks",
      "dapui_breakpoints", "dapui_scopes", "dapui_console",
      "undotree", "diff",
      "packer",
      "lspinfo", "lsp-installer",
      "startify", "alpha", "dashboard",
    }

    local ignore_ft_set = {}
    for _, ft in ipairs(ignore_ft) do
      ignore_ft_set[ft] = true
    end

    -- Defer so WinClosed fires after the window is actually gone
    vim.schedule(function()
      local tabcount = #vim.api.nvim_list_tabpages()
      local windowcount = 0

      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.bo[buf].filetype
        local bt = vim.bo[buf].buftype
        local cfg = vim.api.nvim_win_get_config(win)

        -- Skip floating windows and UI filetypes/buftypes
        if cfg.relative == "" then
          if not ignore_ft_set[ft] and not ignore_ft_set[bt] then
            windowcount = windowcount + 1
          end
        end
      end

      if tabcount > 1 or windowcount > 1 then
        vim.o.showtabline = 2
      else
        vim.o.showtabline = 0
      end
    end)
  end,
})
-- }}}

-- {{{ quickfix
-- TODO: add custom quickfix list
-- vim.o.quickfixtextfunc = "v:lua.require('fish.quickfix').format()"
--- }}}

-- {{{ ui2
if vim.fn.has('nvim-0.12') ~= 1 then
  vim.notify("Use 0.12 to enable ui2", vim.log.levels.WARN)
  return
end

vim.schedule(function()
  vim.o.cmdheight = 1
  require("vim._core.ui2").enable({
    enable = true, -- Whether to enable or disable the UI.
    msg = {      -- Options related to the message module.
      ---@type 'cmd'|'msg' Default message target, either in the
      ---cmdline or in a separate ephemeral message window.
      ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
      ---or table mapping |ui-messages| kinds and triggers to a target.
      targets = "msg",
    },
  })
end)

-- }}}

-- {{{ -- Experimental UI2: floating cmdline and messages
-- require('vim._core.ui2').enable({
--   enable = true,
--   msg = {
--     targets = {
--       [''] = 'msg',
--       empty = 'cmd',
--       bufwrite = 'msg',
--       confirm = 'cmd',
--       emsg = 'pager',
--       echo = 'msg',
--       echomsg = 'msg',
--       echoerr = 'pager',
--       completion = 'cmd',
--       list_cmd = 'pager',
--       lua_error = 'pager',
--       lua_print = 'msg',
--       progress = 'pager',
--       rpc_error = 'pager',
--       quickfix = 'msg',
--       search_cmd = 'cmd',
--       search_count = 'cmd',
--       shell_cmd = 'pager',
--       shell_err = 'pager',
--       shell_out = 'pager',
--       shell_ret = 'msg',
--       undo = 'msg',
--       verbose = 'pager',
--       wildlist = 'cmd',
--       wmsg = 'msg',
--       typed_cmd = 'cmd',
--     },
--     cmd = {
--       height = 0.5,
--     },
--     dialog = {
--       height = 0.5,
--     },
--     msg = {
--       height = 0.3,
--       timeout = 5000,
--     },
--     pager = {
--       height = 0.5,
--     },
--   },
-- })
-- }}}
