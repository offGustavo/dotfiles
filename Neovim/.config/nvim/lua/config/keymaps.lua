-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.keymap.set({ "n", "v" }, "n", "nzz", { silent = true, desc = "Next Search Result" })
-- vim.keymap.set("n", "N", "Nzz", { silent = true, desc = "Previous Search Result" })
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, desc = "Half Scroll Down and Center" })
-- vim.keymap.set("n", "<C-u>", "<c-u>zz", { silent = true, desc = "Half Scroll Up and Center" })
vim.keymap.set("v", ">", ">gv", { silent = true, desc = "Better Indent" })
vim.keymap.set("v", "<", "<gv", { silent = true, desc = "Better Indent" })
vim.keymap.set("n", "gJ", "kJ_", { silent = true, desc = "Join Line Above" })
vim.keymap.set("n", "J", "J_", { silent = true, desc = "Better Join Line" })

-- Del LazyVim Keymaps
vim.keymap.set({ "x", "n" }, "<Left>", "<Left>")
vim.keymap.set({ "x", "n" }, "<Up>", "<Up>")
vim.keymap.set({ "x", "n" }, "<Down>", "<Down>")
vim.keymap.set({ "x", "n" }, "<Right>", "<Right>")

-----------------
--- DASHBOARD ---
-----------------
vim.keymap.set("n", "<leader>od", function()
  Snacks.dashboard()
end, { silent = true, desc = "Open Dashboard" })

----------------
--- TERMINAL ---
----------------
---- Normal Mode to Terminal
---- Remap default C-/ Lazyvim
-- vim.keymap.set({ "n", "t", "i", "v" }, "<c-/>", function()
--   Snacks.terminal("zellij")
-- end, { silent = true, desc = "Open Float Terminal" })

-- vim.keymap.set({ "n", "t", "i", "v" }, "<leader>tf", function()
--   Snacks.terminal("zellij")
-- end, { silent = true, desc = "Open Float  Terminal" })

vim.keymap.set("n", "<leader>tn", "<Cmd>terminal<Cr>", { silent = true, desc = "New Buffer Terminal" })
vim.keymap.set("n", "<leader>tv", "<Cmd>vertical terminal<CR>", { silent = true, desc = "Vertical Terminal" })
vim.keymap.set("n", "<leader>ts", "<Cmd>horizontal terminal<CR>", { silent = true, desc = "Horizontal Terminal" })

---- Terminal Mode to Normal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true, desc = "Go To Normal Mode in Terminal" })

---- Move in windows on Terminal Mode
-- vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h")
-- vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j")
-- vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k")
-- vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l")

-- Move Window
vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- resize window
vim.keymap.set("n", "<C-A-h>", "<C-w><", { desc = "Move window to the left" })
vim.keymap.set("n", "<C-A-l>", "<C-w>>", { desc = "Move window to the right" })
vim.keymap.set("n", "<C-A-k>", "<C-w>-", { desc = "Move window to the upper" })
vim.keymap.set("n", "<C-A-j>", "<C-w>+", { desc = "Move window to the lower" })
-- Close Window
vim.keymap.set("n", "<leader>wc", "<Cmd>close<Cr>")

-- Toggle Comment
-- vim.keymap.set("n", "<C-/>", ":normal gcc<Cr>", { desc = "Toggle Comment", silent = true })
-- vim.keymap.set("v", "<C-/>", ":'<,'>normal gcc<Cr>", { desc = "Toggle Comment", silent = true })

-- Move Lines Up/Down
-- vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move Line Up" })
-- vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move Line Down" })

