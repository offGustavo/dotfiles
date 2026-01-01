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
vim.o.autocomplete = false
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

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

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

vim.keymap.set("n", "<leader><tab>o", "<Cmd>tabo<CR>")
vim.keymap.set("n", "<leader><tab>n", "<Cmd>tabnew<CR>")
vim.keymap.set("n", "<leader><tab>[", "<Cmd>tabprev<CR>")
vim.keymap.set("n", "<leader><tab>]", "<Cmd>tabnext<CR>")
vim.keymap.set("n", "<leader><tab>c", "<Cmd>tabclose<CR>")
vim.keymap.set("n", "<leader><tab>z", ":tcd ")

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

---{{{ -- Theme
local Shibuya = {}

-- Dark mode (Shibuya) colors
Shibuya.colors = {
  -- Base colors (reduced palette)
  bg = "#1a1b26",
  bg_alt = "#24283b",
  bg_float = "#24283b",
  bg_highlight = "#292e42",
  bg_visual = "#364a82",

  fg = "#c0caf5",
  fg_dark = "#565f89",

  -- Primary colors only
  blue = "#7aa2f7",
  cyan = "#7dcfff",
  green = "#9ece6a",
  yellow = "#e0af68",
  yellow_bg = "#f5eedb", -- Soft yellow background
  red = "#f7768e",
  magenta = "#bb9af7",

  -- UI specific
  cursor = "#c0caf5",
  selection_bg = "#364a82",
}

-- Light mode (Shibuya Day) colors with background highlights
Shibuya.colors_day = {
  -- Core
  fg = "#3760bf",
  fg_bg = "#c3cfeb",
  fg_dark = "#6172b0",

  -- Soft backgrounds (derived / desaturated)
  bg = "none",
  bg_alt = "#e4e7f2",
  bg_float = "#dde1ef",
  bg_highlight = "#d6dbea",
  bg_visual = "#cfd6ea",

  -- UI neutrals
  gray = "#7a83b5",
  gray_dark = "#5c6399",

  -- Accents
  blue = "#2e7de9",
  blue_bg = "#e1e8fb",    -- Soft blue background
  green = "#9ece6a",
  green_bg = "#e8f3df",   -- Soft green background
  yellow = "#e0af68",
  yellow_bg = "#f5eedb",  -- Soft yellow background
  red = "#f52a65",
  red_bg = "#fbe4e9",     -- Soft red background
  magenta = "#9854f1",
  magenta_bg = "#efe5fd", -- Soft magenta background
  cyan = "#7dcfff",
  cyan_bg = "#e6f6ff",    -- Soft cyan background
}

-- Helper function to apply colors based on mode
local function apply_highlights(is_day_mode)
  local colors = is_day_mode and Shibuya.colors_day or Shibuya.colors

  -- Clear existing highlights
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true

  -- Basic UI
  vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
  vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.fg, bg = colors.bg_float })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg_float })

  -- Cursor and selection
  vim.api.nvim_set_hl(0, "Cursor", { fg = colors.bg, bg = is_day_mode and colors.blue or colors.cursor })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.bg_highlight })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = is_day_mode and colors.blue or colors.yellow, bold = true })

  -- Visual mode
  vim.api.nvim_set_hl(0, "Visual", { bg = colors.bg_visual })

  -- Line numbers
  vim.api.nvim_set_hl(0, "LineNr", { fg = is_day_mode and colors.gray or colors.fg_dark })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = is_day_mode and colors.blue or colors.yellow, bold = true })

  -- Status line
  vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.fg, bg = colors.bg_alt })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg_alt })

  -- Tab line
  vim.api.nvim_set_hl(0, "TabLine", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg_alt })
  vim.api.nvim_set_hl(0, "TabLineSel", { fg = colors.fg, bg = colors.bg })
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = colors.bg_alt })

  -- Window bar
  vim.api.nvim_set_hl(0, "WinBar", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg_alt })
  vim.api.nvim_set_hl(0, "WinBarNC", { fg = colors.bg_alt, bg = colors.bg })

  -- Search
  vim.api.nvim_set_hl(0, "Search", { fg = colors.bg, bg = colors.yellow })
  vim.api.nvim_set_hl(0, "IncSearch", { fg = colors.bg, bg = is_day_mode and colors.blue or colors.yellow, bold = false })

  -- Messages
  vim.api.nvim_set_hl(0, "ErrorMsg", { fg = colors.red, bold = false })
  vim.api.nvim_set_hl(0, "WarningMsg", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "MoreMsg", { fg = colors.green })

  -- Completion menu
  vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.fg, bg = colors.bg_float })
  vim.api.nvim_set_hl(0, "PmenuSel", { fg = colors.bg, bg = is_day_mode and colors.blue or colors.blue })
  vim.api.nvim_set_hl(0, "PmenuThumb", { bg = is_day_mode and colors.blue or colors.blue })
  vim.api.nvim_set_hl(0, "PmenuSbar", { bg = colors.bg_float })

  -- Fold
  vim.api.nvim_set_hl(0, "Folded",
    { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg_float, italic = true })

  -- Split
  vim.api.nvim_set_hl(0, "VertSplit", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg })

  -- =====================
  -- SYNTAX HIGHLIGHTING
  -- =====================

  -- Comments
  vim.api.nvim_set_hl(0, "Comment", { fg = is_day_mode and colors.gray or colors.fg_dark, italic = true })

  -- Strings and constants
  if is_day_mode then
    vim.api.nvim_set_hl(0, "String", { fg = colors.green, bg = colors.green_bg, italic = true })
    vim.api.nvim_set_hl(0, "Character", { fg = colors.green, bg = colors.green_bg, italic = true })
  else
    vim.api.nvim_set_hl(0, "String", { fg = colors.green, italic = true })
    vim.api.nvim_set_hl(0, "Character", { fg = colors.green, italic = true })
  end
  vim.api.nvim_set_hl(0, "Constant", { fg = colors.fg, italic = true })

  -- Numbers and booleans
  vim.api.nvim_set_hl(0, "Number", { fg = colors.fg, italic = false })
  vim.api.nvim_set_hl(0, "Boolean", { fg = colors.fg, italic = false, bold = false })
  vim.api.nvim_set_hl(0, "Float", { fg = colors.fg, italic = false })

  -- Functions and methods
  if is_day_mode then
    vim.api.nvim_set_hl(0, "Function", { fg = colors.magenta, bg = colors.magenta_bg })
    vim.api.nvim_set_hl(0, "Method", { fg = colors.magenta, bg = colors.magenta_bg })
  else
    vim.api.nvim_set_hl(0, "Function", { fg = colors.magenta })
    vim.api.nvim_set_hl(0, "Method", { fg = colors.magenta })
  end

  -- Variables and identifiers
  vim.api.nvim_set_hl(0, "Identifier", { fg = colors.fg, italic = true })
  vim.api.nvim_set_hl(0, "Variable", { fg = colors.fg, italic = true })

  -- Keywords and control flow
  if is_day_mode then
    vim.api.nvim_set_hl(0, "Keyword", { fg = colors.red, bg = colors.red_bg, italic = true })
  else
    vim.api.nvim_set_hl(0, "Keyword", { fg = colors.magenta, italic = true })
  end
  vim.api.nvim_set_hl(0, "Statement", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "Conditional", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "Repeat", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "Label", { fg = colors.fg })

  if is_day_mode then
    vim.api.nvim_set_hl(0, "Operator", { fg = colors.fg, bg = colors.bg })
  else
    vim.api.nvim_set_hl(0, "Operator", { fg = colors.red })
  end

  vim.api.nvim_set_hl(0, "Exception", { fg = colors.yellow })

  -- Preprocessor and includes
  vim.api.nvim_set_hl(0, "PreProc", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "Include", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "Define", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "Macro", { fg = colors.fg })

  -- Types
  if is_day_mode then
    vim.api.nvim_set_hl(0, "Type", { fg = colors.red, bg = colors.red_bg })
    vim.api.nvim_set_hl(0, "StorageClass", { fg = colors.red, bg = colors.red_bg })
  else
    vim.api.nvim_set_hl(0, "Type", { fg = colors.fg })
    vim.api.nvim_set_hl(0, "StorageClass", { fg = colors.fg })
  end
  vim.api.nvim_set_hl(0, "Structure", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "Typedef", { fg = colors.fg })

  -- Special
  vim.api.nvim_set_hl(0, "Special", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "SpecialChar", { fg = colors.magenta })
  vim.api.nvim_set_hl(0, "Tag", { fg = colors.blue })
  vim.api.nvim_set_hl(0, "Delimiter", { fg = colors.fg })

  -- Special comments and TODOs
  vim.api.nvim_set_hl(0, "SpecialComment", { fg = colors.yellow, bold = false })
  if is_day_mode then
    vim.api.nvim_set_hl(0, "Todo", { fg = colors.bg, bg = colors.yellow, bold = true, italic = true })
  else
    vim.api.nvim_set_hl(0, "Todo", { fg = colors.fg_dark, bg = colors.yellow, bold = false, italic = true })
  end
  vim.api.nvim_set_hl(0, "Debug", { fg = colors.red })

  -- Underlined text
  vim.api.nvim_set_hl(0, "Underlined", { underline = true })

  -- Errors
  vim.api.nvim_set_hl(0, "Error", { fg = colors.red, bold = false })

  -- Diagnostics (LSP)
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.red })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = colors.blue })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = colors.fg })

  vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = colors.red })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = colors.yellow })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = colors.blue })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint",
    { undercurl = true, sp = is_day_mode and colors.gray or colors.fg_dark })

  -- Diff
  vim.api.nvim_set_hl(0, "DiffAdd", { fg = colors.green, bg = colors.bg })
  vim.api.nvim_set_hl(0, "DiffChange", { fg = colors.yellow, bg = colors.bg })
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = colors.red, bg = colors.bg })
  vim.api.nvim_set_hl(0, "DiffText", { bg = colors.fg, fg = colors.bg })

  -- Non-text
  vim.api.nvim_set_hl(0, "NonText", { fg = is_day_mode and colors.gray or colors.fg_dark })
  vim.api.nvim_set_hl(0, "Whitespace", { fg = is_day_mode and colors.gray or colors.fg_dark })

  -- Match pairs
  vim.api.nvim_set_hl(0, "MatchParen", { fg = colors.yellow, bg = colors.yellow_bg })

  -- Window separator
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = is_day_mode and colors.gray or colors.fg_dark })
  vim.api.nvim_set_hl(0, "Title", { fg = is_day_mode and colors.gray or colors.fg_dark })

  -- =====================
  -- TREE-SITTER
  -- =====================

  -- Keywords
  if is_day_mode then
    vim.api.nvim_set_hl(0, "@keyword", { fg = colors.red, bg = colors.red_bg, italic = true })
  else
    vim.api.nvim_set_hl(0, "@keyword", { fg = colors.magenta, italic = true })
  end

  -- Functions
  if is_day_mode then
    vim.api.nvim_set_hl(0, "@function", { fg = colors.magenta, bg = colors.magenta_bg })
    vim.api.nvim_set_hl(0, "@function.call", { fg = colors.magenta, bg = colors.magenta_bg })
  else
    vim.api.nvim_set_hl(0, "@function", { fg = colors.magenta })
    vim.api.nvim_set_hl(0, "@function.call", { fg = colors.magenta })
  end

  -- Methods
  if is_day_mode then
    vim.api.nvim_set_hl(0, "@method", { fg = colors.magenta, bg = colors.magenta_bg })
    vim.api.nvim_set_hl(0, "@method.call", { fg = colors.magenta, bg = colors.magenta_bg })
  else
    vim.api.nvim_set_hl(0, "@method", { fg = colors.magenta })
    vim.api.nvim_set_hl(0, "@method.call", { fg = colors.magenta })
  end

  -- Variables
  vim.api.nvim_set_hl(0, "@variable", { fg = colors.fg })
  if is_day_mode then
    vim.api.nvim_set_hl(0, "@variable.builtin", { fg = colors.blue, bg = colors.blue_bg })
  else
    vim.api.nvim_set_hl(0, "@variable.builtin", { fg = colors.red })
  end

  -- Namespaces / modules
  if is_day_mode then
    vim.api.nvim_set_hl(0, "@namespace", { fg = colors.red, bg = colors.red_bg })
  else
    vim.api.nvim_set_hl(0, "@namespace", { fg = colors.magenta })
  end

  -- Properties / fields
  vim.api.nvim_set_hl(0, "@field", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "@property", { fg = colors.fg })
