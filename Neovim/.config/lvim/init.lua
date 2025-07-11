-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- vim.o.cmdheight = 0

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 400

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.o.spell = false
vim.opt.spelllang = { 'pt_br', 'en_us', 'es' }

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = false
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
-- vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- Options

vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 2 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 2 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 2 -- Number of spaces inserted when indenting
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmode = true

-- Keymaps
vim.keymap.set('n', '<leader>w', '<C-w>')
vim.keymap.set('n', '<leader>wt', ':ter<cr>', { desc = 'new terminal' })

vim.keymap.set('v', '<S-k>', ":m '<-2<CR>gv=gv", { silent = true, desc = 'Move Line Up' })
vim.keymap.set('v', '<S-j>', ":m '>+1<CR>gv=gv", { silent = true, desc = 'Move Line Down' })

-- tabs/terminal
vim.keymap.set('n', '<leader>tl', '<cmd>tablast<cr>', { desc = 'Last Tab' })
vim.keymap.set('n', '<leader>to', '<cmd>tabonly<cr>', { desc = 'Close Other Tabs' })
vim.keymap.set('n', '<leader>tf', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<cr>', { desc = 'New Tab' })
vim.keymap.set('n', '<leader>t]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
vim.keymap.set('n', '<leader>td', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
vim.keymap.set('n', '<leader>t[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

vim.keymap.set('n', '<leader>tm', '<Cmd>terminal<Cr>', { silent = true, desc = 'New Buffer Terminal' })
vim.keymap.set('n', '<leader>tv', '<Cmd>vertical terminal<CR>', { silent = true, desc = 'Vertical Terminal' })
vim.keymap.set('n', '<leader>ts', '<Cmd>horizontal terminal<CR>', { silent = true, desc = 'Horizontal Terminal' })

vim.keymap.set('t', '<C-h>', '<C-\\><C-N><C-w>h:startinsert<Cr>')
vim.keymap.set('t', '<C-j>', '<C-\\><C-N><C-w>j:startinsert<Cr>')
vim.keymap.set('t', '<C-k>', '<C-\\><C-N><C-w>k:startinsert<Cr>')
vim.keymap.set('t', '<C-l>', '<C-\\><C-N><C-w>l:startinsert<Cr>')

vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { desc = 'Next Quickfix' })
vim.keymap.set('n', ']Q', '<cmd>clast<cr>', { desc = 'Last Quickfix' })
vim.keymap.set('n', '[q', '<cmd>cprev<cr>', { desc = 'Previous Quickfix' })
vim.keymap.set('n', '[Q', '<cmd>cfisrt<cr>', { desc = 'First Quickfix' })
-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
vim.keymap.set('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
vim.keymap.set('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
vim.keymap.set('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
vim.keymap.set('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
vim.keymap.set('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
vim.keymap.set('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

-- vim.keymap.set('v', '<C-d>', "<C-d>zz", { silent = true, desc = 'Move Up and center' })
-- vim.keymap.set('v', '<C-u>', "<C-u>zz", { silent = true, desc = 'Move Down and center' })

-- vim.keymap.set('n', 'j', 'gj', { silent = true, desc = 'Down in Wrap' })
-- vim.keymap.set('n', 'k', 'gk', { silent = true, desc = 'Up in Wrap' })
-- vim.keymap.set('n', '$', 'g$', { silent = true, desc = '' })
-- vim.keymap.set('n', '0', 'g0', { silent = true, desc = '' })

vim.keymap.set('n', '[b', '<Cmd>bp<Cr>', { silent = true })
vim.keymap.set('n', ']b', '<Cmd>bn<Cr>', { silent = true })

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>xx', function()
  vim.diagnostic.setqflist()
end, { desc = 'Open diagnostic [Q]uickfix list' })

-- local quickfix_open = false
-- local function toggle_quickfix(quickfix_state)
--   if quickfix_open then
--     vim.cmd 'cclose'
--     quickfix_open = false
--   else
--     vim.cmd 'copen'
--     quickfix_open = true
--   end
-- end
-- vim.keymap.set('n', '<leader>xx', function()
--   vim.diagnostic.setqflist()
-- end, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- Double Control-c to Escape terminal mode
-- vim.keymap.set('t', '<C-c><C-c>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have coliding keymaps or are not able to send distinct keycodes
vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

-- resize window
vim.keymap.set('n', '<C-A-h>', '<C-w><', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-A-l>', '<C-w>>', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-A-j>', '<C-w>+', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-A-k>', '<C-w>-', { desc = 'Move window to the upper' })

vim.keymap.set('n', '<leader>m', '`', { desc = 'Go to Mark' })

-- vim.keymap.set({ 'i', 'c' }, '<C-p>', '<Up>', { silent = true })
-- vim.keymap.set({ 'i', 'c' }, '<C-n>', '<Down>', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<C-a>', '<Home>', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<C-f>', '<Right>', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<C-b>', '<Left>', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<C-e>', '<End>', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<A-d>', '<C-o>dw', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<C-d>', '<C-o>dl', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<C-k>', '<Esc>lDa', { silent = true })
vim.keymap.set({ 'i', 'c' }, '<C-u>', '<Esc>d0xi', { silent = true })
vim.keymap.set('i', '<A-f>', '<C-o>w', { silent = true })
vim.keymap.set('i', '<A-b>', '<C-o>b', { silent = true })
vim.keymap.set('i', '<A-}>', '<C-o>}', { silent = true })
vim.keymap.set('i', '<A-{>', '<C-o>{', { silent = true })
vim.keymap.set('i', '<A-<>', '<C-o>gg', { silent = true })
vim.keymap.set('i', '<A->>', '<C-o>G', { silent = true })
vim.keymap.set('i', '<C-x><C-s>', '<C-o>:w<CR>a', { silent = true })
vim.keymap.set('i', '<C-x>s', '<C-o>:wa<CR>a', { silent = false })
vim.keymap.set('i', '<C-x>k', '<C-o>:bd!<CR>', { silent = false })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommnds`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup(
  {
    -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

    -- NOTE: Plugins can also be added by using a table,
    -- with the first argument being the link and the following
    -- keys can be used to configure plugin behavior/loading/etc.
    --
    -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
    --

    -- Alternatively, use `config = function() ... end` for full control over the configuration.
    -- If you prefer to call `setup` explicitly, use:
    {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup {
          -- Your gitsigns configuration here
        }
      end,
    },
    --
    -- Here is a more advanced example where we pass configuration
    -- options to `gitsigns.nvim`.
    --
    -- See `:help gitsigns` to understand what the configuration keys do
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
      'lewis6991/gitsigns.nvim',
      opts = {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      },
    },

    {
      'tpope/vim-fugitive',
    },

    -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
    --
    -- This is often very useful to both group configuration, as well as handle
    -- lazy loading plugins that don't need to be loaded immediately at startup.
    --
    -- For example, in the following configuration, we use:
    --  event = 'VimEnter'
    --
    -- which loads which-key before all the UI elements are loaded. Events can be
    -- normal autocommands events (`:help autocmd-events`).
    --
    -- Then, because we use the `opts` key (recommended), the configuration runs
    -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

    { -- Useful plugin to show you pending keybinds.
      'folke/which-key.nvim',
      event = 'VimEnter', -- Sets the loading event to 'VimEnter'
      opts = {
        preset = 'helix',
        -- delay between pressing a key and opening which-key (milliseconds)
        -- this setting is independent of vim.opt.timeoutlen
        delay = 0,
        icons = {
          -- set icon mappings to true if you have a Nerd Font
          mappings = vim.g.have_nerd_font,
          -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
          -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
          keys = vim.g.have_nerd_font and {} or {
            Up = '<Up> ',
            Down = '<Down> ',
            Left = '<Left> ',
            Right = '<Right> ',
            C = '<C-…> ',
            M = '<M-…> ',
            D = '<D-…> ',
            S = '<S-…> ',
            CR = '<CR> ',
            Esc = '<Esc> ',
            ScrollWheelDown = '<ScrollWheelDown> ',
            ScrollWheelUp = '<ScrollWheelUp> ',
            NL = '<NL> ',
            BS = '<BS> ',
            Space = '<Space> ',
            Tab = '<Tab> ',
            F1 = '<F1>',
            F2 = '<F2>',
            F3 = '<F3>',
            F4 = '<F4>',
            F5 = '<F5>',
            F6 = '<F6>',
            F7 = '<F7>',
            F8 = '<F8>',
            F9 = '<F9>',
            F10 = '<F10>',
            F11 = '<F11>',
            F12 = '<F12>',
          },
        },

        -- Document existing key chains
        spec = {
          { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
          { '<leader>d', group = '[D]ocument' },
          { '<leader>r', group = '[R]ename/[R]eference' },
          { '<leader>s', group = '[S]earch' },
          { '<leader>f', group = '[F]ind' },
          { '<leader>u', group = '[U]i' },
          { '<leader>g', group = '[G]it' },
          { '<leader>b', group = '[B]uffer' },
          { '<leader>w', group = '[W]indow' },
          { '<leader>t', group = '[T]oggle' },
          { '<leader>o', group = '[O]ptions/Custom', mode = { 'n' } },
        },
      },
    },

    -- NOTE: Plugins can specify dependencies.
    --
    -- The dependencies are proper plugin specifications as well - anything
    -- you do for a plugin at the top level, you can do for a dependency.
    --
    -- Use the `dependencies` key to specify the dependencies of a particular plugin

    -- { -- Fuzzy Finder (files, lsp, etc)
    --   'nvim-telescope/telescope.nvim',
    --   event = 'VimEnter',
    --   branch = '0.1.x',
    --   dependencies = {
    --     'nvim-lua/plenary.nvim',
    --     { -- If encountering errors, see telescope-fzf-native README for installation instructions
    --       'nvim-telescope/telescope-fzf-native.nvim',
    --
    --       -- `build` is used to run some command when the plugin is installed/updated.
    --       -- This is only run then, not every time Neovim starts up.
    --       build = 'make',
    --
    --       -- `cond` is a condition used to determine whether this plugin should be
    --       -- installed and loaded.
    --       cond = function()
    --         return vim.fn.executable 'make' == 1
    --       end,
    --     },
    --     { 'nvim-telescope/telescope-ui-select.nvim' },
    --
    --     -- Useful for getting pretty icons, but requires a Nerd Font.
    --     { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    --   },
    --   config = function()
    --     -- Telescope is a fuzzy finder that comes with a lot of different things that
    --     -- it can fuzzy find! It's more than just a "file finder", it can search
    --     -- many different aspects of Neovim, your workspace, LSP, and more!
    --     --
    --     -- The easiest way to use Telescope, is to start by doing something like:
    --     --  :Telescope help_tags
    --     --
    --     -- After running this command, a window will open up and you're able to
    --     -- type in the prompt window. You'll see a list of `help_tags` options and
    --     -- a corresponding preview of the help.
    --     --
    --     -- Two important keymaps to use while in Telescope are:
    --     --  - Insert mode: <c-/>
    --     --  - Normal mode: ?
    --     --
    --     -- This opens a window that shows you all of the keymaps for the current
    --     -- Telescope picker. This is really useful to discover what Telescope can
    --     -- do as well as how to actually do it!
    --
    --     -- [[ Configure Telescope ]]
    --     -- See `:help telescope` and `:help telescope.setup()`
    --     require('telescope').setup {
    --       -- You can put your default mappings / updates / etc. in here
    --       --  All the info you're looking for is in `:help telescope.setup()`
    --       --
    --       -- defaults = {
    --       --   mappings = {
    --       --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
    --       --   },
    --       -- },
    --       -- pickers = {}
    --       extensions = {
    --         ['ui-select'] = {
    --           require('telescope.themes').get_dropdown(),
    --         },
    --       },
    --     }
    --
    --     -- Enable Telescope extensions if they are installed
    --     pcall(require('telescope').load_extension, 'fzf')
    --     pcall(require('telescope').load_extension, 'ui-select')
    --
    --     -- See `:help telescope.builtin`
    --     local builtin = require 'telescope.builtin'
    --     vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    --     vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    --     vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    --     vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    --     vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    --     vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    --     vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    --     vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    --     vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    --     vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = '[ ] Find existing buffers' })
    --
    --     -- Slightly advanced example of overriding default behavior and theme
    --     vim.keymap.set('n', '<leader>/', function()
    --       -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    --       builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    --         winblend = 10,
    --         previewer = false,
    --       })
    --     end, { desc = '[/] Fuzzily search in current buffer' })
    --
    --     -- It's also possible to pass additional configuration options.
    --     --  See `:help telescope.builtin.live_grep()` for information about particular keys
    --     vim.keymap.set('n', '<leader>s/', function()
    --       builtin.live_grep {
    --         grep_open_files = true,
    --         prompt_title = 'Live Grep in Open Files',
    --       }
    --     end, { desc = '[S]earch [/] in Open Files' })
    --
    --     -- Shortcut for searching your Neovim configuration files
    --     vim.keymap.set('n', '<leader>sn', function()
    --       builtin.find_files { cwd = vim.fn.stdpath 'config' }
    --     end, { desc = '[S]earch [N]eovim files' })
    --   end,
    -- },

    -- LSP Plugins
    {
      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          -- Load luvit types when the `vim.uv` word is found
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },
    {
      -- Main LSP Configuration
      'neovim/nvim-lspconfig',
      dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        -- Mason must be loaded before its dependents so we need to set it up here.
        -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
        { 'williamboman/mason.nvim', opts = {} },
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

        -- Useful status updates for LSP.
        { 'j-hui/fidget.nvim', opts = {} },

        -- Allows extra capabilities provided by nvim-cmp
        'hrsh7th/cmp-nvim-lsp',
      },
      config = function()
        -- Brief aside: **What is LSP?**
        --
        -- LSP is an initialism you've probably heard, but might not understand what it is.
        --
        -- LSP stands for Language Server Protocol. It's a protocol that helps editors
        -- and language tooling communicate in a standardized fashion.
        --
        -- In general, you have a "server" which is some tool built to understand a particular
        -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
        -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
        -- processes that communicate with some "client" - in this case, Neovim!
        --
        -- LSP provides Neovim with features like:
        --  - Go to definition
        --  - Find references
        --  - Autocompletion
        --  - Symbol Search
        --  - and more!
        --
        -- Thus, Language Servers are external tools that must be installed separately from
        -- Neovim. This is where `mason` and related plugins come into play.
        --
        -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
        -- and elegantly composed help section, `:help lsp-vs-treesitter`

        --  This function gets run when an LSP attaches to a particular buffer.
        --    That is to say, every time a new file is opened that is associated with
        --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
        --    function will be executed to configure the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
          callback = function(event)
            -- NOTE: Remember that Lua is a real programming language, and as such it is possible
            -- to define small helper and utility functions so you don't have to repeat yourself.
            --
            -- In this case, we create a function that lets us more easily define mappings specific
            -- for LSP related items. It sets the mode, buffer and description for us each time.
            local map = function(keys, func, desc, mode)
              mode = mode or 'n'
              vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
            end

            -- Jump to the definition of the word under your cursor.
            --  This is where a variable was first declared, or where a function is defined, etc.
            --  To jump back, press <C-t>.
            -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

            -- Find references for the word under your cursor.
            -- map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

            -- Jump to the implementation of the word under your cursor.
            --  Useful when your language has ways of declaring types without an actual implementation.
            -- map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

            -- Jump to the type of the word under your cursor.
            --  Useful when you're not sure what type a variable is and you want to see
            --  the definition of its *type*, not where it was *defined*.
            -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

            -- Fuzzy find all the symbols in your current document.
            --  Symbols are things like variables, functions, types, etc.
            -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

            -- Fuzzy find all the symbols in your current workspace.
            --  Similar to document symbols, except searches over your entire project.
            -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

            -- Rename the variable under your cursor.
            --  Most Language Servers support renaming across files, etc.
            map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

            -- Execute a code action, usually your cursor needs to be on top of an error
            -- or a suggestion from your LSP for this to activate.
            map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

            -- WARN: This is not Goto Definition, this is Goto Declaration.
            --  For example, in C this would take you to the header.
            map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

            -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
            ---@param client vim.lsp.Client
            ---@param method vim.lsp.protocol.Method
            ---@param bufnr? integer some lsp support methods only in specific files
            ---@return boolean
            local function client_supports_method(client, method, bufnr)
              if vim.fn.has 'nvim-0.11' == 1 then
                return client:supports_method(method, bufnr)
              else
                return client.supports_method(method, { bufnr = bufnr })
              end
            end

            -- The following two autocommands are used to highlight references of the
            -- word under your cursor when your cursor rests there for a little while.
            --    See `:help CursorHold` for information about when this is executed
            --
            -- When you move your cursor, the highlights will be cleared (the second autocommand).
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
              local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                end,
              })
            end

            -- The following code creates a keymap to toggle inlay hints in your
            -- code, if the language server you are using supports them
            --
            -- This may be unwanted, since they displace some of your code
            if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
              map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
              end, '[T]oggle Inlay [H]ints')
            end
          end,
        })

        -- Diagnostic Config
        -- See :help vim.diagnostic.Opts
        vim.diagnostic.config {
          severity_sort = true,
          float = { border = 'rounded', source = 'if_many' },
          underline = { severity = vim.diagnostic.severity.ERROR },
          signs = vim.g.have_nerd_font and {
            text = {
              [vim.diagnostic.severity.ERROR] = '󰅚 ',
              [vim.diagnostic.severity.WARN] = '󰀪 ',
              [vim.diagnostic.severity.INFO] = '󰋽 ',
              [vim.diagnostic.severity.HINT] = '󰌶 ',
            },
          } or {},
          virtual_text = {
            source = 'if_many',
            spacing = 2,
            format = function(diagnostic)
              local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
              }
              return diagnostic_message[diagnostic.severity]
            end,
          },
        }

        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        -- Enable the following language servers
        --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
        --
        --  Add any additional override configuration in the following tables. Available keys are:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
        local servers = {
          -- clangd = {},
          -- gopls = {},
          -- pyright = {},
          -- rust_analyzer = {},
          -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
          --
          -- Some languages (like typescript) have entire language plugins that can be useful:
          --    https://github.com/pmizio/typescript-tools.nvim
          --
          -- But for many setups, the LSP (`ts_ls`) will work just fine
          -- ts_ls = {},
          --

          lua_ls = {
            -- cmd = { ... },
            -- filetypes = { ... },
            -- capabilities = {},
            settings = {
              Lua = {
                completion = {
                  callSnippet = 'Replace',
                },
                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                -- diagnostics = { disable = { 'missing-fields' } },
              },
            },
          },
        }

        -- Ensure the servers and tools above are installed
        --
        -- To check the current status of installed tools and/or manually install
        -- other tools, you can run
        --    :Mason
        --
        -- You can press `g?` for help in this menu.
        --
        -- `mason` had to be setup earlier: to configure its options see the
        -- `dependencies` table for `nvim-lspconfig` above.
        --
        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
          'stylua', -- Used to format Lua code
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        require('mason-lspconfig').setup {
          ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
          automatic_installation = false,
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              -- This handles overriding only values explicitly passed
              -- by the server configuration above. Useful when disabling
              -- certain features of an LSP (for example, turning off formatting for ts_ls)
              server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
              require('lspconfig')[server_name].setup(server)
            end,
          },
        }
      end,
    },

    { -- Autoformat
      'stevearc/conform.nvim',
      event = { 'BufWritePre' },
      cmd = { 'ConformInfo' },
      keys = {
        {
          '<leader>f',
          function()
            require('conform').format { async = true, lsp_format = 'fallback' }
          end,
          mode = '',
          desc = '[F]ormat buffer',
        },
      },
      opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
          -- Disable "format_on_save lsp_fallback" for languages that don't
          -- have a well standardized coding style. You can add additional
          -- languages here or re-enable it for the disabled ones.
          local disable_filetypes = { c = true, cpp = true }
          if disable_filetypes[vim.bo[bufnr].filetype] then
            return nil
          else
            return {
              timeout_ms = 500,
              lsp_format = 'fallback',
            }
          end
        end,
        formatters_by_ft = {
          lua = { 'stylua' },
          -- Conform can also run multiple formatters sequentially
          -- python = { "isort", "black" },
          --
          -- You can use 'stop_after_first' to run the first available formatter from the list
          -- javascript = { "prettierd", "prettier", stop_after_first = true },
        },
      },
    },

    { -- Autocompletion
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        {
          'L3MON4D3/LuaSnip',
          build = (function()
            -- Build Step is needed for regex support in snippets.
            -- This step is not supported in many windows environments.
            -- Remove the below condition to re-enable on windows.
            if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
              return
            end
            return 'make install_jsregexp'
          end)(),
          dependencies = {
            -- `friendly-snippets` contains a variety of premade snippets.
            --    See the README about individual language/framework/plugin snippets:
            --    https://github.com/rafamadriz/friendly-snippets
            -- {
            --   'rafamadriz/friendly-snippets',
            --   config = function()
            --     require('luasnip.loaders.from_vscode').lazy_load()
            --   end,
            -- },
          },
        },
        'saadparwaiz1/cmp_luasnip',

        -- Adds other completion capabilities.
        --  nvim-cmp does not ship with all sources by default. They are split
        --  into multiple repos for maintenance purposes.
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-nvim-lsp-signature-help',
      },
      config = function()
        -- See `:help cmp`
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        luasnip.config.setup {}

        cmp.setup {
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          completion = { completeopt = 'menu,menuone,noinsert' },

          -- For an understanding of why these mappings were
          -- chosen, you will need to read `:help ins-completion`
          --
          -- No, but seriously. Please read `:help ins-completion`, it is really good!
          mapping = cmp.mapping.preset.insert {
            -- Select the [n]ext item
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<Tab>'] = cmp.mapping.select_next_item(),
            -- Select the [p]revious item
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),

            -- Scroll the documentation window [b]ack / [f]orward
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),

            -- Accept ([y]es) the completion.
            --  This will auto-import if your LSP supports it.
            --  This will expand snippets if the LSP sent a snippet.
            ['<C-y>'] = cmp.mapping.confirm { select = true },
            ['<Cr>'] = cmp.mapping.confirm { select = true },

            -- If you prefer more traditional completion keymaps,
            -- you can uncomment the following lines
            --['<CR>'] = cmp.mapping.confirm { select = true },
            --['<Tab>'] = cmp.mapping.select_next_item(),
            --['<S-Tab>'] = cmp.mapping.select_prev_item(),

            -- Manually trigger a completion from nvim-cmp.
            --  Generally you don't need this, because nvim-cmp will display
            --  completions whenever it has completion options available.
            ['<C-Space>'] = cmp.mapping.complete {},

            -- Think of <c-l> as moving to the right of your snippet expansion.
            --  So if you have a snippet that's like:
            --  function $name($args)
            --    $body
            --  end
            --
            -- <c-l> will move you to the right of each of the expansion locations.
            -- <c-h> is similar, except moving you backwards.
            ['<C-l>'] = cmp.mapping(function()
              if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              end
            end, { 'i', 's' }),
            ['<C-h>'] = cmp.mapping(function()
              if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              end
            end, { 'i', 's' }),

            -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
            --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
          },
          sources = {
            {
              name = 'lazydev',
              -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
              group_index = 0,
            },
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
            { name = 'nvim_lsp_signature_help' },
          },
        }
      end,
    },

    { -- You can easily change to a different colorscheme.
      -- Change the name of the colorscheme plugin below, and then
      -- change the command in the config to whatever the name of that colorscheme is.
      --
      -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
      'folke/tokyonight.nvim',
      priority = 1000, -- Make sure to load this before all the other start plugins.
      config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('tokyonight').setup {
          styles = {
            comments = { italic = false }, -- Disable italics in comments
          },
        }

        -- Load the colorscheme here.
        -- Like many other themes, this one has different styles, and you could load
        -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
        vim.cmd.colorscheme 'tokyonight-night'
      end,
    },

    -- Highlight todo, notes, etc in comments
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

    -- {
    --   'nvim-java/nvim-java',
    --   dependencies = {
    --     'williamboman/mason.nvim',
    --     'williamboman/mason-lspconfig.nvim',
    --     'neovim/nvim-lspconfig',
    --     'mfussenegger/nvim-dap',
    --   },
    --   config = function()
    --     require('java').setup {
    --       jdtls = {
    --         version = 'v1.43.0',
    --       },
    --       jdk = {
    --         -- install jdk using mason.nvim
    --         auto_install = true,
    --         version = '21.0.7',
    --       },
    --     }
    --     require('lspconfig').jdtls.setup {}
    --   end,
    --   keys = {
    --     -- { "<leader>cjr", "<Cmd>JavaRunnerRunMain<Cr>", { desc = "Run Main" } },
    --     -- { "<leader>cjs", "<Cmd>JavaRunnerStopMain<Cr>", { desc = "Stop Main" } },
    --   },
    -- },

    { -- Collection of various small independent plugins/modules
      'echasnovski/mini.nvim',
      config = function()
        -- Better Around/Inside textobjects
        --
        -- Examples:
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        --  - ci'  - [C]hange [I]nside [']quote
        require('mini.ai').setup { n_lines = 500 }
        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require('mini.surround').setup()
        --
        -- -- Simple and easy statusline.
        -- --  You could remove this setup call if you don't like it,
        -- --  and try some other statusline plugin
        -- local statusline = require 'mini.statusline'
        -- -- set use_icons to true if you have a Nerd Font
        -- statusline.setup { use_icons = vim.g.have_nerd_font }
        -- -- You can configure sections in the statusline by overriding their
        -- -- default behavior. For example, here we set the section for
        -- -- cursor location to LINE:COLUMN
        -- ---@diagnostic disable-next-line: duplicate-set-field
        -- statusline.section_location = function()
        --   return '%2l:%-2v'
        -- end
        -- -- ... and there is more!
        -- --  Check out: https://github.com/echasnovski/mini.nvim
        -- Mini pairs
        require('mini.pairs').setup {
          -- In which modes mappings from this `config` should be created
          modes = { insert = true, command = false, terminal = false },

          -- Global mappings. Each right hand side should be a pair information, a
          -- table with at least these fields (see more in |MiniPairs.map|):
          -- - <action> - one of 'open', 'close', 'closeopen'.
          -- - <pair> - two character string for pair to be used.
          -- By default pair is not inserted after `\`, quotes are not recognized by
          -- <CR>, `'` does not insert pair after a letter.
          -- Only parts of tables can be tweaked (others will use these defaults).
          mappings = {
            ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
            ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
            ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },
            ['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },

            [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
            [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
            ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },
            ['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].' },

            ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
            ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
            ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
          },
        }
        -- -- Mini tabline
        -- require('mini.tabline').setup()
        -- -- Mini pick config
        -- require('mini.pick').setup()
      end,
    },

    -- Flash config
    {
      'folke/flash.nvim',
      event = 'VeryLazy',
      vscode = true,
      ---@type Flash.Config
      opts = {},
      -- stylua: ignore
      -- Remove default keymap for flash in lazyvim
      -- config = function ()
      --   vim.keymap.del("n", "s")
      --   vim.keymap.del("n", "S")
      -- end,
      keys = {
        {
          "ss",
          mode = { "n", "x", "o" },
          function()
            require("flash").jump()
          end,
          desc = "Flash",
        },
        {
          "sS",
          mode = { "n", "o", "x" },
          function()
            require("flash").treesitter()
          end,
          desc = "Flash Treesitter",
        },
        {
          "r",
          mode = "o",
          function()
            require("flash").remote()
          end,
          desc = "Remote Flash",
        },
        {
          "R",
          mode = { "o", "x" },
          function()
            require("flash").treesitter_search()
          end,
          desc = "Treesitter Search",
        },
        {
          "<c-s>",
          mode = { "c" },
          function()
            require("flash").toggle()
          end,
          desc = "Toggle Flash Search",
        },
      },
    },
    { -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      main = 'nvim-treesitter.configs', -- Sets main module to use for opts
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      opts = {
        ensure_installed = {
          'java',
          'javadoc',
          'bash',
          'c',
          'diff',
          'html',
          'css',
          'javascript',
          'jsdoc',
          'json',
          'jsonc',
          'lua',
          'luadoc',
          'luap',
          'markdown',
          'markdown_inline',
          'printf',
          'python',
          'query',
          'regex',
          'toml',
          'tsx',
          'typescript',
          'vim',
          'vimdoc',
          'xml',
          'yaml',
          'rust',
        },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
          enable = true,
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
      },
      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    },
    -- Oil Config
    {
      'stevearc/oil.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      keys = {
        { '<leader>oe', '<Cmd>Oil<Cr>', desc = 'Oil' },
        { '<leader><Cr>', '<Cmd>Oil --float<Cr>', desc = 'Oil' },
      },
      config = function()
        require('oil').setup {
          -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
          -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
          default_file_explorer = false,
          -- Id is automatically added at the beginning, and name at the end
          -- See :help oil-columns
          columns = {
            'icon',
            -- "permissions",
            -- "size",
            -- "mtime",
          },
          -- Buffer-local options to use for oil buffers
          buf_options = {
            buflisted = false,
            bufhidden = 'hide',
          },
          -- Window-local options to use for oil buffers
          win_options = {
            wrap = false,
            signcolumn = 'no',
            cursorcolumn = false,
            foldcolumn = '0',
            spell = false,
            list = false,
            conceallevel = 3,
            concealcursor = 'nvic',
          },
          -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
          delete_to_trash = true,
          -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
          skip_confirm_for_simple_edits = true,
          -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
          -- (:help prompt_save_on_select_new_entry)
          prompt_save_on_select_new_entry = true,
          -- Oil will automatically delete hidden buffers after this delay
          -- You can set the delay to false to disable cleanup entirely
          -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
          cleanup_delay_ms = 2000,
          lsp_file_methods = {
            -- Enable or disable LSP file operations
            enabled = true,
            -- Time to wait for LSP file operations to complete before skipping
            timeout_ms = 1000,
            -- Set to true to autosave buffers that are updated with LSP willRenameFiles
            -- Set to "unmodified" to only save unmodified buffers
            autosave_changes = false,
          },
          -- Constrain the cursor to the editable parts of the oil buffer
          -- Set to `false` to disable, or "name" to keep it on the file names
          constrain_cursor = 'editable',
          -- Set to true to watch the filesystem for changes and reload oil
          watch_for_changes = false,
          -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
          -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
          -- Additionally, if it is a string that matches "actions.<name>",
          -- it will use the mapping at require("oil.actions").<name>
          -- Set to `false` to remove a keymap
          -- See :help oil-actions for a list of all available actions
          keymaps = {
            ['g?'] = { 'actions.show_help', mode = 'n' },
            ['<CR>'] = 'actions.select',
            ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
            ['<C-t>'] = { 'actions.select', opts = { tab = true } },
            ['<C-p>'] = 'actions.preview',
            ['<C-c>'] = { 'actions.close', mode = 'n' },
            ['<Esc><Esc>'] = { 'actions.close', mode = 'n' },
            ['<C-l>'] = 'actions.refresh',
            ['-'] = { 'actions.parent', mode = 'n' },
            ['<Bs>'] = { 'actions.parent', mode = 'n' },
            ['_'] = { 'actions.open_cwd', mode = 'n' },
            ['`'] = { 'actions.cd', mode = 'n' },
            ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
            ['gs'] = { 'actions.change_sort', mode = 'n' },
            ['gx'] = 'actions.open_external',
            ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
            ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
          },
          -- Set to false to disable all of the above keymaps
          use_default_keymaps = true,
          view_options = {
            -- Show files and directories that start with "."
            show_hidden = true,
            -- This function defines what is considered a "hidden" file
            is_hidden_file = function(name, bufnr)
              local m = name:match '^%.'
              return m ~= nil
            end,
            -- This function defines what will never be shown, even when `show_hidden` is set
            is_always_hidden = function(name, bufnr)
              return false
            end,
            -- Sort file names with numbers in a more intuitive order for humans.
            -- Can be "fast", true, or false. "fast" will turn it off for large directories.
            natural_order = 'fast',
            -- Sort file and directory names case insensitive
            case_insensitive = false,
            sort = {
              -- sort order can be "asc" or "desc"
              -- see :help oil-columns to see which columns are sortable
              { 'type', 'asc' },
              { 'name', 'asc' },
            },
            -- Customize the highlight group for the file name
            highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
              return nil
            end,
          },
          -- Extra arguments to pass to SCP when moving/copying files over SSH
          extra_scp_args = {},
          -- EXPERIMENTAL support for performing file operations with git
          git = {
            -- Return true to automatically git add/mv/rm files
            add = function(path)
              return false
            end,
            mv = function(src_path, dest_path)
              return false
            end,
            rm = function(path)
              return false
            end,
          },
          -- Configuration for the floating window in oil.open_float
          float = {
            -- Padding around the floating window
            padding = 5,
            -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            max_width = 0.5,
            max_height = 0.5,
            border = 'rounded',
            win_options = {
              winblend = 0,
            },
            -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
            get_win_title = nil,
            -- preview_split: Split direction: "auto", "left", "right", "above", "below".
            preview_split = 'auto',
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            override = function(conf)
              return conf
            end,
          },
          -- Configuration for the file preview window
          preview_win = {
            -- Whether the preview window is automatically updated when the cursor is moved
            update_on_cursor_moved = true,
            -- How to open the preview window "load"|"scratch"|"fast_scratch"
            preview_method = 'fast_scratch',
            -- A function that returns true to disable preview on a file e.g. to avoid lag
            disable_preview = function(filename)
              return false
            end,
            -- Window-local options to use for preview window buffers
            win_options = {},
          },
          -- Configuration for the floating action confirmation window
          confirmation = {
            -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            -- min_width and max_width can be a single value or a list of mixed integer/float types.
            -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
            max_width = 0.9,
            -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
            min_width = { 40, 0.4 },
            -- optionally define an integer/float for the exact width of the preview window
            width = nil,
            -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            -- min_height and max_height can be a single value or a list of mixed integer/float types.
            -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
            max_height = 0.9,
            -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
            min_height = { 5, 0.1 },
            -- optionally define an integer/float for the exact height of the preview window
            height = nil,
            border = 'rounded',
            win_options = {
              winblend = 0,
            },
          },
          -- Configuration for the floating progress window
          progress = {
            max_width = 0.9,
            min_width = { 40, 0.4 },
            width = nil,
            max_height = { 10, 0.9 },
            min_height = { 5, 0.1 },
            height = nil,
            border = 'rounded',
            minimized_border = 'none',
            win_options = {
              winblend = 0,
            },
          },
          -- Configuration for the floating SSH window
          ssh = {
            border = 'rounded',
          },
          -- Configuration for the floating keymaps help window
          keymaps_help = {
            border = 'rounded',
          },
        }
        -- File Explorer
        -- vim.keymap.set("n", "<leader><Cr>", "<Cmd>Oil<Cr>", { silent = true, desc = "Oil File Manager" })
        -- vim.keymap.set("n", "<leader><Cr>", "<Cmd>Oil<Cr>", { silent = true, desc = "Oil File Manager" })
      end,
    },

    -- Snakcs Pickers
    {
      'folke/snacks.nvim',
      priority = 1000,
      lazy = false,
      ---@type snacks.Config
      opts = {
        bigfile = { enabled = true },
        dashboard = {
          enabled = false,
          ---@class snacks.dashboard.Config
          ---@field enabled? boolean
          ---@field sections snacks.dashboard.Section
          ---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
          width = 60,
          row = nil, -- dashboard position. nil for center
          col = nil, -- dashboard position. nil for center
          pane_gap = 4, -- empty columns between vertical panes
          autokeys = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', -- autokey sequence
          -- These settings are used by some built-in sections
          preset = {
            -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
            ---@type fun(cmd:string, opts:table)|nil
            pick = nil,
            -- Used by the `keys` section to show keymaps.
            -- Set your custom keymaps here.
            -- When using a function, the `items` argument are the default keymaps.
            ---@type snacks.dashboard.Item[]
            keys = {
              { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
              { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
              { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
              { icon = ' ', key = 'z', desc = 'Change Directory', action = ":lua Snacks.dashboard.pick('zoxide')" },
              { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
              { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
              { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
              { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
            },
            -- Used by the `header` section
            header = [[
██       ██     ██ ██    ██    ███    ████████  ██     ██ ████ ██     ██ 
██       ██     ██ ███   ██   ██ ██   ██     ██ ██     ██  ██  ███   ███ 
██       ██     ██ ████  ██  ██   ██  ██     ██ ██     ██  ██  ████ ████ 
██       ██     ██ ██ ██ ██ ██     ██ ████████  ██     ██  ██  ██ ███ ██ 
██       ██     ██ ██  ████ █████████ ██   ██    ██   ██   ██  ██     ██ 
██       ██     ██ ██   ███ ██     ██ ██    ██    ██ ██    ██  ██     ██ 
████████  ███████  ██    ██ ██     ██ ██     ██    ███    ████ ██     ██ 
]],
          },
          -- item field formatters
          formats = {
            icon = function(item)
              if item.file and item.icon == 'file' or item.icon == 'directory' then
                return M.icon(item.file, item.icon)
              end
              return { item.icon, width = 2, hl = 'icon' }
            end,
            footer = { '%s', align = 'center' },
            header = { '%s', align = 'center' },
            file = function(item, ctx)
              local fname = vim.fn.fnamemodify(item.file, ':~')
              fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
              if #fname > ctx.width then
                local dir = vim.fn.fnamemodify(fname, ':h')
                local file = vim.fn.fnamemodify(fname, ':t')
                if dir and file then
                  file = file:sub(-(ctx.width - #dir - 2))
                  fname = dir .. '/…' .. file
                end
              end
              local dir, file = fname:match '^(.*)/(.+)$'
              return dir and { { dir .. '/', hl = 'dir' }, { file, hl = 'file' } } or { { fname, hl = 'file' } }
            end,
          },
          sections = {
            { section = 'header' },
            { section = 'keys', gap = 1, padding = 1 },
            { section = 'startup' },
          },
        },
        explorer = { enabled = true },
        indent = { enabled = true },
        input = { enabled = false },
        notifier = {
          enabled = false,
          timeout = 3000,
        },
        picker = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = false },
        scroll = { enabled = false },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        styles = {
          notification = {
            -- wo = { wrap = true } -- Wrap notifications
          },
        },
      },
      keys = {
        -- Top Pickers & Explorer
        {
          '<leader>L',
          function()
            Snacks.dashboard.open()
          end,
          desc = 'Open Dashboard',
        },

        {
          '<leader>l',
          '<Cmd>Lazy<Cr>',
          desc = 'Open Lazy',
        },

        {
          '<leader><space>',
          function()
            Snacks.picker.files {
              hidden = true,
            }
          end,
          desc = 'Find Files',
        },
        {
          '<leader>z',
          function()
            Snacks.picker.zoxide()
          end,
          desc = 'Zoxide Picker',
        },
        {
          '<leader>,',
          function()
            Snacks.picker.buffers {
              -- on_show = function()
              --   vim.cmd.stopinsert()
              -- end,
              win = {
                input = {
                  keys = {
                    ['d'] = 'bufdelete',
                  },
                },
                list = { keys = { ['d'] = 'bufdelete' } },
              },
            }
          end,
          desc = 'Buffers',
        },
        {
          '<leader>/',
          function()
            Snacks.picker.grep {
              hidden = true,
            }
          end,
          desc = 'Grep',
        },
        {
          '<leader>:',
          function()
            Snacks.picker.command_history()
          end,
          desc = 'Command History',
        },
        {
          '<leader>n',
          function()
            Snacks.picker.notifications()
          end,
          desc = 'Notification History',
        },
        {
          '<leader>e',
          function()
            Snacks.explorer {
              -- layout = 'default',
            }
          end,
          desc = 'File Explorer',
        },
        -- find
        {
          '<leader>fb',
          function()
            Snacks.picker.buffers()
          end,
          desc = 'Buffers',
        },
        {
          '<leader>fc',
          '<Cmd>e ~/.config/lvim/init.lua<Cr>',
          { desc = 'Find Config File', silent = true },
        },
        {
          '<leader>fC',
          function()
            Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
          end,
          desc = 'Find Config File',
        },
        {
          '<leader>ff',
          function()
            Snacks.picker.files()
          end,
          desc = 'Find Files',
        },
        {
          '<leader>fg',
          function()
            Snacks.picker.git_files()
          end,
          desc = 'Find Git Files',
        },
        {
          '<leader>fp',
          function()
            Snacks.picker.projects()
          end,
          desc = 'Projects',
        },
        {
          '<leader>fr',
          function()
            Snacks.picker.recent()
          end,
          desc = 'Recent',
        },
        -- git
        {
          '<leader>gb',
          function()
            Snacks.picker.git_branches()
          end,
          desc = 'Git Branches',
        },
        {
          '<leader>gl',
          function()
            Snacks.picker.git_log()
          end,
          desc = 'Git Log',
        },
        {
          '<leader>gL',
          function()
            Snacks.picker.git_log_line()
          end,
          desc = 'Git Log Line',
        },
        {
          '<leader>gs',
          function()
            Snacks.picker.git_status()
          end,
          desc = 'Git Status',
        },
        {
          '<leader>gS',
          function()
            Snacks.picker.git_stash()
          end,
          desc = 'Git Stash',
        },
        {
          '<leader>gd',
          function()
            Snacks.picker.git_diff()
          end,
          desc = 'Git Diff (Hunks)',
        },
        {
          '<leader>gf',
          function()
            Snacks.picker.git_log_file()
          end,
          desc = 'Git Log File',
        },
        -- Grep
        {
          '<leader>sb',
          function()
            Snacks.picker.lines()
          end,
          desc = 'Buffer Lines',
        },
        {
          '<leader>sB',
          function()
            Snacks.picker.grep_buffers()
          end,
          desc = 'Grep Open Buffers',
        },
        {
          '<leader>sg',
          function()
            Snacks.picker.grep()
          end,
          desc = 'Grep',
        },
        {
          '<leader>sw',
          function()
            Snacks.picker.grep_word()
          end,
          desc = 'Visual selection or word',
          mode = { 'n', 'x' },
        },
        -- search
        {
          '<leader>s"',
          function()
            Snacks.picker.registers()
          end,
          desc = 'Registers',
        },
        {
          '<leader>s/',
          function()
            Snacks.picker.search_history()
          end,
          desc = 'Search History',
        },
        {
          '<leader>sa',
          function()
            Snacks.picker.autocmds()
          end,
          desc = 'Autocmds',
        },
        {
          '<leader>sb',
          function()
            Snacks.picker.lines()
          end,
          desc = 'Buffer Lines',
        },
        {
          '<leader>sc',
          function()
            Snacks.picker.command_history()
          end,
          desc = 'Command History',
        },
        {
          '<leader>sC',
          function()
            Snacks.picker.commands()
          end,
          desc = 'Commands',
        },
        {
          '<leader>sd',
          function()
            Snacks.picker.diagnostics()
          end,
          desc = 'Diagnostics',
        },
        {
          '<leader>sD',
          function()
            Snacks.picker.diagnostics_buffer()
          end,
          desc = 'Buffer Diagnostics',
        },
        {
          '<leader>sh',
          function()
            Snacks.picker.help()
          end,
          desc = 'Help Pages',
        },
        {
          '<leader>sH',
          function()
            Snacks.picker.highlights()
          end,
          desc = 'Highlights',
        },
        {
          '<leader>si',
          function()
            Snacks.picker.icons()
          end,
          desc = 'Icons',
        },
        {
          '<leader>sj',
          function()
            Snacks.picker.jumps()
          end,
          desc = 'Jumps',
        },
        {
          '<leader>sk',
          function()
            Snacks.picker.keymaps()
          end,
          desc = 'Keymaps',
        },
        {
          '<leader>sl',
          function()
            Snacks.picker.loclist()
          end,
          desc = 'Location List',
        },
        {
          '<leader>sm',
          function()
            Snacks.picker.marks()
          end,
          desc = 'Marks',
        },
        {
          '<leader>sM',
          function()
            Snacks.picker.man()
          end,
          desc = 'Man Pages',
        },
        {
          '<leader>sp',
          function()
            Snacks.picker.lazy()
          end,
          desc = 'Search for Plugin Spec',
        },
        {
          '<leader>sq',
          function()
            Snacks.picker.qflist()
          end,
          desc = 'Quickfix List',
        },
        {
          '<leader>sR',
          function()
            Snacks.picker.resume()
          end,
          desc = 'Resume',
        },
        {
          '<leader>su',
          function()
            Snacks.picker.undo()
          end,
          desc = 'Undo History',
        },
        {
          '<leader>uC',
          function()
            Snacks.picker.colorschemes()
          end,
          desc = 'Colorschemes',
        },
        -- LSP
        {
          'gd',
          function()
            Snacks.picker.lsp_definitions()
          end,
          desc = 'Goto Definition',
        },
        {
          'gD',
          function()
            Snacks.picker.lsp_declarations()
          end,
          desc = 'Goto Declaration',
        },
        {
          'gr',
          function()
            Snacks.picker.lsp_references()
          end,
          nowait = true,
          desc = 'References',
        },
        {
          'gI',
          function()
            Snacks.picker.lsp_implementations()
          end,
          desc = 'Goto Implementation',
        },
        {
          'gy',
          function()
            Snacks.picker.lsp_type_definitions()
          end,
          desc = 'Goto T[y]pe Definition',
        },
        {
          '<leader>ss',
          function()
            Snacks.picker.lsp_symbols()
          end,
          desc = 'LSP Symbols',
        },
        {
          '<leader>sS',
          function()
            Snacks.picker.lsp_workspace_symbols()
          end,
          desc = 'LSP Workspace Symbols',
        },
        -- Other
        {
          '<leader>uz',
          function()
            Snacks.zen()
          end,
          desc = 'Toggle Zen Mode',
        },
        {
          '<leader>uZ',
          function()
            Snacks.zen.zoom()
          end,
          desc = 'Toggle Zoom',
        },
        {
          '<leader>.',
          function()
            Snacks.scratch()
          end,
          desc = 'Toggle Scratch Buffer',
        },
        {
          '<leader>S',
          function()
            Snacks.scratch.select()
          end,
          desc = 'Select Scratch Buffer',
        },
        {
          '<leader>n',
          function()
            Snacks.notifier.show_history()
          end,
          desc = 'Notification History',
        },
        {
          '<leader>bd',
          function()
            Snacks.bufdelete()
          end,
          desc = 'Delete Buffer',
        },
        {
          '<leader>cR',
          function()
            Snacks.rename.rename_file()
          end,
          desc = 'Rename File',
        },
        {
          '<leader>gB',
          function()
            Snacks.gitbrowse()
          end,
          desc = 'Git Browse',
          mode = { 'n', 'v' },
        },
        {
          '<leader>gg',
          function()
            Snacks.lazygit()
          end,
          desc = 'Lazygit',
        },
        {
          '<leader>un',
          function()
            Snacks.notifier.hide()
          end,
          desc = 'Dismiss All Notifications',
        },
        {
          '<a-/>',
          function()
            Snacks.terminal 'zellij'
          end,
          desc = 'Toggle Terminal',
          mode = { 'n', 't' },
        },
        {
          '<c-_>',
          function()
            Snacks.terminal()
          end,
          desc = 'which_key_ignore',
        },
        {
          ']]',
          function()
            Snacks.words.jump(vim.v.count1)
          end,
          desc = 'Next Reference',
          mode = { 'n', 't' },
        },
        {
          '[[',
          function()
            Snacks.words.jump(-vim.v.count1)
          end,
          desc = 'Prev Reference',
          mode = { 'n', 't' },
        },
        {
          '<leader>N',
          desc = 'Neovim News',
          function()
            Snacks.win {
              file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
              width = 0.6,
              height = 0.6,
              wo = {
                spell = false,
                wrap = false,
                signcolumn = 'yes',
                statuscolumn = ' ',
                conceallevel = 3,
              },
            }
          end,
        },
      },
      init = function()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'VeryLazy',
          callback = function()
            -- Setup some globals for debugging (lazy-loaded)
            _G.dd = function(...)
              Snacks.debug.inspect(...)
            end
            _G.bt = function()
              Snacks.debug.backtrace()
            end
            vim.print = _G.dd -- Override print to use snacks for `:=` command
            -- Create some toggle mappings
            Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
            Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
            Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
            Snacks.toggle.diagnostics():map '<leader>ud'
            Snacks.toggle.line_number():map '<leader>ul'
            Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
            Snacks.toggle.treesitter():map '<leader>uT'
            Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
            Snacks.toggle.inlay_hints():map '<leader>uh'
            Snacks.toggle.indent():map '<leader>ug'
            Snacks.toggle.dim():map '<leader>uD'
          end,
        })
      end,
    },

    -- Themes
    {
      'sponkurtus2/angelic.nvim',
      lazy = false,
    },
    {
      'srt0/codescope.nvim',
      lazy = false,
    },
    {
      'catppuccin/nvim',
      name = 'catppuccin',
    },
    {
      'rebelot/kanagawa.nvim',
      name = 'kanagawa',
    },
    {
      'rose-pine/neovim',
    },
    {
      'shaunsingh/nord.nvim',
    },
    {
      'ellisonleao/gruvbox.nvim',
    },
    {
      'echasnovski/mini.base16',
      version = false,
    },

    -- -- Colorizer
    -- {
    --   'brenoprata10/nvim-highlight-colors',
    --   config = function()
    --     require('nvim-highlight-colors').setup {
    --       ---Render style
    --       ---@usage 'background'|'foreground'|'virtual'
    --       render = 'background',
    --       ---Set virtual symbol (requires render to be set to 'virtual')
    --       virtual_symbol = '■',
    --       ---Set virtual symbol suffix (defaults to '')
    --       virtual_symbol_prefix = '',
    --       ---Set virtual symbol suffix (defaults to ' ')
    --       virtual_symbol_suffix = ' ',
    --       ---Set virtual symbol position()
    --       ---@usage 'inline'|'eol'|'eow'
    --       ---inline mimics VS Code style
    --       ---eol stands for `end of column` - Recommended to set `virtual_symbol_suffix = ''` when used.
    --       ---eow stands for `end of word` - Recommended to set `virtual_symbol_prefix = ' ' and virtual_symbol_suffix = ''` when used.
    --       virtual_symbol_position = 'inline',
    --       ---Highlight hex colors, e.g. '#FFFFFF'
    --       enable_hex = true,
    --       ---Highlight short hex colors e.g. '#fff'
    --       enable_short_hex = true,
    --       ---Highlight rgb colors, e.g. 'rgb(0 0 0)'
    --       enable_rgb = true,
    --       ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
    --       enable_hsl = true,
    --       ---Highlight ansi colors, e.g '\033[0;34m'
    --       enable_ansi = true,
    --       -- Highlight hsl colors without function, e.g. '--foreground: 0 69% 69%;'
    --       enable_hsl_without_function = true,
    --       ---Highlight CSS variables, e.g. 'var(--testing-color)'
    --       enable_var_usage = true,
    --       ---Highlight named colors, e.g. 'green'
    --       enable_named_colors = true,
    --       ---Highlight tailwind colors, e.g. 'bg-blue-500'
    --       enable_tailwind = false,
    --       ---Set custom colors
    --       ---Label must be properly escaped with '%' to adhere to `string.gmatch`
    --       --- :help string.gmatch
    --       -- custom_colors = {
    --       --   { label = "%-%-theme%-primary%-color", color = "#0f1219" },
    --       --   { label = "%-%-theme%-secondary%-color", color = "#5a5d64" },
    --       -- },
    --       -- Exclude filetypes or buftypes from highlighting e.g. 'exclude_buftypes = {'text'}'
    --       exclude_filetypes = {},
    --       exclude_buftypes = {},
    --       -- Exclude buffer from highlighting e.g. 'exclude_buffer = function(bufnr) return vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr)) > 1000000 end'
    --       exclude_buffer = function(bufnr) end,
    --     }
    --     vim.keymap.set('n', '<leader>oca', function()
    --       require('nvim-highlight-colors').turnOn()
    --     end, { silent = true, desc = 'Colorizer Attach To Buffer' })
    --     vim.keymap.set('n', '<leader>oct', function()
    --       require('nvim-highlight-colors').toggle()
    --     end, { silent = true, desc = 'Colorizer Toggle' })
    --     vim.keymap.set('n', '<leader>ocr', function()
    --       require('nvim-highlight-colors').turnOff()
    --       require('nvim-highlight-colors').turnOn()
    --     end, { silent = true, desc = 'Colorizer Reload All Buffers' })
    --     vim.keymap.set('n', '<leader>ocd', function()
    --       require('nvim-highlight-colors').turnOff()
    --     end, { silent = true, desc = 'Colorizer Detach To Buffer' })
    --   end,
    -- },

    -- -- Markview
    -- {
    --   'OXY2DEV/markview.nvim',
    --   lazy = false,
    --   opts = {
    --     preview = {
    --       modes = { 'n', 'no', 'c' },
    --       hybrid_modes = { 'n' },
    --       linewise_hybrid_mode = true,
    --     },
    --     -- list_items
    --     markdown = {
    --       list_items = {
    --         enable = true,
    --         wrap = false,
    --         indent_size = 2,
    --         shift_width = 4,
    --         marker_minus = {
    --           add_padding = true,
    --           conceal_on_checkboxes = true,
    --           text = '',
    --           hl = 'MarkviewListItemMinus',
    --         },
    --         marker_plus = {
    --           add_padding = true,
    --           conceal_on_checkboxes = true,
    --           text = '',
    --           hl = 'MarkviewListItemPlus',
    --         },
    --         marker_star = {
    --           add_padding = true,
    --           conceal_on_checkboxes = true,
    --           text = '',
    --           hl = 'MarkviewListItemStar',
    --         },
    --         marker_dot = {
    --           add_padding = true,
    --           conceal_on_checkboxes = true,
    --         },
    --         marker_parenthesis = {
    --           add_padding = true,
    --           conceal_on_checkboxes = true,
    --         },
    --       },
    --     },
    --   },
    --   keys = {
    --     { '<leader>omm', '<Cmd>Markview Toggle<Cr>', { desc = 'Toggle Markview' } },
    --     { '<leader>omh', '<Cmd>Markview hybridToggle<Cr>', { desc = 'Toggle Hybrid Mode' } },
    --     { '<leader>omp', '<Cmd>Markview splitToggle<Cr>', { desc = 'Toggle Split View' } },
    --   },
    -- },

    --  Harpoon
    {
      'ThePrimeagen/harpoon',
      branch = 'harpoon2',
      opts = {
        menu = {
          width = vim.api.nvim_win_get_width(0) - 4,
        },
        settings = {
          save_on_toggle = true,
        },
      },
      keys = function()
        local keys = {
          {
            '<leader>h',
            function()
              require('harpoon'):list():add()
            end,
            desc = 'Harpoon File',
          },
          {
            '<leader><S-h>',
            function()
              local harpoon = require 'harpoon'
              harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            desc = 'Harpoon Quick Menu',
          },
        }
        for i = 1, 9 do
          table.insert(keys, {
            '<leader>' .. i,
            function()
              require('harpoon'):list():select(i)
            end,
            -- desc = 'Harpoon to File ' .. i,
            desc = 'which_key_ignore',
          })
          -- require('which-key').add {
          --   { '<leader>' .. i, hidden = true }, -- hide this keymap
          -- }
        end
        return keys
      end,
    },

    -- screenkey
    {
      'NStefan002/screenkey.nvim',
      lazy = false,
      version = '*', -- or branch = "main", to use the latest commit
      config = function()
        require('screenkey').setup {
          win_opts = {
            row = vim.o.lines - vim.o.cmdheight - 1,
            col = vim.o.columns - 1,
            relative = 'editor',
            anchor = 'SE',
            width = 40,
            height = 3,
            border = 'single',
            title = 'Screenkey',
            title_pos = 'center',
            style = 'minimal',
            focusable = true,
            noautocmd = true,
          },
          compress_after = 3,
          clear_after = 3,
          disable = {
            filetypes = {},
            buftypes = {},
            events = false,
          },
          show_leader = true,
          group_mappings = true,
          display_infront = {},
          display_behind = {},
          filter = function(keys)
            return keys
          end,
          -- separator = ' ',
          keys = {
            ['<TAB>'] = '󰌒',
            ['<CR>'] = '󰌑',
            ['<ESC>'] = 'Esc',
            ['<SPACE>'] = '␣',
            ['<BS>'] = '󰌥',
            ['<DEL>'] = 'Del',
            ['<LEFT>'] = '',
            ['<RIGHT>'] = '',
            ['<UP>'] = '',
            ['<DOWN>'] = '',
            ['<HOME>'] = 'Home',
            ['<END>'] = 'End',
            ['<PAGEUP>'] = 'PgUp',
            ['<PAGEDOWN>'] = 'PgDn',
            ['<INSERT>'] = 'Ins',
            ['<F1>'] = '󱊫',
            ['<F2>'] = '󱊬',
            ['<F3>'] = '󱊭',
            ['<F4>'] = '󱊮',
            ['<F5>'] = '󱊯',
            ['<F6>'] = '󱊰',
            ['<F7>'] = '󱊱',
            ['<F8>'] = '󱊲',
            ['<F9>'] = '󱊳',
            ['<F10>'] = '󱊴',
            ['<F11>'] = '󱊵',
            ['<F12>'] = '󱊶',
            ['CTRL'] = 'Ctrl',
            ['ALT'] = 'Alt',
            ['SUPER'] = '󰘳',
            ['<leader>'] = '<leader>',
          },
        }
      end,
    },

    -- snaks image
    {
      'folke/snacks.nvim',
      ---@type snacks.Config
      opts = {
        image = {
          -- your image configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        },
      },
    },

    -- img-clip
    {
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- add options here
        -- or leave it empty to use the default settings
        default = {
          -- file and directory options
          dir_path = 'assets', ---@type string | fun(): string
          use_absolute_path = false, ---@type boolean | fun(): boolean
        },
      },
      keys = {
        -- suggested keymap
        { '<leader>op', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
      },
    },

    -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
    -- init.lua. If you want these files, they are in the repository, so you can just download them and
    -- place them in the correct locations.

    -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
    --
    --  Here are some example plugins that I've included in the Kickstart repository.
    --  Uncomment any of the lines below to enable them (you will need to restart nvim).
    --
    -- require 'kickstart.plugins.debug',
    -- require 'kickstart.plugins.indent_line',
    -- require 'kickstart.plugins.lint',
    -- require 'kickstart.plugins.autopairs',
    -- require 'kickstart.plugins.neo-tree',
    -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

    -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    This is the easiest way to modularize your config.
    --
    --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    -- { import = 'custom.plugins' },
    -- { import = 'plugins' },
    --
    -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
    -- Or use telescope!
    -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
    -- you can continue same window with `<space>sr` which resumes last telescope search
  },
  -- lazy.nvim end setup
  {
    ui = {
      -- If you are using a Nerd Font: set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
  }
)
--
-- -- Neovide Font Resize
-- if vim.g.neovide then
--   vim.g.neovide_padding_top = 8
--   vim.g.neovide_padding_bottom = 8
--   vim.g.neovide_padding_right = 8
--   vim.g.neovide_padding_left = 8
--   FontSize = 12
--   function SetFontSize(amount)
--     FontSize = FontSize + amount
--     vim.o.guifont = 'JetbrainsmonoNL NF:h' .. FontSize
--     -- print('Font Size: ' .. FontSize)
--   end
--
--   SetFontSize(0)
--   vim.keymap.set('n', '<C-=>', function()
--     SetFontSize(1)
--   end, { desc = 'Increase Font Size in neovide', silent = true })
--   vim.keymap.set('n', '<C-->', function()
--     SetFontSize(-1)
--   end, { desc = 'Decrease Font Size in neovide', silent = true })
--   vim.keymap.set('n', '<C-0>', function()
--     FontSize = 12
--     vim.o.guifont = 'JetbrainsmonoNL NF:h' .. FontSize
--     print('Font Size: ' .. FontSize)
--   end, { desc = 'Restore Font Size in neovide', silent = true })
-- end
--
-- -- Statusline
-- vim.o.updatetime = 50
--
-- local modes = {
--   ['n'] = 'NORMAL',
--   ['no'] = 'NORMAL',
--   ['v'] = 'VISUAL',
--   ['V'] = 'VISUAL LINE',
--   [''] = 'VISUAL BLOCK',
--   ['s'] = 'SELECT',
--   ['S'] = 'SELECT LINE',
--   [''] = 'SELECT BLOCK',
--   ['i'] = 'INSERT',
--   ['ic'] = 'INSERT',
--   ['R'] = 'REPLACE',
--   ['Rv'] = 'VISUAL REPLACE',
--   ['c'] = 'COMMAND',
--   ['cv'] = 'VIM EX',
--   ['ce'] = 'EX',
--   ['r'] = 'PROMPT',
--   ['rm'] = 'MOAR',
--   ['r?'] = 'CONFIRM',
--   ['!'] = 'SHELL',
--   ['t'] = 'TERMINAL',
-- }
-- local function mode()
--   local current_mode = vim.api.nvim_get_mode().mode
--   return string.format('%s', modes[current_mode]):upper()
-- end
-- local function update_mode_colors()
--   local current_mode = vim.api.nvim_get_mode().mode
--   local mode_color = '%#StatusLineAccent#'
--   if current_mode == 'n' then
--     mode_color = '%#MiniStatuslineModeNormal#'
--     -- mode_color = '%#StatuslineAccent#'
--   elseif current_mode == 'i' or current_mode == 'ic' then
--     mode_color = '%#MiniStatuslineModeInsert#'
--     -- mode_color = '%#StatuslineInsertAccent#'
--   elseif current_mode == 'v' or current_mode == 'V' or current_mode == '' then
--     mode_color = '%#MiniStatuslineModeVisual#'
--     -- mode_color = '%#StatuslineVisualAccent#'
--   elseif current_mode == 'R' then
--     mode_color = '%#MiniStatuslineModeReplace#'
--     -- mode_color = '%#StatuslineReplaceAccent#'
--   elseif current_mode == 'c' then
--     mode_color = '%#MiniStatuslineModeCommand#'
--     -- mode_color = '%#StatuslineCmdLineAccent#'
--   elseif current_mode == 't' then
--     mode_color = '%#MiniStatuslineModeOther#'
--     -- mode_color = '%#StatuslineTerminalAccent#'
--   end
--   return mode_color
-- end
-- local function filepath()
--   local fpath = vim.fn.fnamemodify(vim.fn.expand '%', ':~:.:h')
--   if fpath == '' or fpath == '.' then
--     return ' '
--   end
--   return string.format(' %%<%s/', fpath)
-- end
-- local function filename()
--   local fname = vim.fn.expand '%:t'
--   if fname == '' then
--     return ''
--   end
--   return fname .. ' '
-- end
--
-- local function lsp()
--   local count = {}
--   local levels = {
--     errors = 'Error',
--     warnings = 'Warn',
--     info = 'Info',
--     hints = 'Hint',
--   }
--
--   for k, level in pairs(levels) do
--     count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
--   end
--
--   local errors = ''
--   local warnings = ''
--   local hints = ''
--   local info = ''
--
--   if count['errors'] ~= 0 then
--     errors = '  ' .. count['errors']
--     -- errors = ' %#LspDiagnosticsSignError# ' .. count['errors']
--   end
--   if count['warnings'] ~= 0 then
--     warnings = '  ' .. count['warnings']
--     -- warnings = ' %#LspDiagnosticsSignWarning# ' .. count['warnings']
--   end
--   if count['hints'] ~= 0 then
--     hints = '  ' .. count['hints']
--     -- hints = ' %#LspDiagnosticsSignHint# ' .. count['hints']
--   end
--   if count['info'] ~= 0 then
--     info = '  ' .. count['info']
--     -- info = ' %#LspDiagnosticsSignInformation# ' .. count['info']
--   end
--
--   return errors .. warnings .. hints .. info .. '%#Normal#'
-- end
-- local function filetype()
--   return string.format(' %s', vim.bo.filetype):upper()
-- end
-- local function lineinfo()
--   if vim.bo.filetype == 'alpha' then
--     return ''
--   end
--   return ' %P %l:%c '
-- end
-- local function git()
--   local git_info = vim.b.gitsigns_status_dict
--   if not git_info or git_info.head == '' then
--     return ''
--   end
--   local added = git_info.added and ('󰐙 ' .. git_info.added .. ' ') or ''
--   -- local added = git_info.added and ('+' .. git_info.added .. ' ') or ''
--   -- local added = git_info.added and ('%#GitSignsAdd#+' .. git_info.added .. ' ') or ''
--   local changed = git_info.changed and ('󰝶 ' .. git_info.changed .. ' ') or ''
--   -- local changed = git_info.changed and ('~' .. git_info.changed .. ' ') or ''
--   -- local changed = git_info.changed and ('%#GitSignsChange#~' .. git_info.changed .. ' ') or ''
--   local removed = git_info.removed and ('󰍷 ' .. git_info.removed .. ' ') or ''
--   -- local removed = git_info.removed and ('-' .. git_info.removed .. ' ') or ''
--   -- local removed = git_info.removed and ('%#GitSignsDelete#-' .. git_info.removed .. ' ') or ''
--   if git_info.added == 0 then
--     added = ''
--   end
--   if git_info.changed == 0 then
--     changed = ''
--   end
--   if git_info.removed == 0 then
--     removed = ''
--   end
--   return table.concat {
--     ' ',
--     added,
--     changed,
--     removed,
--     -- '%#GitSignsAdd# ',
--     ' ',
--     git_info.head,
--     '%#Normal#',
--   }
-- end
--
-- vim.o.laststatus = 3
--
-- local function Winbar()
--   local normal_color = '%#Normal#'
--   local mode = '%-5{%v:lua.string.upper(v:lua.vim.fn.mode())%}'
--   local file_name = '%-.16t'
--   local buf_nr = '[%n]'
--   local modified = ' %-m'
--   local file_type = ' %y'
--   local right_align = '%='
--   local line_no = '%10([%l/%L%)]'
--   local pct_thru_file = '%5p%%'
--   return string.format('%s%s%s', normal_color, file_name, modified)
-- end
-- vim.opt.winbar = Winbar()
--
-- Statusline = {}
--
-- -- '%#Statusline#',
-- Statusline.active = function()
--   return table.concat {
--     -- ' %#Normal# ',
--     update_mode_colors(),
--     ' ',
--     mode(),
--     ' %#Normal# ',
--     filepath(),
--     filename(),
--     '%m',
--     '%=%#StatusLineExtra#',
--     '%#Normal#',
--     git(),
--     lsp(),
--     filetype(),
--     lineinfo(),
--   }
-- end
-- vim.api.nvim_exec(
--   [[
--   augroup Statusline
--   au!
--   au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
--   au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
--   au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline.short()
--   augroup END
-- ]],
--   false
-- )
-- function Statusline.inactive()
--   return '%#Normal#%f'
-- end
--
-- function Statusline.short()
--   return '%#StatusLineNC#   NvimTree'
-- end
--

---------------
-- OBSIDIAN ---
---------------
-- Obsidian Daily Note
vim.keymap.set('n', '<leader>ood', function()
  local current_date = os.date '%Y-%m-%d'
  local daily_note_date = '~/Notes/DailyNotes/' .. current_date .. '.md'
  vim.cmd('e ' .. daily_note_date)
end, { desc = 'Daily Note' })

vim.keymap.set('n', '<leader>ooc', function()
  local current_date_and_time = os.date '%Y-%m-%d %H:%M:%S'
  local commit_date = 'vault backup: ' .. current_date_and_time
  vim.cmd('!git add ~/Notes && git commit -m "' .. commit_date .. '"')
  print('Commit: ' .. commit_date)
end, { desc = 'Commit All Changes' })

vim.keymap.set('n', '<leader>oop', function()
  vim.cmd '!git push'
  print 'Push Changes'
end, { desc = 'Push Changes' })

-- Minimal Search
local function GrepSearch()
  local input = vim.fn.input 'Grep for > '
  if input == '' then
    return
  end

  local cmd = string.format("grep -rnI --exclude-dir=.git --exclude-dir=node_modules --color=never '%s' .", input)

  local tmp = vim.fn.tempname()
  vim.fn.system(cmd .. ' > ' .. vim.fn.fnameescape(tmp))

  vim.cmd('cfile ' .. tmp)
  vim.cmd 'copen'
  os.remove(tmp)
end

vim.api.nvim_create_user_command('Grep', GrepSearch, {})

vim.keymap.set('n', '<space>o/', ':Grep<CR>', { noremap = true, silent = true, desc = 'Grep (Quickfix)' })

function FzfLike()
  -- 1. Coletar arquivos
  local handle = io.popen "find . -type f -not -path '*/.git/*'"
  if not handle then
    vim.notify("Erro ao executar 'find'", vim.log.levels.ERROR)
    return
  end

  local files = {}
  for file in handle:lines() do
    table.insert(files, file)
  end
  handle:close()

  -- 2. Entrada para filtro
  vim.ui.input({ prompt = 'Find for > ' }, function(input)
    if not input then
      return
    end
    input = input:lower()

    local filtered = {}
    for _, file in ipairs(files) do
      if file:lower():find(input, 1, true) then
        table.insert(filtered, file)
      end
    end

    local count = #filtered

    if count == 0 then
      vim.notify('No File Found.', vim.log.levels.INFO)
      return
    end

    -- 3. Adicionar ao quickfix list
    local qf_entries = {}
    for _, file in ipairs(filtered) do
      table.insert(qf_entries, { filename = file, lnum = 1, col = 1, text = file })
    end
    vim.fn.setqflist({}, ' ', {
      title = 'FzfLike Results',
      items = qf_entries,
    })

    -- 4. Abrir automaticamente se só tiver um arquivo
    if count == 1 then
      vim.cmd('edit ' .. filtered[1])
    else
      -- 5. Mostrar quickfix list
      vim.cmd 'copen'
    end
  end)
end
vim.keymap.set('n', '<space>of', FzfLike, { desc = 'Fuzzy Find (Quickfix)' })

vim.keymap.set('n', '<leader>G', ':Git<Cr>')

vim.cmd 'let g:netrw_banner = 0'
--