-- -- Emacs Keybinds in Insert Mode
-- -- set this better
-- vim.keymap.set({ "i", "c" }, "<C-p>", "<Up>", { silent = true })
-- vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { silent = true })
-- vim.keymap.set({ "i", "c" }, "<C-n>", "<Down>", { silent = true })
-- vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>", { silent = true })
-- vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>", { silent = true })
-- vim.keymap.set({ "i", "c" }, "<C-e>", "<End>", { silent = true })
-- vim.keymap.set({ "i", "c" }, "<A-b>", "<C-Left>", { silent = true })
-- vim.keymap.set({ "i", "c" }, "<A-f>", "<C-Right>", { silent = true })
-- vim.keymap.set("i", "<A-d>", "<C-o>dw", { silent = true })
-- vim.keymap.set({ "i", "c" }, "<C-d>", "<Del>", { silent = true })
-- vim.keymap.set("i", "<C-k>", "<Esc>lDa", { silent = true })
-- vim.keymap.set("i", "<C-u>", "<Esc>d0xi", { silent = true })
-- vim.keymap.set("i", "<A-}>", "<C-o>}", { silent = true })
-- vim.keymap.set("i", "<A-{>", "<C-o>{", { silent = true })
-- vim.keymap.set("i", "<A-a>", "<C-o>(", { silent = true })
-- vim.keymap.set("i", "<A-e>", "<C-o>)", { silent = true })
-- vim.keymap.set("i", "<A-<>", "<C-o>gg", { silent = true })
-- vim.keymap.set("i", "<A->>", "<C-o>G", { silent = true })
-- vim.keymap.set("i", "<C-/>", "<C-o>u", { silent = true })
-- vim.keymap.set("i", "<C-x><C-s>", "<C-o>:w<CR>", { silent = true })
-- vim.keymap.set("i", "<C-x><C-c>", "<Esc>:wq<CR>", { silent = true })
-- -- vim.keymap.set("i", "<C-t>", "<Esc>Xpa", { silent = true })
-- -- vim.keymap.set("i", "<C-]>", "<C-t>", { silent = true })
-- vim.keymap.set("n", "<A-x>", ":", { desc = "Emacs" })
-- vim.keymap.set("i", "<A-x>", "<C-o>:", { desc = "Emacs" })
-- vim.keymap.set("t", "<A-x>", "<C-\\><C-o>:", { desc = "Emacs" })

-- -- Emacs Keybinds in Command Mode
-- vim.keymap.set({ "c" }, "<C-p>", "<Up>")
-- vim.keymap.set({ "c" }, "<C-n>", "<Down>")
-- vim.keymap.set({ "c" }, "<C-a>", "<Home>")
-- vim.keymap.set({ "c" }, "<C-f>", "<Right>")
-- vim.keymap.set({ "c" }, "<C-b>", "<Left>")
-- vim.keymap.set({ "c" }, "<C-e>", "<End>")
-- vim.keymap.set({ "c" }, "<A-b>", "<S-Left>")
-- vim.keymap.set({ "c" }, "<A-f>", "<S-Right>")

-- -- Normal mode in command line
-- vim.keymap.set("c", "<C-o>", "<C-f>")

-- Visual Keymaps - Markdown Text
vim.keymap.set(
  "v",
  "<C-i>",
  ":<Del><Del><Del><Del><Del>norm saiw*<Cr>gv",
  { silent = true, desc = "Add Italic/Bold(*)" }
)
vim.keymap.set(
  "v",
  "<C-b>",
  ":<Del><Del><Del><Del><Del>norm sd*<Cr>gv",
  { silent = true, desc = "Remove Italic/Bold(*)" }
)

