-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "v" }, "n", "nzz", { silent = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "Nzz", { silent = true, desc = "Previous Search Result" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, desc = "Half Scroll Down and Center" })
vim.keymap.set("n", "<C-u>", "<c-u>zz", { silent = true, desc = "Half Scroll Up and Center" })
vim.keymap.set("n", ">", ">gv", { silent = true, desc = "Better Indent" })
vim.keymap.set("n", "<", "<gv", { silent = true, desc = "Better Indent" })
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
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l")

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
vim.keymap.set("n", "<C-/>", ":normal gcc<cr>", { desc = "Toggle Comment", silent = true })
vim.keymap.set("v", "<C-/>", ":normal gc<cr>", { desc = "Toggle Comment", silent = true })

-- Move Lines Up/Down
vim.keymap.set("v", "<S-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move Line Up" })
vim.keymap.set("v", "<S-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move Line Down" })

-- Emacs Keybinds in Insert Mode
-- set this better
vim.keymap.set({ "i", "c" }, "<C-p>", "<Up>", { silent = true })
vim.keymap.set({ "i", "c" }, "<C-n>", "<Down>", { silent = true })
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { silent = true })
vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>", { silent = true })
vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>", { silent = true })
vim.keymap.set({ "i", "c" }, "<C-e>", "<End>", { silent = true })
vim.keymap.set({ "i", "c" }, "<A-b>", "<C-Left>", { silent = true })
vim.keymap.set({ "i", "c" }, "<A-f>", "<C-Right>", { silent = true })
vim.keymap.set("i", "<A-d>", "<C-o>dw", { silent = true })
vim.keymap.set({ "i", "c" }, "<C-d>", "<Del>", { silent = true })
vim.keymap.set("i", "<C-k>", "<Esc>lDa", { silent = true })
vim.keymap.set("i", "<C-u>", "<Esc>d0xi", { silent = true })
vim.keymap.set("i", "<A-}>", "<C-o>}", { silent = true })
vim.keymap.set("i", "<A-{>", "<C-o>{", { silent = true })
vim.keymap.set("i", "<A-<>", "<C-o>gg", { silent = true })
vim.keymap.set("i", "<A->>", "<C-o>G", { silent = true })
vim.keymap.set("i", "<C-/>", "<C-o>u", { silent = true })
vim.keymap.set("i", "<C-x><C-s>", "<C-o>:w<CR>", { silent = true })
vim.keymap.set("i", "<C-x><C-c>", "<Esc>:wq<CR>", { silent = true })
-- vim.keymap.set("i", "<C-t>", "<Esc>Xpa", { silent = true })
-- vim.keymap.set("i", "<C-]>", "<C-t>", { silent = true })

-- Normal mode in command line
vim.keymap.set("c", "<C-o>", "<C-f>", { silent = true })

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
vim.keymap.set("n", "<leader>ll", ":Lazy<Cr>", { desc = "Lazy", silent = true })
vim.keymap.set("n", "<leader>lL", ":LazyExtras<Cr>", { desc = "LazyVim Extras", silent = true })

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

