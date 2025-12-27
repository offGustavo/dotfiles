-- vim: foldmethod=marker foldlevel=0

--{{{ -- Options
vim.g.mapleader = ' '
vim.cmd([[
let g:maplocalleader = "\<BS>"
]])
-- vim.g.netrw_banner = 0

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
vim.o.tabstop = 2      -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 2  -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 2   -- Number of spaces inserted when indenting
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmode = true
vim.o.showcmd = true
vim.o.showcmdloc = 'statusline'
vim.o.foldmethod = 'indent'
vim.o.foldlevel = 99
vim.o.swapfile = false
vim.o.path = vim.o.path .. '**'
vim.cmd([[
		set wildignore=*.o,*.obj,**/node_modules/**,/
    ]])
vim.o.termguicolors = true
vim.o.autocomplete = true
--[Neovim native, built-in, LSP autocomplete · Tomas Vik](https://blog.viktomas.com/graph/neovim-native-built-in-lsp-autocomplete/)
-- prevent the built-in vim.lsp.completion autotrigger from selecting the first item
vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }
-- vim.o.acd = true
-- vim.cmd([[
-- autocmd BufEnter * lcd %:p:h
-- ]])

require('vim._extui').enable({
  enable = true, -- Whether to enable or disable the UI.
  msg = {        -- Options related to the message module.
    ---@type 'cmd'|'msg' Where to place regular messages, either in the
    ---cmdline or in a separate ephemeral message window.
    target = 'cmd',
    timeout = 2000, -- Time a message is visible in the message window.
  },
})

-- Better Grep and Find with ripgrep
if vim.fn.executable 'rg' then
  local glob = "--glob='!.git' --glob='!node_modules/' --glob='!target/'"
  vim.o.grepprg = "rg --vimgrep --hidden " .. glob

  -- [Native Fuzzy Finder in Neovim With Lua and Cool Bindings :: Cherry's Blog](https://cherryramatis.xyz/posts/native-fuzzy-finder-in-neovim-with-lua-and-cool-bindings/)
  function _G.RgFindFiles(cmdarg, _cmdcomplete)
    local fnames = vim.fn.systemlist 'rg --files --hidden --color=never '
    if #cmdarg == 0 then
      return fnames
    else
      return vim.fn.matchfuzzy(fnames, cmdarg)
    end
  end

  vim.o.findfunc = 'v:lua.RgFindFiles'
end
--}}}

--{{{ -- Keymaps
vim.keymap.set({ 'n', 'v', 'i' }, '<C-s>', vim.cmd.update)

vim.keymap.set('n', '<leader>w', '<C-w>')

vim.keymap.set('v', '<C-k>', ":m '<-2<CR>gv=gv", { silent = true, desc = 'Move Line Up' })
vim.keymap.set('v', '<C-j>', ":m '>+1<CR>gv=gv", { silent = true, desc = 'Move Line Down' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { silent = true, desc = 'Go To Normal Mode in Terminal' })

vim.keymap.set('n', '<leader>qo', vim.cmd.copen, { desc = 'QuickFix Open', silent = true })
vim.keymap.set('n', '<leader>qc', vim.cmd.cclose, { desc = 'QuickFix Close', silent = true })

vim.keymap.set('n', '<leader>qq', vim.cmd.quit, { desc = 'Quit', silent = true })
vim.keymap.set('n', '<leader>qQ', ':qa!<Cr>', { desc = 'Force Quit All', silent = true })
vim.keymap.set('n', '<leader>qr', vim.cmd.restart, { desc = 'Restart', silent = true })

vim.keymap.set('n', '<leader>fc', ':e $MYVIMRC<Cr>', { silent = true })

vim.keymap.set('n', '<leader>bb', ':b #<Cr>')
vim.keymap.set('n', '<leader>bd', ':bd<Cr>')
vim.keymap.set('n', '<leader>bD', ':bufdo bd<Cr>')
vim.keymap.set('n', '<leader>,', ':b! ')

vim.keymap.set('n', '<leader>.', ':Ex<Cr>', { desc = "File Explorer" })
vim.keymap.set('n', '<leader><space>', ':find ', { desc = "Finder" })
vim.keymap.set('n', '<leader>/', ':LiveGrep ', { desc = "Live Grep" }) -- Custom Autocmd
vim.keymap.set('n', '<leader>?', ':hor term rg --vimgrep ', { desc = "RipGrep" })

vim.keymap.set('n', '<leader>sw', ':grep <cword><Cr>')
vim.keymap.set('n', '<leader>sW', ':grep <cword> %:h<Cr>')
vim.keymap.set('n', '<leader>ow', ':grep <cWORD><Cr>')
vim.keymap.set('n', '<leader>oW', ':grep <cWORD> %:h<Cr>')

vim.keymap.set(
  "n",
  "<leader>s/",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Substitute Current Word Globally" }
)
vim.keymap.set(
  "n",
  "<leader>s.",
  [[:s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Substitute Current Word" }
)
vim.keymap.set("x", "S", ":s/", { desc = "Substitute in line" })

vim.keymap.set('n', '<leader>z', ':cd ')

vim.keymap.set('n', '<leader>tn', ':term ')
vim.keymap.set('n', '<leader>cc', ':hor term ')

vim.keymap.set('n', '<leader>lg', ':term lazygit<Cr>:start<Cr>')
vim.keymap.set('n', '<leader>lu', function()
  vim.pack.update {}
end)
vim.keymap.set('n', '<leader>lx', function()
  vim.pack.del {}
end)
vim.keymap.set('n', '<leader>le', function()
  vim.cmd("e ~/.local/share/lvim/site/pack/core/opt/")
end)

-- [How to Use vim.pack - NeoVim's built-in Plugin Manager in Neovim 0.12+ - YouTube](https://www.youtube.com/watch?v=UE6XQTAxwE0)
vim.keymap.set('n', '<localleader>l', ':.lua<Cr>', { silent = true, desc = 'Execute Line in Lua' })
vim.keymap.set('v', '<localleader>l', ":'<,'>lua<Cr>", { silent = true, desc = 'Execute Selection in Lua' })

-- Poor man harpoon
vim.keymap.set('n', '<leader>ha', function()
  vim.cmd 'argadd %'
  vim.cmd 'argdedup'
end)

vim.keymap.set('n', '<leader>hd', function()
  vim.cmd 'argd %'
end)

-- assign arg to each number
for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, '<CMD>argu ' .. i .. '<CR>', { silent = true, desc = 'Go to arg ' .. i })
  vim.keymap.set('n', '<leader>h' .. i, '<CMD>' .. i - 1 .. 'arga<CR>',
    { silent = true, desc = 'Add current to arg ' .. i })
  vim.keymap.set('n', '<leader>d' .. i, '<CMD>' .. i .. 'argd<CR>', { silent = true, desc = 'Delete current arg' })
end

-- to qf
vim.keymap.set('n', '<leader>he', function()
  local list = vim.fn.argv()
  if #list > 0 then
    local qf_items = {}
    for _, filename in ipairs(list) do
      table.insert(qf_items, {
        filename = filename,
        lnum = 1,
        text = filename,
      })
    end
    vim.fn.setqflist(qf_items, 'r')
    vim.cmd.copen()
  end
end, { silent = true, desc = 'Show args in qf' })

-- Convert quickfix list to argument list
vim.keymap.set('n', '<leader>hq', function()
  local qf_list = vim.fn.getqflist()
  if #qf_list == 0 then
    vim.notify("Quickfix list is empty", vim.log.levels.WARN)
    return
  end
  -- Clear current argument list
  vim.cmd '%argdelete'
  -- Add each quickfix item to argument list
  for _, item in ipairs(qf_list) do
    if item.filename and item.filename ~= '' then
      -- Use absolute path to avoid issues
      local filename = vim.fn.fnamemodify(item.filename, ':p')
      vim.cmd('argadd ' .. vim.fn.fnameescape(filename))
    elseif item.bufnr and vim.fn.bufexists(item.bufnr) > 0 then
      -- If we have a buffer number but no filename, use buffer name
      local bufname = vim.fn.bufname(item.bufnr)
      if bufname and bufname ~= '' then
        local filename = vim.fn.fnamemodify(bufname, ':p')
        vim.cmd('argadd ' .. vim.fn.fnameescape(filename))
      end
    end
  end
  -- Remove duplicates
  vim.cmd 'argdedup'
  vim.notify(string.format("Added %d files from quickfix to argument list", #qf_list))
end, { silent = true, desc = 'Quickfix to args' })

--}}}

--{{{ -- Autocmds
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [Native Fuzzy Finder in Neovim With Lua and Cool Bindings :: Cherry's Blog](https://cherryramatis.xyz/posts/native-fuzzy-finder-in-neovim-with-lua-and-cool-bindings/)
vim.api.nvim_create_autocmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
  pattern = { '*' },
  group = vim.api.nvim_create_augroup('CmdlineAutocompletion', { clear = true }),
  callback = function(ev)
    vim.opt.wildmenu = true
    vim.opt.wildmode = 'noselect:lastused,full'
    if ev.event == 'CmdlineChanged' then
      vim.opt.wildmode = 'noselect:lastused,full'
      vim.schedule(function()
        vim.fn.wildtrigger()
      end)
    end
    if ev.event == 'CmdlineLeave' then
      vim.opt.wildmode = 'full'
    end
  end,
})

-- [:grep with live updating quickfix list : r/neovim](https://www.reddit.com/r/neovim/comments/1n2ln9w/grep_with_live_updating_quickfix_list/)
vim.api.nvim_create_autocmd('CmdlineChanged', {
  callback = function()
    local cmdline = vim.fn.getcmdline()
    local words = vim.split(cmdline, ' ', { trimempty = true })

    if words[1] == 'LiveGrep' or words[1] == 'live' and #words > 1 then
      vim.cmd('silent grep! ' .. vim.fn.escape(words[2], ' '))
      vim.cmd 'cwindow'
      vim.cmd.redraw()
    end
  end,
  pattern = ':',
})

-- https://stackoverflow.com/questions/42905008/quickfix-list-how-to-add-and-remove-entries
vim.cmd [[
" When using `dd` in the quickfix list, remove the item from the quickfix list.
function! RemoveQFItem()
let curqfidx = line('.') - 1
let qfall = getqflist()
call remove(qfall, curqfidx)
call setqflist(qfall, 'r')
execute curqfidx + 1 . "cfirst"
:copen
endfunction
:command! RemoveQFItem :call RemoveQFItem()
" Use map <buffer> to only map dd in the quickfix window. Requires +localmap
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>
]]

-- Função para remover item atual da Location List
local function remove_loc_item()
  local curidx = vim.fn.line(".") - 1
  local winid = vim.fn.win_getid()

  -- Pega a lista local da janela
  local loclist = vim.fn.getloclist(winid)

  if #loclist == 0 then
    vim.notify("Location List vazia", vim.log.levels.WARN)
    return
  end

  -- Remove o item atual
  table.remove(loclist, curidx + 1)

  -- Atualiza a loclist com a nova lista
  vim.fn.setloclist(winid, loclist, "r")

  -- Reabre para atualizar a janela
  vim.cmd.lwindow()
end

-- Cria comando para remover
vim.api.nvim_create_user_command("RemoveLocItem", remove_loc_item, {})

-- Autocmd: quando abrir uma janela de loclist, mapear `dd`
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(args)
    local wininfo = vim.fn.getwininfo(vim.fn.win_getid())[1]
    if wininfo and wininfo.loclist == 1 then
      vim.api.nvim_buf_set_keymap(
        args.buf,
        "n",
        "dd",
        ":RemoveLocItem<CR>",
        { noremap = true, silent = true }
      )
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', "TermOpen" }, {
  pattern = '*',
  callback = function(args)
    local buf = args.buf
    local buf_options = vim.api.nvim_buf_get_option

    -- Check if this is a terminal buffer
    if buf_options(buf, 'buftype') == 'terminal' then
      -- Check if buffer name contains --vimgrep
      local buf_name = vim.api.nvim_buf_get_name(buf)
      if buf_name:find('--vimgrep') then
        -- Set the mapping again (in case it was lost)
        vim.keymap.set('n', '<Cr>', 'gF', {
          buffer = buf,
          noremap = true,
          silent = true,
          desc = 'Jump to file:line from grep results'
        })
      end
    end
  end
})

--}}}

---{{{ Theme
local M = {}

-- Color palette
M.colors = {
  -- Base colors
  bg = '#1a1d21',
  fg = '#e0dcd4',
  cursor = '#DBCDB3',
  cursor_text_color = '#1a1d21',
  selection_fg = '#e0dcd4',
  selection_bg = '#3d424a',

  -- ANSI colors (0-15)
  color0 = '#1a1d21',
  color1 = '#CDACAC',
  color2 = '#b8c4b8',
  color3 = '#DBCDB3',
  color4 = '#b4bcc4',
  color5 = '#c0b8bc',
  color6 = '#b0bcc8',
  color7 = '#c0bdb8',
  color8 = '#515761',
  color9 = '#c8beb8',
  color10 = '#b4beb4',
  color11 = '#ccc4b0',
  color12 = '#b4bcc4',
  color13 = '#c4beb8',
  color14 = '#b0c0b8',
  color15 = '#e0dcd4',

  -- Semantic names for better readability
  red = '#CDACAC',
  green = '#b8c4b8',
  yellow = '#DBCDB3',
  blue = '#b4bcc4',
  magenta = '#c0b8bc',
  cyan = '#b0bcc8',
  white = '#c0bdb8',
  gray = '#515761',
  bright_red = '#c8beb8',
  bright_green = '#b4beb4',
  bright_yellow = '#ccc4b0',
  bright_blue = '#b4bcc4',
  bright_magenta = '#c4beb8',
  bright_cyan = '#b0c0b8',
  bright_white = '#e0dcd4',
}

local p = M.colors
local set = vim.api.nvim_set_hl

M.setup = function()
  -- Clear existing highlights to prevent conflicts
  vim.cmd('highlight clear')
  if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
  end

  vim.g.colors_name = 'custom_theme'
  vim.o.termguicolors = true

  -- Basic UI
  set(0, 'Normal', { fg = p.fg, bg = p.bg })
  set(0, 'NormalNC', { fg = p.fg, bg = p.bg })
  set(0, 'NormalFloat', { fg = p.fg, bg = p.color0 })
  set(0, 'FloatBorder', { fg = p.color8, bg = p.color0 })

  -- Cursor and selection
  set(0, 'Cursor', { fg = p.cursor_text_color, bg = p.cursor })
  set(0, 'CursorLine', { bg = '#25292e' }) -- Slightly lighter than bg
  set(0, 'CursorLineNr', { fg = p.yellow, bold = true })
  set(0, 'CursorColumn', { bg = '#25292e' })

  -- Visual mode
  set(0, 'Visual', { fg = p.selection_fg, bg = p.selection_bg })
  set(0, 'VisualNOS', { fg = p.selection_fg, bg = p.selection_bg, underline = true })

  -- Line numbers
  set(0, 'LineNr', { fg = p.gray })
  set(0, 'LineNrAbove', { fg = p.gray })
  set(0, 'LineNrBelow', { fg = p.gray })

  -- Status line
  set(0, 'StatusLine', { fg = p.fg, bg = p.color0 })
  set(0, 'StatusLineNC', { fg = p.gray, bg = p.color0 })
  set(0, 'StatusLineTerm', { fg = p.fg, bg = p.color0 })
  set(0, 'StatusLineTermNC', { fg = p.gray, bg = p.color0 })

  -- Tab line
  set(0, 'TabLine', { fg = p.gray, bg = p.color0 })
  set(0, 'TabLineSel', { fg = p.fg, bg = p.selection_bg })
  set(0, 'TabLineFill', { bg = p.color0 })

  -- Search
  set(0, 'Search', { fg = p.bg, bg = p.yellow })
  set(0, 'IncSearch', { fg = p.bg, bg = p.bright_yellow })
  set(0, 'CurSearch', { fg = p.bg, bg = p.bright_yellow })

  -- Messages and prompts
  set(0, 'ErrorMsg', { fg = p.red, bold = true })
  set(0, 'WarningMsg', { fg = p.yellow, bold = true })
  set(0, 'MoreMsg', { fg = p.green, bold = true })
  set(0, 'ModeMsg', { fg = p.blue })
  set(0, 'Question', { fg = p.cyan })

  -- Pmenu (completion menu)
  set(0, 'Pmenu', { fg = p.fg, bg = p.color0 })
  set(0, 'PmenuSel', { fg = p.bg, bg = p.blue })
  set(0, 'PmenuSbar', { bg = p.color8 })
  set(0, 'PmenuThumb', { bg = p.gray })

  -- Fold
  set(0, 'Folded', { fg = p.gray, bg = '#25292e', italic = true })
  set(0, 'FoldColumn', { fg = p.gray, bg = p.bg })

  -- Sign column
  set(0, 'SignColumn', { fg = p.gray, bg = p.bg })

  -- Color column
  set(0, 'ColorColumn', { bg = '#25292e' })

  -- VertSplit
  set(0, 'VertSplit', { fg = p.color8, bg = p.bg })

  -- Syntax highlighting
  set(0, 'Comment', { fg = p.gray, italic = true })
  set(0, 'String', { fg = p.green })
  set(0, 'Character', { fg = p.bright_green })
  set(0, 'Number', { fg = p.cyan })
  set(0, 'Boolean', { fg = p.cyan })
  set(0, 'Float', { fg = p.cyan })
  set(0, 'Function', { fg = p.blue })
  set(0, 'Identifier', { fg = p.magenta })
  set(0, 'Keyword', { fg = p.red })
  set(0, 'Statement', { fg = p.red })
  set(0, 'Conditional', { fg = p.red })
  set(0, 'Repeat', { fg = p.red })
  set(0, 'Label', { fg = p.blue })
  set(0, 'Operator', { fg = p.fg })
  set(0, 'Exception', { fg = p.red })
  set(0, 'PreProc', { fg = p.yellow })
  set(0, 'Include', { fg = p.red })
  set(0, 'Define', { fg = p.red })
  set(0, 'Macro', { fg = p.yellow })
  set(0, 'PreCondit', { fg = p.yellow })
  set(0, 'Type', { fg = p.yellow })
  set(0, 'StorageClass', { fg = p.yellow })
  set(0, 'Structure', { fg = p.yellow })
  set(0, 'Typedef', { fg = p.yellow })
  set(0, 'Special', { fg = p.cyan })
  set(0, 'SpecialChar', { fg = p.cyan })
  set(0, 'Tag', { fg = p.blue })
  set(0, 'Delimiter', { fg = p.fg })
  set(0, 'SpecialComment', { fg = p.gray, bold = true })
  set(0, 'Debug', { fg = p.red })
  set(0, 'Underlined', { underline = true })
  set(0, 'Ignore', { fg = p.gray })
  set(0, 'Error', { fg = p.red, bold = true })
  set(0, 'Todo', { fg = p.yellow, bold = true, italic = true })

  -- Diagnostics (LSP)
  set(0, 'DiagnosticError', { fg = p.red })
  set(0, 'DiagnosticWarn', { fg = p.yellow })
  set(0, 'DiagnosticInfo', { fg = p.blue })
  set(0, 'DiagnosticHint', { fg = p.gray })
  set(0, 'DiagnosticUnderlineError', { undercurl = true, sp = p.red })
  set(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = p.yellow })
  set(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = p.blue })
  set(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = p.gray })

  -- Diff
  set(0, 'DiffAdd', { fg = p.green, bg = '#1e2a1e' })
  set(0, 'DiffChange', { fg = p.yellow, bg = '#2a2a1e' })
  set(0, 'DiffDelete', { fg = p.red, bg = '#2a1e1e' })
  set(0, 'DiffText', { fg = p.bg, bg = p.yellow })

  -- Spell
  set(0, 'SpellBad', { undercurl = true, sp = p.red })
  set(0, 'SpellCap', { undercurl = true, sp = p.yellow })
  set(0, 'SpellRare', { undercurl = true, sp = p.cyan })
  set(0, 'SpellLocal', { undercurl = true, sp = p.blue })

  -- Non-text
  set(0, 'NonText', { fg = p.color8 })
  set(0, 'Whitespace', { fg = p.color8 })
  set(0, 'EndOfBuffer', { fg = p.color0 })

  -- Match pairs
  set(0, 'MatchParen', { fg = p.yellow, bold = true, underline = true })

  -- Conceal
  set(0, 'Conceal', { fg = p.gray, bg = p.bg })

  -- Special windows
  set(0, 'WinSeparator', { fg = p.color8 })
  set(0, 'WildMenu', { fg = p.bg, bg = p.blue })
end

M.setup()

---}}}

--{{{ -- LSP Config
-- lsp
--------------------------------------------------------------------------------
-- See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
-- of how the lsp setup works in neovim 0.11+.
-- This actually just enables the lsp servers.
-- The configuration is found in the lsp folder inside the nvim config folder,
-- so in ~.config/lsp/lua_ls.lua for lua_ls, for example.
vim.lsp.enable 'lua_ls'
vim.lsp.enable 'marksman'
vim.lsp.enable 'rust_analyzer'
vim.lsp.enable 'ts_ls'
vim.lsp.enable 'bash_ls'
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end)
      vim.keymap.set('n', '<leader>ca', function()
        vim.lsp.buf.code_action()
      end, { desc = 'Code Action' })
      vim.keymap.set('n', '<leader>cr', function()
        vim.lsp.buf.rename()
      end, { desc = 'Code Action' })
      vim.keymap.set('n', '<leader>cf', function()
        vim.lsp.buf.format()
      end, { desc = 'Code Format' })
      vim.keymap.set('n', '<leader>qd', function()
        vim.diagnostic.setqflist()
      end, { desc = 'Open Diagnostics Quickfix list' })
    end
  end,
})
-- Diagnostics
vim.diagnostic.config {
  -- Use the default configuration
  virtual_lines = false,
  virtual_text = true,
  -- signs = {
  --   text = {
  --     [vim.diagnostic.severity.ERROR] = "󰐼",
  --     [vim.diagnostic.severity.WARN] = "",
  --     [vim.diagnostic.severity.INFO] = "",
  --     [vim.diagnostic.severity.HINT] = "",
  --   }
  -- }
}
--}}}

--{{{ -- Plugins
local plugins = {
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason-lspconfig.nvim',
}

vim.pack.add(plugins)

---}}}

--{{{ -- Mason LSP
require('mason').setup()

require('mason-lspconfig').setup {
  ensure_installed = { 'lua_ls', 'rust_analyzer', 'marksman' },
}
--}}}