end

Shibuya.setup = function(opts)
  opts = opts or {}
  local is_day_mode = opts.mode == "day"
  
  -- Update vim.o.background to match the mode
  vim.o.background = is_day_mode and "light" or "dark"
  
  vim.g.colors_name = is_day_mode and "shibuya_day" or "shibuya"
  apply_highlights(is_day_mode)

  -- Re-apply highlights after UI loads
  vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
    once = true,
    callback = function()
      apply_highlights(is_day_mode)
    end,
  })
end

-- Helper function to toggle between modes
Shibuya.toggle_mode = function()
  local new_mode = (vim.o.background == "light") and "night" or "day"
  Shibuya.setup({ mode = new_mode })
  print("Switched to " .. new_mode .. " mode")
end
-- Initialize the theme (default to dark mode)
Shibuya.setup({ mode = "night" })

vim.keymap.set('n', '<leader>ub', function() Shibuya.toggle_mode() end, { desc = 'Toggle color theme' })
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
  'https://github.com/nvim-treesitter/nvim-treesitter',
}

vim.pack.add(plugins)

---}}}

--{{{ -- Mason LSP
require('mason').setup()

require('mason-lspconfig').setup {
  ensure_installed = { 'lua_ls', 'rust_analyzer', 'marksman' },
}
--}}}

--{{{
-- require 'nvim-treesitter'.install {
--   "java",
--   "javadoc",
--   "bash",
--   "c",
--   "diff",
--   "html",
--   "css",
--   "javascript",
--   "jsdoc",
--   "json",
--   "jsonc",
--   "lua",
--   "luadoc",
--   "luap",
--   "markdown",
--   "markdown_inline",
--   "printf",
--   "python",
--   "query",
--   "regex",
--   "toml",
--   "tsx",
--   "typescript",
--   "vim",
--   "vimdoc",
--   "xml",
--   "yaml",
--   "rust",
-- }

vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
--}}}
