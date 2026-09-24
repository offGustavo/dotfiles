-- vim: foldmethod=marker

-- {{{ Nvim

-- -- basic keymaps for nvim (if lazy fails for some reason)
-- vim.cmd([[
-- nmap <m-o> :fin<space>
-- nmap <m-s> :grep<space>
-- nmap <m-b> :b<space>
-- nmap <m-e> :ex<cr>
-- nmap <leader>vc :e $MYVIMRC<cr>
-- ]])

-- vim.keymap.del("n", "gd")
-- vim.keymap.del("n", "K")

-- vim.cmd([[
-- nmap <nowait> gd gd
-- nmap <nowait> gr gr
-- nmap <nowait> gD gD
-- nmap <nowait> K K
-- ]])

map {
  -- Marks
  { "n", "dm", "<Cmd>exe 'delmarks ' . getcharstr()<Enter>", desc = "Del mark <char>" },

  -- Edit init.lua/init.vim/vimrc
  { "n", "<leader>fC", ":e $MYVIMRC<Cr>", silent = true, desc = "Edit the init config file" },

  { "n", "<leader>vf", ":cd %:h<Cr>" },

  -- Fix <C-c> to work like <Esc>
  { "i", "<C-c>", "<Esc>" },

  --- Better Go to file
  { "n", "gf", ":e <cfile><Cr>", silent = true, desc = "Better gf" },

  { "x", "<", "<gv", silent = true, desc = "Better Indent" },
  { "x", ">", ">gv", silent = true, desc = "Better Indent" },

  -- Align use mini-indent
  { "x", "<leader>f", ':! tr -s " " | column -t -s "|" -o "|"<Cr>', desc = "Format Table in Markdown" },
  {
    "x",
    "<leader>a",
    function()
      require("fish.align").align_regexp()
    end,
    desc = "Align by regex",
    silent = true,
  },

  -- Better gX(go to file externally)
  {
    "n",
    "gX",
    function()
      local file = vim.fn.expand("%:p")
      if file ~= "" then
        vim.ui.open(file)
      else
        vim.notify("no file to open", vim.log.levels.WARN)
      end
    end,
    silent = true,
    desc = "Open current file",
  },

  -- {{{ Better walking between wrap lines
  -- Use <Down> and <Up> to get the default behavior
  { "n", "j", "gj", silent = true },
  { "n", "k", "gk", silent = true },
  --- }}}

  -- Comment Line/Selection
  { "n", { "C-_", "<C-/>" }, "gcc", silent = true },
  { "i", { "C-_", "<C-/>" }, " <C-o>gcc", silent = true },
  { "x", { "C-_", "<C-/>" }, " :norm gcc<Cr>", silent = true },

  --- Scroll
  { "<S-ScrollWheelUp>", "zh" },
  { "<S-ScrollWheelDown>", "zl" },

  -- Normal mode in command line
  -- vim.keymap.set("n", "<leader>;", ":<c-f>", { silent = true, desc = "Vi Command Mode" })

  -- Restart neovim without a sesions
  {
    "n",
    { "Zr", "<leader>qr" },
    function()
      vim.cmd("restart!")
    end,
    desc = "Restart Without Session",
    silent = true,
  },
  -- vim.keymap.set("n", "Zr", function()
  --   vim.cmd("restart!")
  -- end, { desc = "Restart Without Session", silent = true }) -- ZR for buitin restart

  -- File
  { "n", "<leader>fn", ":enew<Cr>", silent = true, desc = "New File" },

  -- Undotree
  {
    "n",
    "U",
    function()
      vim.cmd("packadd nvim.undotree")
      require("undotree").open()
    end,
    silent = true,
  },

  --- }}}

  -- {{{ Clipboard
  { { "n", "x" }, "<C-S-v>", '"+p' },
  { "i", "<C-V>", "<C-r>+" },
  { { "n", "x" }, "<C-C>", '"+y' },
  { { "n", "x" }, "<C-X>", '"+d' },
  { { "n", "x" }, "<S-Insert>", '"+p' },
  { "i", "<S-Insert>", "<C-r>+" },
  { { "n", "x" }, "<C-Insert>", '"+y' },
  { { "n", "x" }, "<S-Del>", '"+d' },
  { { "n", "x" }, "<leader>+", '"+', desc = "System clipboard" },
  { { "n", "x" }, "<leader>_", '"_', desc = "Black Hole Register" },
  { { "n", "x" }, "<leader>p", '"+p', desc = "Paste from system register" },
  { { "n", "x" }, "<leader>y", '"+y', desc = "Yank to system register" },
  { { "n", "x" }, "<leader>d", '"+d', desc = "Cut to system register" },
  -- }}}

  -- {{{ Buffer
  { "<leader>ba", ":b #<Cr>", desc = "Alternative Buffer" },
  { "<leader>bd", ":bd<Cr>", desc = "Delete Buffer" },
  { "<leader>bD", ":bufdo bd<Cr>", desc = "Delete All Buffers" },
  -- }}}

  -- {{{ Substitute
  -- ThePrimeagen Keymaps
  { { "x", "n" }, "s.", [[:s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], silent = false },
  { { "x", "n" }, "S>", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], silent = false },
  { { "x", "n" }, "sg", ":%s/", silent = false },
  { { "x", "n" }, "SG", ":%s//gI<Left><Left><Left>", silent = false },
  { { "x", "n" }, "ss", ":s/", silent = false },
  { { "x", "n" }, "SS", [[:s//gI<Left><Left><Left>]], silent = false },
  { "n", "SV", [[S<Esc>]], silent = false },
  { "x", "SV", [[:normal S<Esc>]], silent = true },

  -- {{{ Insert/Command Mode
  { "i", "<C-Bs>", "<C-w>" },

  -- }}}

  -- Emacs Binds
  { "n", "<C-Down>", "}", noremap = true, silent = true },
  { "n", "<C-Up>", "{", noremap = true, silent = true },
  { "i", "<M-S-.>", "<C-o>G", noremap = true, silent = true },
  { "i", "<M-S-,>", "<C-o>gg", noremap = true, silent = true },
  { { "n", "x" }, "<M-S-.>", "G", noremap = true, silent = true },
  { { "n", "x" }, "<M-S-,>", "gg", noremap = true, silent = true },
  { { "n", "x" }, "<M-x>", ":", silent = false },

  { "i", "<C-a>", "<home>" },
  { "i", "<C-e>", "<end>" },
  { "i", "<C-f>", "<right>" },
  { "i", "<C-b>", "<left>" },
  { "i", "<M-f>", "<C-right>" },
  { "i", "<M-b>", "<C-left>" },
  { "i", "<C-d>", "<del>" },
  { "i", "<C-o>", "<C-f>" },

  -- " " Emacs shit
  -- nmap <M-x> :
  -- imap <M-x> <C-o>:

  { "i", "<Tab>", "<C-t>" },
  { "i", "<S-Tab>", "<C-d>" },

  { "i", "<C-a>", " <home>" },
  { "i", "<C-e>", " <end>" },
  { "i", "<C-f>", " <right>" },
  { "i", "<C-b>", " <left>" },
  { "i", "<M-f>", " <C-right>" },
  { "i", "<M-b>", " <C-left>" },
  { "i", "<C-d>", " <del>" },
  { "i", "<M-d>", " <C-o>de" },

  -- " nmap <C-á> ^
  -- " nmap <C-é> $
  -- " imap <C-á> <Home>
  -- " imap <C-é> <End>

  --- }}}

  -- {{{ Copy/Move
  { "<M-d>", ":t.<cr>", silent = true, desc = "Duplicate line" },
  { "<M-j>", ":m +1<CR>==", silent = true, desc = "Move line down" },
  { "<M-k>", ":m -2<CR>==", silent = true, desc = "Move line up" },
  { "<M-j>", ":m '>+1<CR>gv=gv", silent = true, desc = "Move line down" },
  { "<M-k>", ":m '<-2<CR>gv=gv", silent = true, desc = "Move line up" },
  -- }}}

  -- {{{ Lines
  {
    { "n", "x", "i" },
    "<M-S-l>",
    function()
      local mode = vim.fn.mode()
      if mode == "i" then
        -- print(mode)
        return "<Esc>V"
      elseif mode == "n" then
        -- print(mode)
        return "V"
      elseif mode == "V" or mode == "v" or mode == "x" then
        -- print(mode)
        return "j0"
      end
      -- print("other" .. mode)
    end,
    desc = "Sel Line (emacs)",
    expr = true,
    silent = true,
  },
  {
    { "n", "x", "i" },
    "<M-S-h>",
    function()
      local mode = vim.fn.mode()
      if mode == "i" then
        return "<Esc>vap"
      elseif mode == "n" then
        return "vap"
      elseif mode == "V" or mode == "v" or mode == "x" then
        return "ap"
      end
    end,
    desc = "Sel Paragraph(emacs)",
    expr = true,
    silent = true,
  },
  -- }}}

  -- {{{ Terminal
  { { "i", "c", "n", "v", "x" }, "<C-c>", "<Esc>", desc = "Fix <C-c>", silent = true },
  { { "i", "t" }, "<M-;>", "<C-\\><C-n>", silent = true, desc = "Go To Normal Mode in Terminal", nowait = true },
  { "t", "<S-Esc>", "<C-\\><C-n>", silent = true, desc = "Go To Normal Mode in Terminal", nowait = true },
  -- { 't', '<Esc><Esc>', '<C-\\><C-n>',  silent = true, desc = 'Go To Normal Mode in Terminal', nowait = true },
  { "n", "<M-t>", ":term " },
  { "n", "<leader>tn", ":term " },
  { "n", "<leader>th", ":hor term " },
  { "n", "<leader>tv", ":vert term " },
  { "n", "<leader>tg", ":hor term rg " },
  --- }}}

  -- {{{ Tabs
  -- :tcd shortcut
  { "n", "<leader><Tab>z", ":tcd ", desc = "Tab Cd" },

  {
    "n",
    "<leader><Tab><Tab>",
    function()
      local count = vim.v.count
      if count > 0 then
        vim.cmd("norm " .. count .. "gt")
        return
      end
      vim.cmd.tabnew()
    end,
    desc = "New Tab",
  },

  -- {{{ Tabs
  { "n", "<leader><Tab>c", "<cmd>tabclose<cr>", desc = "Close Tab" },
  { "n", "<leader><Tab>o", "<cmd>tabonly<cr>", desc = "Close Other Tabs" },

  { "n", "]<S-Tab>", "<cmd>tablast<cr>", desc = "Last Tab" },
  { "n", "[<S-Tab>", "<cmd>tabfirst<cr>", desc = "First Tab" },

  { "n", "]<Tab>", "<cmd>tabnext<cr>", desc = "Next Tab" },
  { "n", "[<Tab>", "<cmd>tabprevious<cr>", desc = "Previous Tab" },

  { "n", "<C-S-PageUp>", "<cmd>tabmove -1<cr>" },
  { "n", "<C-S-PageDown>", "<cmd>tabmove +1<cr>" },
  -- }}}
}

---}}}

-- -- {{{ Fold
-- vim.keymap.set("n", "<leader>im", "O-- {{{<Esc>", { desc = "Insert fold open marker" })
-- vim.keymap.set("n", "<leader>iM", "o-- }}}<Esc>", { desc = "Insert fold close marker" })
-- vim.keymap.set("x", "<leader>im", function()
--   vim.cmd("'<normal O-- {{{")
--   vim.cmd("'>normal o-- }}}")
-- end, { desc = "Insert fold markers around selection" })
-- }}}

-- {{{ Windows
-- Move between windows, saving and restoring the mode each window was left in.
-- Supports: normal (n), insert (i), terminal (t), visual treated as normal on re-entry.
--
-- Design:
--   Fish.windows._modes  table[winid -> mode_string]
--     Stores the mode string at the moment we LEAVE a window.
--
-- On cycle:
--   1. Record current mode for current win.
--   2. Leave to a neutral state (stop insert / stop terminal-job so wincmd works).
--   3. Execute wincmd w / W.
--   4. Restore the saved mode of the new window (if any).
Fish.windows = {}

---Saved modes keyed by window handle.
---@type table<integer, string>
Fish.windows._modes = {}

---Normalise nvim_get_mode().mode to one of: "n", "i", "t"
---Visual modes are collapsed to "n" because selections are buffer-local and
---meaningless once the cursor leaves the window.
---@param raw_mode string
---@return "n"|"i"|"t"
local function normalise_mode(raw_mode)
  if raw_mode == "i" or raw_mode == "ic" or raw_mode == "ix" then
    return "i"
  elseif raw_mode == "t" then
    return "t"
  else
    -- n, v, V, ^V, R, c, … → treat as normal on re-entry
    return "n"
  end
end

---Exit whatever mode we are in so that wincmd can fire safely.
---Returns the normalised mode we were in before bailing out.
---@return "n"|"i"|"t"
local function leave_current_mode()
  local raw = vim.api.nvim_get_mode().mode
  local mode = normalise_mode(raw)

  if mode == "i" then
    -- :stopinsert without moving the cursor
    vim.cmd("stopinsert")
  elseif mode == "t" then
    -- Send <C-\><C-n> to leave terminal-job mode → terminal-normal
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
  end
  -- visual / normal: already safe for wincmd
  return mode
end

---Restore a previously saved mode in the *current* window.
---@param mode "n"|"i"|"t"
local function restore_mode(mode)
  if mode == "i" then
    vim.cmd("startinsert")
  elseif mode == "t" then
    -- Only meaningful if the current buffer is a terminal
    local buftype = vim.bo.buftype
    if buftype == "terminal" then
      vim.cmd("startinsert") -- re-enters terminal-job mode from terminal-normal
    end
  end
  -- "n" → nothing to do, already in normal mode after wincmd
end

---Move between windows keeping the mode each window was left in.
---@param forward boolean  true = next window (wincmd w), false = prev (wincmd W)
function Fish.windows.cycle(forward)
  local from_win = vim.api.nvim_get_current_win()

  -- 1. Record + leave current mode
  local mode = leave_current_mode()
  Fish.windows._modes[from_win] = mode

  -- 2. Move to adjacent window
  --    wincmd must run in normal/terminal-normal, which leave_current_mode ensures.
  if forward then
    vim.cmd.wincmd("w")
  else
    vim.cmd.wincmd("W")
  end

  -- 3. Restore the saved mode of the window we just entered (if we have one)
  local to_win = vim.api.nvim_get_current_win()
  if to_win ~= from_win then
    local saved = Fish.windows._modes[to_win]
    if saved then
      -- Schedule so the window switch has fully settled before mode changes
      vim.schedule(function()
        restore_mode(saved)
      end)
    end
  end
end

-- -- Clean up stale entries when a window is closed (avoids phantom state)
-- vim.api.nvim_create_autocmd("WinClosed", {
--   group = vim.api.nvim_create_augroup("FishWindowMode", { clear = true }),
--   callback = function(ev)
--     -- ev.match is the window id as a string
--     local winid = tonumber(ev.match)
--     if winid then
--       Fish.windows._modes[winid] = nil
--     end
--   end,
-- })

map {
  {
    { "x", "n", "i", "t" },
    "<M-S-j>",
    function()
      Fish.windows.cycle(true)
    end,
    desc = "Cycle to next window (keep mode)",
  },
  {
    { "x", "n", "i", "t" },
    "<M-S-k>",
    function()
      Fish.windows.cycle(false)
    end,
    desc = "Cycle to prev window (keep mode)",
  },
  -- { {  "x", "n", "i", "t" }, "<M-S-j>", function() vim.cmd.wincmd("w") end, desc = "Move to next window" },
  -- { {  "x", "n", "i", "t" }, "<M-S-k>", function() vim.cmd.wincmd("W") end, desc = "Move to next window" },
  {
    { "x", "n", "i", "t" },
    "<M-S-s>",
    function()
      vim.cmd.wincmd("s")
    end,
    desc = "Split Vertical",
  },
  {
    { "x", "n", "i", "t" },
    "<M-S-v>",
    function()
      vim.cmd.wincmd("v")
    end,
    desc = "Split Horizontally",
  },
  {
    { "x", "n", "i", "t" },
    "<M-S-o>",
    function()
      vim.cmd.wincmd("o")
    end,
    desc = "Make Only Window",
  },
  {
    "n",
    "<M-=>",
    function()
      vim.cmd.wincmd("=")
    end,
    desc = "Windows",
  },
  {
    "n",
    "<M-+>",
    function()
      vim.cmd.wincmd("+")
    end,
    desc = "Windows",
  },
  {
    "n",
    "<M-->",
    function()
      vim.cmd.wincmd("-")
    end,
    desc = "Windows",
  },
  {
    "n",
    "<M-,>",
    function()
      vim.cmd.wincmd("<")
    end,
    desc = "Windows",
  },
  {
    "n",
    "<M-.>",
    function()
      vim.cmd.wincmd(">")
    end,
    desc = "Windows",
  },
}

Fish.windows = {
  hydra_mode = {
    _active = false,
    keys = {
      { "=", "=", "Equaly? window height" },
      { "+", "+", "Increase window height" },
      { "-", "-", "Decrease window height" },
      { "<", "<", "Increase window height" },
      { ">", ">", "Increase window height" },
      { "s", "s", "Increase window height" },
      { "v", "v", "Increase window height" },
      { "o", "o", "Increase window height" },
      { "w", "w", "Increase window height" },
    },
    exit = {
      "<Esc>",
      "<C-c>",
      "<C-g>",
    },
  },
}

local function hydra_keymap()
  if Fish.windows.hydra_mode._active then
    -- TODO: better logs
    vim.notify("active", vim.log.levels.WARN)
    return
  end

  Fish.windows.hydra_mode._active = true
  vim.notify("activate", vim.log.levels.WARN)

  for i, key in pairs(Fish.windows.hydra_mode.keys) do
    vim.keymap.set("n", key[1], function()
      vim.cmd.wincmd(key[2])
    end, { desc = key[3], nowait = true })
  end
  -- exit submode
  vim.keymap.set("n", "<Esc>", function()
    Fish.windows.hydra_win_mode = false
    for i, key in pairs(Fish.windows.hydra_mode.keys) do
      pcall(vim.keymap.del, "n", key[1])
    end
    for i, key in pairs(Fish.windows.hydra_mode.exit) do
      pcall(vim.keymap.del, "n", key[1])
    end
    vim.notify("Exit window submode", vim.log.levels.INFO)
  end)
end

-- vim.keymap.set("n", "<M-R>", hydra_keymap)
-- vim.keymap.set("n", "<leader>w.", hydra_keymap)
-- vim.keymap.set("n", "<C-w>m.", hydra_keymap)

-- Zoom
map {
  {
    "n",
    {
      "<c-w>m",
      "<leader>uz",
    },
    function()
      require("fish.zoom").zoom()
    end,
    desc = "Toggle pane/window zoom",
  },

  --- }}}

  -- {{{ LocList
  { "n", "<leader>ll", ":lwindow<Cr>", desc = "Location List", silent = true },
  { "n", "<leader>lp", ":lprev<Cr>", desc = "Location List", silent = true },
  { "n", "<leader>ln", ":lnext<Cr>", desc = "Location List", silent = true },
  {
    "n",
    "<leader>la",
    function()
      local pos = vim.api.nvim_win_get_cursor(0)
      local item = {
        bufnr = vim.api.nvim_get_current_buf(),
        lnum = pos[1],
        col = pos[2] + 1,
        text = vim.fn.getline("."),
      }
      vim.fn.setloclist(0, { item }, "a") -- "a" = append
      vim.notify("Adicionado à Location List")
    end,
    desc = "Adicionar item à Location List",
  },

  {
    "n",
    "<leader>lr",
    function()
      vim.fn.setloclist(0, {}, "r") -- "r" = replace (aqui com vazio)
      vim.notify("Location List resetada")
    end,
    desc = "Resetar Location List",
  },
  --- }}}

  -- {{{ Quickfix
  { "n", "<leader>qn", "<Cmd>cnext<Cr>", silent = true, desc = "Open Next in Quickfix List" },
  { "n", "<leader>qp", "<Cmd>cprev<Cr>", silent = true, desc = "Open Previous in Quickfix List" },

  -- vim.keymap.set("n", "<leader>qo", vim.cmd.copen, { desc = "QuickFix Open", silent = true })
  -- vim.keymap.set("n", "<leader>qc", vim.cmd.cclose, { desc = "QuickFix Close", silent = true })

  { "n", "<leader>qo", "<Cmd>copen<Cr>", silent = true, desc = "Open Quickfix List" },
  { "n", "<leader>qc", "<Cmd>cclose<Cr>", silent = true, desc = "Close Quickfix List" },
  { "n", "<leader>qh", "<Cmd>chistory<Cr>", silent = true, desc = "List Quick Fix History" },
  { "n", "<leader>qn", "<Cmd>cnewer<Cr>", silent = true, desc = "Next Quickfix List" },
  { "n", "<leader>qp", "<Cmd>colder<Cr>", silent = true, desc = "Previous Quickfix List" },
  {
    "n",
    "<leader>q{i}",
    "<Cmd>chistory {i}<Cr>",
    range = { 1, 9 },
    silent = true,
    desc = "Go to {i} Quickfix",
  },
  -- }}}

  -- {{{ Obsidian
  {
    "n",
    "<leader>ad",
    function()
      local current_date = os.date("%Y-%m-%d")
      local daily_note_date = "~/Notes/DailyNotes/" .. current_date .. ".md"
      vim.cmd("e " .. daily_note_date)
    end,
    desc = "Today's Daily Note",
  },

  -- TODO: change this keymaps
  {
    "n",
    "<leader>ag",
    function()
      local current_date_and_time = os.date("%Y-%m-%d %H:%M:%S")
      local commit_date = "vault backup: " .. current_date_and_time
      vim.cmd('!git add ~/Notes && git commit -m "' .. commit_date .. '"')
      print("Commit: " .. commit_date)
    end,
    desc = "Commit All Changes From Vault",
  },

  --- }}}

  -- {{{ Make
  { "n", "<leader>cm", ":make ", desc = "Make", remap = true },
  { "n", "<leader>cM", "<Cmd>make<CR>", desc = "Run Make" },
  -- }}}

  -- {{{ Toggle
  -- Smart increase/decrease
  {
    "n",
    "<C-a>",
    function()
      require("fish.toggle").increase()
    end,
    desc = "Inrease numbers and words",
  },
  {
    "n",
    "<C-x>",
    function()
      require("fish.toggle").decrease()
    end,
    desc = "Inrease numbers and words",
  },

  -- vim.keymap.set("n", "<leader>tt", function()
  --   require("fish.toggle").toggle()
  -- end, { desc = "Toggle Value" })

  {
    "n",
    "<leader>uc",
    function()
      if vim.opt.conceallevel:get() == 3 then
        vim.o.conceallevel = 0
        return
      end
      vim.o.conceallevel = 3
    end,
    desc = "set conceallevel!",
  },

  {
    "n",
    "<leader>ul",
    function()
      vim.o.cursorline = not vim.opt.cursorline:get()
    end,
    desc = "set cursorline!",
  },

  {
    "n",
    "<leader>un",
    function()
      vim.o.number = not vim.opt.number:get()
    end,
    desc = "set number!",
  },

  {
    "n",
    "<leader>ur",
    function()
      vim.o.relativenumber = not vim.opt.relativenumber:get()
    end,
    desc = "set relativenumber!",
  },

  {
    "n",
    "<leader>uw",
    function()
      vim.o.wrap = not vim.opt.wrap:get()
    end,
    desc = "set wrap!",
  },

  {
    "n",
    "<leader>us",
    function()
      vim.o.spell = not vim.opt.spell:get()
    end,
    desc = "set spell!",
  },

  {
    "n",
    "<leader>ub",
    function()
      if vim.opt.background:get() == "light" then
        vim.o.background = "dark"
        return
      end
      vim.o.background = "light"
    end,
    desc = "set bg!",
  },

  {
    "n",
    "<leader>ud",
    function()
      if vim.diagnostic.is_enabled() then
        vim.diagnostic.enable(false)
        return
      end
      vim.diagnostic.enable(true)
    end,
    desc = "set vim.diagnostic.enable()!",
  },

  {
    "n",
    "<leader>ut",
    function()
      local state = vim.b.ts_highlight
      if state then
        vim.treesitter.stop(0)
        return
      end
      vim.treesitter.start(0)
    end,
    desc = "set vim.treesitter()!",
  },

  {
    "n",
    "<leader>uT",
    function()
      local buf = vim.api.nvim_get_current_buf()
      vim.lsp.semantic_tokens.enable(not vim.lsp.semantic_tokens.is_enabled({ bufnr = buf }), { bufnr = buf })
    end,
    desc = "Toggle LSP semantic tokens",
  },

  {
    "n",
    "<leader>u<C-t>",
    function()
      local state = vim.b.ts_highlight
      local buf = vim.api.nvim_get_current_buf()

      if state then
        vim.treesitter.stop(0)
        vim.lsp.semantic_tokens.enable(false, { bufnf = buf })
        return
      end
      vim.treesitter.start(0)
      vim.lsp.semantic_tokens.enable(true, { bufnf = buf })
    end,
    desc = "Toggle LSP and Treesitter Highlight",
  },

  {
    "n",
    "<leader>uf",
    function()
      local fmd = { "expr", "indent", "marker" }
      local length = #fmd
      local current = vim.opt.foldmethod:get()
      local new
      local vim_count = vim.v.count

      if vim_count > 0 then
        new = fmd[vim_count]
        vim.o.foldmethod = new
        vim.notify("Current: " .. new, vim.log.levels.INFO)
        return
      end

      for i = 1, length do
        if fmd[i] == current then
          -- wrap around if index goes out of range
          if i == length then
            new = fmd[1]
          else
            new = fmd[i + 1]
          end
        end
      end

      vim.o.foldmethod = new
      vim.notify("Current: " .. new, vim.log.levels.INFO)
    end,
    desc = "set foldmethod!",
  },

  {
    "n",
    "<leader>ui",
    function()
      vim.o.list = not vim.opt.list:get()
    end,
    desc = "set list!",
  },

  {
    "n",
    "<leader>uS",
    function()
      vim.o.laststatus = vim.opt.laststatus:get() == 3 and 2 or 3
    end,
    desc = "set laststatus!",
  },
  -- }}}

  -- {{{ Log
  {
    "<leader>lf",
    function()
      vim.notify("current foldmethod: " .. vim.opt.foldmethod:get(), vim.log.levels.INFO)
    end,
  },
  --- }}}

  -- {{{ Zoxide
  -- Keybinds using vim.ui.select
  {
    "n",
    "<leader>z",
    function()
      require("fish.zoxide").zoxide_select("Zoxide (cd):", "cd", true)
    end,
    desc = "Zoxide picker (cd)",
  },

  {
    "n",
    "<leader>Z",
    function()
      require("fish.zoxide").zoxide_select("Zoxide (tcd):", "tcd", true)
    end,
    desc = "Zoxide picker(tcb)",
  },
  -- }}}

  -- {{{ Git
  {
    "<leader>gP",
    function()
      vim.cmd("!git pull")
    end,
    desc = "Pull Changes",
  },
  {
    "<leader>gp",
    function()
      vim.cmd("!git push")
    end,
    desc = "Push Changes",
  },
  {
    "<leader>ga",
    function()
      vim.cmd("!git add %")
    end,
    desc = "Git add current file",
  },
  {
    "<leader>gA",
    function()
      vim.cmd("!git add .")
    end,
    desc = "Git add current directory",
  },
  -- }}}

  --   -- {{{ Argall
  --   {
  --     "<leader>hl",
  --     function()
  --       require("fish.argall").load()
  --     end,
  --     desc = "Load args session",
  --   },
  --   {
  --     "<leader>he",
  --     function()
  --       require("fish.argall").show()
  --     end,
  --     desc = "Show args in tmp buffer",
  --   },
  --   {
  --     "<leader>ha",
  --     function()
  --       require("fish.argall").add(vim.fn.expand("%"))
  --     end,
  --     desc = "Add arg file",
  --   },
  --   {
  --     "<leader>hd",
  --     function()
  --       vim.cmd "argd %"
  --     end,
  --     desc = "Remove arg file",
  --   },
  --   { "n", "<leader>{i}", "<CMD>argu {i}<CR>", silent = true, range = { 1, 9 }, desc = "Go to arg {i}" },
  --   { "n", "<leader>h{i}", "<CMD>{i-1}arga<CR>", silent = true, range = { 1, 9 }, desc = "Add current to arg {i}" },
  --   { "n", "<leader>hd{i}", "<CMD>{i}argd<CR>", silent = true, range = { 1, 9 }, desc = "Delete arg {i}" },
  -- }}}
}

-- FIXME: try to fix this
-- vim.keymap.set("c", "w!!", "w !sudo tee > /dev/null %", { silent = true, desc = "Write as Sudo" })
