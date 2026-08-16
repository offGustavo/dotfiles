-- vim: foldmethod=marker

-- {{{ Map Leader and Local Leader
vim.cmd([[
" <space> as leader
let g:mapleader = " "
" <space><space> as local leader
let g:maplocalleader = "  "
]])
-- }}}

-- {{{ Set a temp theme here to prevent light/dark flicker
if vim.o.background == "dark" then
  vim.cmd.colorscheme("tokyo")
else
  vim.cmd.colorscheme("tokyo-day")
end
-- }}}

-- {{{ Security Things
set {
  modeline = true,
  exrc = false,
}
--- }}}

-- {{{ Disable Plugins
-- disable custom nix/arch fzf.vim
vim.cmd("let g:loaded_fzf = 1")
-- }}}

-- {{{ Kitty scroll mode
if os.getenv("SCROLL_MODE") then
  vim.cmd([[
	nmap q <Cmd>qa!<CR>
	xmap q <Cmd>qa!<CR> 
	nnoremap yy "+yy<Cmd>qa!<Cr>
	xmap y "+y<Cmd>qa!<Cr>
	set laststatus=0 nonu nornu signcolumn=no cursorline cmdheight=0
	$ 
	]])
  -- NOTE: Stop config here
  return
end
-- }}}

-- {{{ Netrw
vim.cmd [[
" let g:netrw_banner = 0

" -- vim.o.acd = true
" -- vim.g.netrw_keepdir = 0
" -- vim.cmd([[
" -- autocmd BufEnter * lcd %:p:h
]]
-- }}}

-- {{{ Options
-- vim.opt.mouse = ""
set {
  number = true,
  relativenumber = true,
  breakindent = true,
  linebreak = true,
  undofile = true,
  swapfile = false,
  updatetime = 100,
  timeoutlen = 400,
  splitright = true,
  splitbelow = true,
  inccommand = "split",
  cursorline = false,
  confirm = true,
  wrap = false,
  tabstop = 2, -- A TAB character looks like 4 spaces
  expandtab = true, -- Pressing the TAB key will insert spaces instead of a TAB character
  softtabstop = 2, -- Number of spaces inserted instead of a TAB character
  shiftwidth = 2, -- Number of spaces inserted when indenting
  list = false,
  showbreak = "↪",
  listchars = {
    space = "·",
    -- TODO: change the tab
    tab = "^I",
  },
  -- Mini Max
  iskeyword = "@,48-57,192-255,-", -- _ works like an separate word
  shortmess = "ICFOSWaco", -- Disable some built-in completion messages
  virtualedit = "block", -- Allow going past end of line in blockwise mode
  cursorlineopt = "screenline,number", -- Show cursor line per screen line
  keymodel = "startsel,stopsel",
}

vim.cmd([[
aunmenu PopUp.How-to\ disable\ mouse
" aunmenu PopUp.-2-
amenu PopUp.Exit <Cmd>qa!<CR>
]])

-- vim.cmd[[
--   set showbreak=↪\
--   set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
-- ]]

--- }}}

-- {{{ Windows
if Fish.is_windows() then
  vim.cmd([[
	set noshelltemp
	let &shell = 'powershell'
	let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
	let &shellcmdflag .= '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();'
	let &shellcmdflag .= '$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';'
	let &shellpipe  = '> %s 2>&1'
	set shellquote= shellxquote=
	]])
end
-- }}}

-- {{{ Tittle
vim.o.title = true
function Fish.cwd_title()
  -- vim.fs.normalize() converts the path, then ~ contract for readability
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
  if vim.g.neovide then
    return "neovide <" .. cwd .. ">"
  end
  return "nvim <" .. cwd .. ">"
end
vim.o.titlestring = "%{v:lua.Fish.cwd_title()}"
-- }}}