--- ThePrimeagen Keymaps
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set(
  "n",
  "<leader>s/",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { silent = true, desc = "Substitute Current Word Globally" }
)
vim.keymap.set(
  "n",
  "<leader>s.",
  [[:s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { silent = true, desc = "Substitute Current Word" }
)
vim.keymap.set("x", "<leader>p", '"_dP', { silent = true, desc = "Paste Without Copy" })
vim.keymap.set("n", "<leader>fx", ":!chmod +x %<Cr>", { silent = true, desc = "Make File Executable" })

-- File
vim.keymap.set("n", "<leader>fX", "<Cmd>!%<Cr>", { silent = true, desc = "Execute File" })
vim.keymap.set("n", "<leader>fs", "<Cmd>source %<Cr>", { silent = true, desc = "Source File" })

vim.keymap.set("v", "<leader>fl", ":'<,'>lua<Cr>", { silent = true, desc = "Execute Line" })

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
end

---------------
-- OBSIDIAN ---
---------------
--
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

----------------------
-- VS CODE CONFIG  ---
----------------------
if vim.g.vscode then
  vim.o.showmode = true
  vim.keymap.set("n", "<leader><space>", function()
    require("vscode").call("workbench.action.quickOpen")
  end)
  vim.keymap.set("n", "<leader>,", function()
    require("vscode").call("workbench.action.showAllEditors")
  end)
  vim.keymap.set("n", "<leader>e", function()
    require("vscode").call("workbench.view.explorer")
  end)
  vim.keymap.set("n", "<leader><Cr>", function()
    require("vscode").call("oil-code.open")
  end)
  vim.keymap.set("n", "<leader>tn", function()
    require("vscode").call("workbench.action.createTerminalEditor")
  end)
  vim.keymap.set("n", "<leader>/", function()
    require("vscode").call("workbench.action.quickTextSearch")
  end)
  vim.keymap.set("n", "<leader>gg", function()
    require("vscode").call("lazygit.openLazygit")
  end)
  vim.keymap.set("n", "<leader>G", function()
    require("vscode").call("fugitive.open")
  end)
  vim.keymap.set("n", "<leader>gn", function()
    require("vscode").call("magit.status")
  end)
  vim.keymap.set("n", "gd", function()
    require("vscode").call("editor.action.revealDefinition")
  end)
  vim.keymap.set("n", "gr", function()
    require("vscode").call("editor.action.goToReferences")
  end)
  vim.keymap.set("n", "j", "gj")
  vim.keymap.set("n", "k", "gk")
  vim.keymap.set("n", "<leader>ha", function()
    require("vscode").call("vscode-harpoon.addEditor")
  end)
  vim.keymap.set("n", "<leader>he", function()
    require("vscode").call("vscode-harpoon.editEditors")
  end)
  for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, function()
      require("vscode").call("vscode-harpoon.gotoEditor" .. i)
    end)
    vim.keymap.set("n", "<leader>h" .. i, function()
      require("vscode").call("vscode-harpoon.addGlobalEditor" .. i)
    end)
  end
  -- config from https://www.reddit.com/r/neovim/comments/1kspket/comment/mtslipm/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  vim.keymap.set("n", "<leader>cf", function()
    require("vscode").call("editor.action.formatDocument")
  end)
  vim.keymap.set("n", "<leader>bo", function()
    require("vscode").call("workbench.action.closeOtherEditors")
  end)
  vim.keymap.set("n", "<leader>ca", function()
    require("vscode").call("editor.action.quickFix")
  end, {})
  vim.keymap.set("n", "<leader>cr", function()
    require("vscode").call("editor.action.rename")
  end, {})
  vim.keymap.set("n", "K", function()
    require("vscode").call("editor.action.showHover")
  end)
  vim.keymap.set("n", "<leader>wq", function()
    require("vscode").call("workbench.action.closeActiveEditor")
  end, {})
  vim.keymap.set("n", "gd", function()
    require("vscode").call("editor.action.revealDefinition")
  end, {})
  vim.keymap.set("n", "gr", function()
    require("vscode").call("editor.action.goToReferences")
  end, {})
  vim.keymap.set("n", "gi", function()
    require("vscode").call("editor.action.goToImplementation")
  end, {})
  vim.keymap.set("n", "zM", function()
    require("vscode").call("editor.foldAll")
  end, { noremap = true, silent = true })
  vim.keymap.set("n", "zR", function()
    require("vscode").call("editor.unfoldAll")
  end, { noremap = true, silent = true })
  vim.keymap.set("n", "zc", function()
    require("vscode").call("editor.fold")
  end, { noremap = true, silent = true })
  vim.keymap.set("n", "zC", function()
    require("vscode").call("editor.foldRecursively")
  end, { noremap = true, silent = true })
  vim.keymap.set("n", "zo", function()
    require("vscode").call("editor.unfold")
  end, { noremap = true, silent = true })
  vim.keymap.set("n", "zO", function()
    require("vscode").call("editor.unfoldRecursively")
  end, { noremap = true, silent = true })
  vim.keymap.set("n", "za", function()
    require("vscode").call("editor.toggleFold")
  end, { noremap = true, silent = true })
