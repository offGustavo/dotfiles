vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require("snacks").setup({
  bigfile = { enabled = true },
  dashboard = { enabled = false },
  explorer = { enabled = false },
  image = { enabled = true },
  indent = { enabled = true },
  input = { enabled = false },
  notifier = {
    enabled = true,
    timeout = 2000,
  },
  picker = { enabled = false },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  animate = {
    duration = 5, -- ms per step
    easing = 'linear',
    fps = 120,    -- frames per second. Global setting for all animations
  },
  styles = {
    notification = {
      -- wo = { wrap = true } -- Wrap notifications
    },
  },
})

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
Snacks.toggle.option('cursorline', { off = false, on = true }):map '<leader>ol'
Snacks.toggle.animate():map '<leader>ua'

local snacks_keys = {
  {
    '<leader><space>',
    function()
      Snacks.picker.smart {
        hidden = true,
        matcher = {
          frequency = true,
        },
        win = {
          input = {
            keys = {
              ['d'] = 'bufdelete',
              ['J'] = 'preview_scroll_down',
              ['K'] = 'preview_scroll_up',
              ['H'] = 'preview_scroll_left',
              ['L'] = 'preview_scroll_right',
            },
          },
          list = {
            keys = {
              ['d'] = 'bufdelete',
              ['J'] = 'preview_scroll_down',
              ['K'] = 'preview_scroll_up',
              ['H'] = 'preview_scroll_left',
              ['L'] = 'preview_scroll_right',
            },
          },
        },
      }
    end,
    desc = 'which_key_ignore',
  },
  {
    '<leader>,',
    function()
      Snacks.picker.buffers()
    end,
    desc = 'which_key_ignore',
  },
  {
    '<leader>/',
    function()
      Snacks.picker.grep()
    end,
    desc = 'which_key_ignore',
  },
  {
    '<leader>fe',
    function()
      Snacks.explorer()
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
    '<leader>z',
    function()
      Snacks.picker.zoxide()
    end,
    desc = 'which_key_ignore',
  },
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
    '<leader>gG',
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
    '<c-/>',
    function()
      Snacks.terminal()
    end,
    desc = 'Toggle Terminal',
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
}



--- Registra keymaps a partir de uma tabela estruturada
--- @param maps table Lista de keymaps
local function set_keymaps(maps)
  for _, map in ipairs(maps) do
    -- valores obrigatórios
    local mode, lhs, rhs

    -- Caso o primeiro campo seja uma string (ex: "<leader>f")
    -- ou uma função/comando, significa que o "mode" não foi declarado
    if type(map[1]) == "string" and (type(map[2]) == "string" or type(map[2]) == "function") then
      mode = "n"
      lhs = map[1]
      rhs = map[2]
    else
      -- Se o primeiro campo for "n" ou {"n", "v"}
      mode = map[1] or "n"
      lhs = map[2]
      rhs = map[3]
    end

    if type(lhs) ~= "string" then
      vim.notify("Keymap inválido: lhs deve ser string", vim.log.levels.ERROR)
      goto continue
    end

    if not (type(rhs) == "string" or type(rhs) == "function") then
      vim.notify("Keymap inválido: rhs deve ser string ou function", vim.log.levels.ERROR)
      goto continue
    end

    -- monta opções extras (desc, silent, buffer, nowait, etc.)
    local opts = {}
    for k, v in pairs(map) do
      if type(k) == "string" then
        if k ~= "mode" then
          opts[k] = v
        end
      end
    end

    vim.keymap.set(mode, lhs, rhs, opts)

    ::continue::
  end
end

set_keymaps(snacks_keys)