-- -- Buffer Movement
-- vim.keymap.set("n", "<C-w>p", vim.cmd.bp, { silent = false, desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bp", vim.cmd.bp, { silent = false, desc = "Next Buffer" })
-- vim.keymap.set("n", "<leader>bp", vim.cmd.bp, { silent = false, desc = "Next Buffer" })
-- vim.keymap.set("n", "<C-w>n", vim.cmd.bn, { silent = false, desc = "Previous Buffer" })
-- vim.keymap.set("n", "<leader>wn", vim.cmd.bn, { silent = false, desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>bn", vim.cmd.bn, { silent = false, desc = "Previous Buffer" })

-- Copy Entire Buffer
vim.keymap.set("n", "gA", "<Cmd>%y<Cr>", { silent = true, desc = "Yank entire file" })

-- Normal mode in command line
-- vim.keymap.set("n", "<leader>;", ":<c-f>", { silent = true, desc = "Vi Command Mode" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

---------------
--- LazyVim ---
---------------
vim.keymap.del("n", "<leader>l")
vim.keymap.set("n", "<leader>lz", ":Lazy<Cr>", { desc = "Lazy", silent = true })
vim.keymap.set("n", "<leader>lx", ":LazyExtras<Cr>", { desc = "LazyVim Extras", silent = true })

-------------
--- Mason ---
-------------
vim.keymap.set("n", "<leader>lm", ":Mason<Cr>", { desc = "Mason", silent = true })

---------------
--- LocList ---
---------------
vim.keymap.set("n", "<leader>ll", ":lwindow<Cr>", { desc = "Location List", silent = true })
vim.keymap.set("n", "<leader>lp", ":lprev<Cr>", { desc = "Location List", silent = true })
vim.keymap.set("n", "<leader>ln", ":lnext<Cr>", { desc = "Location List", silent = true })
vim.keymap.set("n", "<leader>la", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local item = {
    bufnr = vim.api.nvim_get_current_buf(),
    lnum = pos[1],
    col = pos[2] + 1,
    text = vim.fn.getline("."),
  }
  vim.fn.setloclist(0, { item }, "a") -- "a" = append
  vim.notify("Adicionado à Location List")
end, { desc = "Adicionar item à Location List" })

vim.keymap.set("n", "<leader>lr", function()
  vim.fn.setloclist(0, {}, "r") -- "r" = replace (aqui com vazio)
  vim.notify("Location List resetada")
end, { desc = "Resetar Location List" })

----------------
--- Quickfix ---
----------------
vim.keymap.set("n", "<leader>qf", vim.diagnostic.setqflist, { silent = true, desc = "Open Diagnostic Quickfix List" })
vim.keymap.set("n", "<leader>qn", "<Cmd>cnext<Cr>", { silent = true, desc = "Open Next in Quickfix List" })
vim.keymap.set("n", "<leader>qp", "<Cmd>cprev<Cr>", { silent = true, desc = "Open Previous in Quickfix List" })
vim.keymap.set("n", "<leader>qo", "<Cmd>copen<Cr>", { silent = true, desc = "Open Quickfix List" })
vim.keymap.set("n", "<leader>qc", "<Cmd>cclose<Cr>", { silent = true, desc = "Close Quickfix List" })
vim.keymap.set("n", "<leader>qd", function()
  vim.diagnostic.setqflist()
end, { desc = "Open diagnostic Quickfix list" })

------------
--- Quit ---
------------
vim.keymap.set("n", "<leader>qq", ":q<cr>", { silent = true, desc = "Quit" })
vim.keymap.set("n", "<leader>qQ", ":qa!<cr>", { silent = true, desc = "Quit All" })
vim.keymap.set("n", "<leader>qr", vim.cmd.restart, { desc = "Restart Vim" })

--- ThePrimeagen Keymaps
vim.keymap.set("i", "<C-c>", "<Esc>")

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
vim.keymap.set("x", "<leader>p", '"_dP', { silent = true, desc = "Paste Without Copy" })
vim.keymap.set("n", "<leader>fx", ":!chmod +x %<Cr>", { silent = true, desc = "Make File Executable" })

-- File
vim.keymap.set("n", "<leader>fX", "<Cmd>!%<Cr>", { silent = true, desc = "Execute File" })
vim.keymap.set("n", "<leader>fs", "<Cmd>source %<Cr>", { silent = true, desc = "Source File" })

-- https://www.youtube.com/watch?v=UE6XQTAxwE0
vim.keymap.set("n", "<leader>fl", ":.lua<Cr>", { silent = true, desc = "Execute Line in Lua" })
vim.keymap.set("v", "<leader>fl", ":'<,'>lua<Cr>", { silent = true, desc = "Execute Selection in Lua" })

vim.keymap.set("n", "gf", ":e <cfile><Cr>", { silent = true, desc = "Better gf" })

-- Remove Lazyvim default keymap
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

-- Toggle Options
Snacks.toggle
  .new({
    id = "toggle_sing_and_line_column",
    name = "Relative Line Number and Sign Column",
    get = function()
      return vim.o.relativenumber
    end,
    set = function(state)
      if state then
        vim.o.signcolumn = "no"
        vim.opt.number = false
        vim.opt.relativenumber = false
      end
      vim.o.signcolumn = "yes"
      vim.opt.number = state
      vim.opt.relativenumber = state
    end,
  })
  :map("<leader>on")

Snacks.toggle.option("cursorline", { off = false, on = true }):map("<leader>ol")

--------------------
---- TABBY/TABS ----
--------------------
vim.keymap.set("n", "<leader><Tab>{", "<Cmd>-tabmove<Cr>", { desc = "Move Tab Left" })
vim.keymap.set("n", "<leader><Tab>}", "<Cmd>+tabmove<Cr>", { desc = "Move Tab Right" })
vim.keymap.set("n", "<leader><Tab>p", "<Cmd>Tabby pick_window<Cr>", { desc = "Pick Windows" })
vim.keymap.set("n", "<leader><Tab>r", ":TabRename ", { desc = "Rename Tab" })

vim.keymap.set("n", "<leader>t{", "<Cmd>-tabmove<Cr>", { desc = "Move Tab Left" })
vim.keymap.set("n", "<leader>t}", "<Cmd>+tabmove<Cr>", { desc = "Move Tab Right" })
vim.keymap.set("n", "<leader>tp", "<Cmd>Tabby pick_window<Cr>", { desc = "Pick Windows" })
vim.keymap.set("n", "<leader>tr", ":TabRename ", { desc = "Rename Tab" })
vim.keymap.set("n", "<leader>tL", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader>tF", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader>tt", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader>t]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader>t[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
vim.keymap.set("n", "]<Tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "[<Tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

for i = 1, 9, 1 do
  vim.keymap.set("n", "<leader>t" .. i, "<Cmd>norm" .. i .. "gt<Cr>", { desc = "which_key_ignore" })
  vim.keymap.set("n", "<leader><tab>" .. i, "<Cmd>norm" .. i .. "gt<Cr>", { desc = "which_key_ignore" })
end

---------------
-- OBSIDIAN ---
---------------
vim.keymap.set("n", "<leader>ood", function()
  local current_date = os.date("%Y-%m-%d")
  local daily_note_date = "~/Notes/DailyNotes/" .. current_date .. ".md"
  vim.cmd("e " .. daily_note_date)
end, { desc = "Daily Note" })

vim.keymap.set("n", "<leader>ooc", function()
  local current_date_and_time = os.date("%Y-%m-%d %H:%M:%S")
  local commit_date = "vault backup: " .. current_date_and_time
  vim.cmd('!git add ~/Notes && git commit -m "' .. commit_date .. '"')
  print("Commit: " .. commit_date)
end, { desc = "Commit All Changes" })

vim.keymap.set("n", "<leader>gp", function()
  vim.cmd("!git pull")
  print("Pull Changes")
end, { desc = "Pull Changes" })

vim.keymap.set("n", "<leader>gP", function()
  vim.cmd("!git push")
  print("Push Changes")
end, { desc = "Push Changes" })

vim.keymap.set("v", "<leader>oof", ':! tr -s " " | column -t -s "|" -o "|"<Cr>', { desc = "Format Table in Markdown" })

vim.keymap.set("v", "<leader>a", ":AlignRegexp<CR>", { desc = "Align by regex", silent = true })

vim.keymap.set("v", "<leader>a", function()
  -- Pede o separador ao usuário
  local sep = vim.fn.input("Separador: ")
  if sep == "" then
    sep = "|" -- padrão
  end

  -- Pega início e fim da seleção visual
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local end_line = end_pos[2]

  -- Captura o texto selecionado
  local lines = vim.fn.getline(start_line, end_line)
  local input_text = table.concat(lines, "\n")

  -- Executa o comando column
  local cmd = string.format('tr -s " " | column -t -s "%s" -o "%s"', sep, sep)
  local handle = io.popen(cmd, "w")
  if not handle then
    vim.notify("Erro ao executar comando column", vim.log.levels.ERROR)
    return
  end

  -- Envia o texto para o processo
  handle:write(input_text)
  handle:close()

  -- Lê o resultado processado
  local output = io.popen(cmd, "r")
  if not output then
    vim.notify("Erro ao ler saída do comando", vim.log.levels.ERROR)
    return
  end

  local result = output:read("*a")
  output:close()

  -- Divide o resultado em linhas
  local new_lines = vim.split(vim.trim(result), "\n")

  -- Substitui o conteúdo no buffer
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, new_lines)

  vim.notify("Texto alinhado com separador '" .. sep .. "'", vim.log.levels.INFO)
end, { desc = "Align text using column command", silent = true })

-----------------------------
---  REMAP DEFAULT PICKER ---
-----------------------------

---------------
--- Lazygit ---
---------------
vim.keymap.set("n", "<leader>lg", function()
  Snacks.lazygit({ cwd = LazyVim.root.git() })
  vim.keymap.set("t", "<Esc><Esc>", "<Esc><Esc>", { buffer = 0 })
  vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = 0 })
end, { desc = "Lazygit (cwd)" })
vim.keymap.set("n", "<A-p>g", function()
  Snacks.lazygit({ cwd = LazyVim.root.git() })
  vim.keymap.set("t", "<Esc><Esc>", "<Esc><Esc>", { buffer = 0 })
  vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = 0 })
end, { desc = "Lazygit (cwd)" })
vim.keymap.set("n", "<leader>gG", function()
  Snacks.lazygit({ cwd = LazyVim.root.git() })
  vim.keymap.set("t", "<Esc><Esc>", "<Esc><Esc>", { buffer = 0 })
  vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = 0 })
end, { desc = "Lazygit (cwd)" })

vim.keymap.set("n", "<S-Esc>", function()
  Snacks.explorer({
    hidden = true,
  })
end, { silent = true, desc = "Toggle File Tree" })

vim.keymap.set("n", "<leader>fa", function()
  Snacks.picker()
end, { desc = "All Snacks Pickers" })

vim.keymap.set("n", "<leader>z", function()
  Snacks.picker.zoxide()
end, { desc = "Snacks Picker Zoxide" })

vim.keymap.set("n", "<leader><space>", function()
  Snacks.picker.smart({
    -- finder = "explorer",
    -- tree = true,
    hidden = true,
    matcher = {
      frequency = true,
    },
    win = {
      input = {
        keys = {
          ["d"] = "bufdelete",
          ["J"] = "preview_scroll_down",
          ["K"] = "preview_scroll_up",
          ["H"] = "preview_scroll_left",
          ["L"] = "preview_scroll_right",
          ["<BS>"] = "explorer_up",
          ["l"] = "confirm",
          ["h"] = "explorer_close", -- close directory
          ["a"] = "explorer_add",
          ["D"] = "explorer_del",
          ["r"] = "explorer_rename",
          ["c"] = "explorer_copy",
          ["m"] = "explorer_move",
          ["o"] = "explorer_open", -- open with system application
          ["P"] = "toggle_preview",
          ["y"] = { "explorer_yank", mode = { "n", "x" } },
          ["p"] = "explorer_paste",
          ["u"] = "explorer_update",
          ["<c-c>"] = "tcd",
          ["<leader>/"] = "picker_grep",
          ["<c-t>"] = "terminal",
          ["."] = "explorer_focus",
          ["I"] = "toggle_ignored",
          -- ["H"] = "toggle_hidden",
          -- ["Z"] = "explorer_close_all",
          ["]g"] = "explorer_git_next",
          ["[g"] = "explorer_git_prev",
          ["]d"] = "explorer_diagnostic_next",
          ["[d"] = "explorer_diagnostic_prev",
          ["]w"] = "explorer_warn_next",
          ["[w"] = "explorer_warn_prev",
          ["]e"] = "explorer_error_next",
          ["[e"] = "explorer_error_prev",
        },
      },
      list = {
        keys = {
          ["d"] = "bufdelete",
          ["J"] = "preview_scroll_down",
          ["K"] = "preview_scroll_up",
          ["H"] = "preview_scroll_left",
          ["L"] = "preview_scroll_right",
        },
      },
    },
  })
end, { desc = "Snacks Smart Picker" })

vim.keymap.set("n", "<leader>/", function()
  Snacks.picker.grep({
    hidden = true,
  })
end, { desc = "Snacks Picker Grep" })

vim.keymap.set("n", "<leader>sP", function()
  Snacks.picker.grep({
    hidden = true,
    cwd = vim.fn.stdpath("config"),
  })
end, { desc = "Snacks Picker Grep in Config Files" })

-- vim.keymap.set("n", "<leader>ow", function()
--   Snacks.picker.grep({
--     hidden = true,
--     on_show = function()
--     vim.api.nvim_feedkeys(
--       vim.api.nvim_replace_termcodes("<C-r><C-a>", true, false, true),
--       "i",
--       true
--     )
--     end,
--   })
-- end, { desc = "Grep cWord (root)" })
-- vim.keymap.set("n", "<leader>oW", function()
--   Snacks.picker.grep({
--     hidden = true,
--     cwd = ".",
--     on_show = function()
--     vim.api.nvim_feedkeys(
--       vim.api.nvim_replace_termcodes("<C-r><C-a>", true, false, true),
--       "i",
--       true
--     )
--     end,
--   })
-- end, { desc = "Grep cWord (cwd)" })

vim.keymap.set({ "n", "i" }, "<leader>,", function()
  Snacks.picker.buffers({
    -- I always want my buffers picker to start in normal mode
    -- on_show = function()
    --   vim.cmd.stopinsert()
    -- end,
    finder = "buffers",
    format = "buffer",
    hidden = false,
    unloaded = true,
    current = true,
    sort_lastused = true,
    win = {
      input = {
        keys = {
          ["d"] = "bufdelete",
        },
      },
      list = { keys = { ["d"] = "bufdelete" } },
    },
    -- In case you want to override the layout for this keymap
    -- layout = "ivy",
  })
end, { silent = true, desc = "Snacks Picker Buffers" })

-------------------------------------
----- CUSTOM SEARCH FILES AND WORD --
-------------------------------------
---local function GrepSearch()
---  local input = vim.fn.input("Grep for > ")
---  if input == "" then
---    return
---  end
---  local cmd = string.format("grep -rnI --exclude-dir=.git --exclude-dir=node_modules --color=never '%s' .", input)
---  local tmp = vim.fn.tempname()
---  vim.fn.system(cmd .. " > " .. vim.fn.fnameescape(tmp))
---  vim.cmd("cfile " .. tmp)
---  vim.cmd("copen")
---  os.remove(tmp)
---end
---vim.api.nvim_create_user_command("Grep", GrepSearch, {})
---vim.keymap.set("n", "<leader>o/", ":Grep<CR>", { noremap = true, silent = true, desc = "Grep (Quickfix)" })

-- function FzfLike()
--   local handle = io.popen("find . -type f -not -path '*/.git/*'")
--   if not handle then
--     vim.notify("Erro ao executar 'find'", vim.log.levels.ERROR)
--     return
--   end
--   local files = {}
--   for file in handle:lines() do
--     table.insert(files, file)
--   end
--   handle:close()
--   vim.ui.input({ prompt = "Find for > " }, function(input)
--     if not input then
--       return
--     end
--     input = input:lower()
--     local filtered = {}
--     for _, file in ipairs(files) do
--       if file:lower():find(input, 1, true) then
--         table.insert(filtered, file)
--       end
--     end
--     local count = #filtered
--     if count == 0 then
--       vim.notify("No File Found.", vim.log.levels.INFO)
--       return
--     end
--     local qf_entries = {}
--     for _, file in ipairs(filtered) do
--       table.insert(qf_entries, { filename = file, lnum = 1, col = 1, text = file })
--     end
--     vim.fn.setqflist({}, " ", {
--       title = "FzfLike Results",
--       items = qf_entries,
--     })
--     if count == 1 then
--       vim.cmd("edit " .. filtered[1])
--     else
--       vim.cmd("edit " .. filtered[1])
--       vim.cmd("copen")
--     end
--   end)
-- end
-- vim.keymap.set("n", "<leader>of", FzfLike, { desc = "Fuzzy Find (Quickfix)" })

vim.keymap.set("n", "<leader>of", ":find ", { desc = "Find" })
vim.keymap.set("n", "<leader>og", ":grep ", { desc = "Grep" })

----------
-- Make --
----------
vim.keymap.set("n", "<leader>cm", ":make ", { desc = "Make", remap = true })
vim.keymap.set("n", "<leader>cM", "<Cmd>make<CR>", { desc = "Run Make" })