else
  -----------------------------
  ---  REMAP DEFAULT PICKER ---
  -----------------------------

  vim.keymap.set("n", "<leader>gg", function()
    Snacks.lazygit({ cwd = LazyVim.root.git() })
    vim.keymap.set("t", "<Esc><Esc>", "<Nop>", { buffer = true })
  end, { desc = "Lazygit" })

  vim.keymap.set("n", "<leader>gG", function()
    Snacks.lazygit()
    vim.keymap.set("t", "<Esc><Esc>", "<Nop>", { buffer = true })
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

  vim.keymap.set("n", "<leader>ff", function()
    Snacks.picker.files({
      hidden = true,
    })
  end, { desc = "Find Files (Root dir)" })

  vim.keymap.set("n", "<leader><space>", function()
    Snacks.picker.smart({
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

  -- vim.keymap.set("n", "<leader>uC", function ()
  --   Snacks.picker.colorschemes()
  --   TmuxTheme.write_tmux_theme()
  -- end, { desc =  "Neovim and Tmux Colorschemes"})

end

-------------
-- NEOVIDE --
-------------
-- Neovide Font Resize
if vim.g.neovide then
  FontSize = 12
  function SetFontSize(amount)
    FontSize = FontSize + amount
    vim.o.guifont = "JetbrainsmonoNL NF:h" .. FontSize
    print("Font Size: " .. FontSize)
  end

  SetFontSize(0)
  vim.keymap.set("n", "<C-=>", function()
    SetFontSize(1)
  end, { desc = "Increase Font Size in neovide", silent = true })
  vim.keymap.set("n", "<C-->", function()
    SetFontSize(-1)
  end, { desc = "Decrease Font Size in neovide", silent = true })
  vim.keymap.set("n", "<C-0>", function()
    FontSize = 12
    vim.o.guifont = "JetbrainsmonoNL NF:h" .. FontSize
    print("Font Size: " .. FontSize)
  end, { desc = "Restore Font Size in neovide", silent = true })
end

----------------------------------
-- CUSTOM SEARCH FILES AND WORD --
----------------------------------
local function GrepSearch()
  local input = vim.fn.input("Grep for > ")
  if input == "" then
    return
  end
  local cmd = string.format("grep -rnI --exclude-dir=.git --exclude-dir=node_modules --color=never '%s' .", input)
  local tmp = vim.fn.tempname()
  vim.fn.system(cmd .. " > " .. vim.fn.fnameescape(tmp))
  vim.cmd("cfile " .. tmp)
  vim.cmd("copen")
  os.remove(tmp)
end
vim.api.nvim_create_user_command("Grep", GrepSearch, {})
vim.keymap.set("n", "<leader>o/", ":Grep<CR>", { noremap = true, silent = true, desc = "Grep (Quickfix)" })

function FzfLike()
  local handle = io.popen("find . -type f -not -path '*/.git/*'")
  if not handle then
    vim.notify("Erro ao executar 'find'", vim.log.levels.ERROR)
    return
  end
  local files = {}
  for file in handle:lines() do
    table.insert(files, file)
  end
  handle:close()
  vim.ui.input({ prompt = "Find for > " }, function(input)
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
      vim.notify("No File Found.", vim.log.levels.INFO)
      return
    end
    local qf_entries = {}
    for _, file in ipairs(filtered) do
      table.insert(qf_entries, { filename = file, lnum = 1, col = 1, text = file })
    end
    vim.fn.setqflist({}, " ", {
      title = "FzfLike Results",
      items = qf_entries,
    })
    if count == 1 then
      vim.cmd("edit " .. filtered[1])
    else
      vim.cmd("edit " .. filtered[1])
      vim.cmd("copen")
    end
  end)
end

vim.keymap.set("n", "<leader>of", FzfLike, { desc = "Fuzzy Find (Quickfix)" })

-----------
-- Tmux ---
-----------
-- if vim.env.TMUX then
--   vim.keymap.set(
--     "n",
--     "<leader>gg",
--     ":! ~/scripts/tmux-scripts/tmux-open.sh lazygit<Cr>",
--     { silent = true, desc = "Open Lazygit in Tmux" }
--   )
-- end

vim.keymap.set("n", "<leader>oT", function() TmuxTheme.write_tmux_theme() end, { desc = "Update Tmux Theme"})