-- {{{ Autocomplete
-- [neovim native, built-in, lsp autocomplete · tomas vik](https://blog.viktomas.com/graph/neovim-native-built-in-lsp-autocomplete/)
-- prevent the built-in vim.lsp.completion autotrigger from selecting the first item
-- vim.o.autocomplete = true
-- vim.opt.completeopt = { "menuone", "noinsert", "popup" }
-- vim.o.complete = "o,.,b"
-- }}}

-- {{{ grepprg and findfunc
vim.schedule(function()
  -- better grep and find with ripgrep
  if vim.fn.executable("rg") == 1 then
    if Fish.is_windows() then
      vim.o.grepprg = "rg --vimgrep --color=never"
    else
      vim.o.grepprg = "rg"
    end

    vim.api.nvim_create_user_command("Rg", function(args)
      local result = vim.fn.systemlist("rg --vimgrep " .. args.args)
      vim.fn.setqflist({}, "r", {
        title = "Results",
        lines = result,
      })
      vim.cmd("copen")
    end, { nargs = 1 })

    -- [native fuzzy finder in neovim with lua and cool bindings :: cherry's blog](https://cherryramatis.xyz/posts/native-fuzzy-finder-in-neovim-with-lua-and-cool-bindings/)
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

  if vim.fn.executable("fd") == 1 then
    function Fish.fd_find_files(cmdarg, _cmdcomplete)
      local fnames = vim.fn.systemlist("fd --hidden -t f --color=never")

      if #cmdarg == 0 then
        return fnames
      end

      -- build {path=..., filename=...} entries so matchfuzzy can key on filename only
      local items = {}
      for _, f in ipairs(fnames) do
        table.insert(items, { path = f, filename = vim.fn.fnamemodify(f, ":t") })
      end

      local matched = vim.fn.matchfuzzy(items, cmdarg, { key = "filename" })

      local results = {}
      for _, m in ipairs(matched) do
        table.insert(results, m.path)
      end
      print(results)
      return results
    end
    vim.o.findfunc = "v:lua.Fish.fd_find_files"
  end
end)
-- }}}

-- {{{ New Filetypes
vim.filetype.add {
  extension = {
    kbd = "kbd", -- maps *.kbd → filetype=kbd
  },
}
-- }}}

-- {{{ Spell
vim.schedule(function()
  set {
    spelllang = "pt_br,en_us,es",
    spell = true,
    spelloptions = "camel", -- Treat camelCase word parts as separate words
  }

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
-- }}}

-- {{{ foldtext
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99

-- vim.o.foldtext = ""
vim.o.foldtext = "v:lua.require('fish.foldtext').build_fold_text()"

function Fish.clean_folded_hi()
  vim.api.nvim_set_hl(0, "Folded", { link = "Comment" })
end

vim.api.nvim_create_autocmd({ "UiEnter", "ColorScheme" }, {
  callback = function()
    Fish.clean_folded_hi()
  end,
})
--- }}}

-- {{{ statuscolumn
set {
  foldcolumn = "1",
  signcolumn = "yes:1",
  -- Status column settings
  fillchars = {
    fold = " ",
    foldopen = "",
    foldclose = "",
    foldsep = " ",
    foldinner = " ",
  },
}

-- vim.o.statuscolumn = "%s%l %C "
vim.o.statuscolumn = "%!v:lua.require('fish.statuscolumn').build()"

-- }}}

-- {{{ statusline
set {
  laststatus = 3,
  showmode = false,
}

-- vim.opt.fillchars:append({
--   stl = "-",
--   stlnc = "-"
-- })

-- vim.opt.fillchars:append({
--   vert = '┃',
--   horiz = '━',
--   horizup = '┻',
--   horizdown = '┳'
-- })

-- vim.opt.fillchars:append({
-- vert = ' ',
-- horiz = ' ',
-- horizup = ' ',
-- horizdown = ' '
-- })

-- set statusline=%<%f\ %h%w%m%r\ %{%\ v:lua.require('vim._core.util').term_exitcode()\ %}%=%{%\ luaeval('(package.loaded[''vim.ui'']\ and\ vim.api.nvim_get_current_win()\ ==\ tonumber(vim.g.actual_curwin\ or\ -1)\ and\ vim.ui.progress_status())\ or\ ''''\ ')%}%{%\ &showcmdloc\ ==\ 'statusline'\ ?\ '%-10.S\ '\ :\ ''\ %}%{%\ exists('b:keymap_name')\ ?\ '<'..b:keymap_name..'>\ '\ :\ ''\ %}%{%\ &busy\ >\ 0\ ?\ '◐\ '\ :\ ''\ %}%{%\ luaeval('(package.loaded[''vim.diagnostic'']\ and\ next(vim.diagnostic.count())\ and\ vim.diagnostic.status()\ ..\ ''\ '')\ or\ ''''\ ')\ %}%{%\ &ruler\ ?\ (\ &rulerformat\ ==\ ''\ ?\ '%-14.(%l,%c%V%)\ %P'\ :\ &rulerformat\ )\ :\ ''\ %}

vim.o.statusline = "%!v:lua.require('fish.statusline').build_statusline()"

-- From mini.statusline
-- -- Set statusline globally and dynamically decide which content to use
-- vim.go.statusline = [[ %{%(nvim_get_current_win()==#g:actual_curwin || &laststatus==3) ? v:lua.require('fish.statusline').build_statusline() : v:lua.require('fish.statusline').build_statusline_inactive()%} ]]

-- }}}

-- {{{ tabline
vim.o.showtabline = 0
vim.o.tabline = "%!v:lua.require('fish.tabline').build_tabline()"
-- Update when windows or tabs change
vim.api.nvim_create_autocmd({ "VimEnter", "UiEnter", "WinNew", "WinClosed", "TabNew", "TabClosed" }, {
  callback = function()
    local ignore_ft = {
      "neo-tree",
      "NvimTree",
      "nvimtree",
      "toggleterm",
      "terminal",
      "lazy",
      "mason",
      "trouble",
      "qf",
      "help",
      "nofile",
      "TelescopePrompt",
      "telescope",
      "notify",
      "noice",
      "aerial",
      "outline",
      "dap-repl",
      "dapui_watches",
      "dapui_stacks",
      "dapui_breakpoints",
      "dapui_scopes",
      "dapui_console",
      "undotree",
      "diff",
      "packer",
      "lspinfo",
      "lsp-installer",
      "startify",
      "alpha",
      "dashboard",
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
if vim.fn.has("nvim-0.12") ~= 1 then
  vim.notify("Use 0.12 to enable ui2", vim.log.levels.WARN)
  return
end

vim.schedule(function()
  vim.o.cmdheight = 0
  require("vim._core.ui2").enable {
    enable = true, -- Whether to enable or disable the UI.
    msg = { -- Options related to the message module.
      ---@type 'cmd'|'msg' Default message target, either in the
      ---cmdline or in a separate ephemeral message window.
      ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
      ---or table mapping |ui-messages| kinds and triggers to a target.
      targets = "msg",
    },
  }
end)

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

-- }}}
