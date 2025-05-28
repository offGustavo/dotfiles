-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "v" }, "n", "nzz", { silent = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "Nzz", { silent = true, desc = "Previous Search Result" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, desc = "Half Scroll Down and Center" })
vim.keymap.set("n", "<C-u>", "<c-u>zz", { silent = true, desc = "Half Scroll Up and Center" })
vim.keymap.set("n", ">", ">gv", { silent = true, desc = "Half Scroll Up and Center" })
vim.keymap.set("n", "<", "<gv", { silent = true, desc = "Half Scroll Up and Center" })

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
-- vim.keymap.set({ "n", "t", "i", "v" }, "<A-/>", function()
--   Snacks.terminal()
-- end, { silent = true, desc = "Open Terminal" })

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
vim.keymap.set("n", "<C-A-j>", "<C-w>+", { desc = "Move window to the lower" })
vim.keymap.set("n", "<C-A-k>", "<C-w>-", { desc = "Move window to the upper" })

-- Close Window
vim.keymap.set("n", "<leader>wc", "<Cmd>close<Cr>")

-- Move Lines Up/Down
vim.keymap.set("v", "<S-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move Line Up" })
vim.keymap.set("v", "<S-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move Line Down" })

-- Emacs Keybinds in Insert Mode
-- set this better
-- vim.keymap.set("i", "<C-p>", "<Up>", { silent = true } )
-- vim.keymap.set("i", "<C-n>", "<Down>", { silent = true } )
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { silent = true })
vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>", { silent = true })
vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>", { silent = true })
vim.keymap.set({ "i", "c" }, "<C-e>", "<End>", { silent = true })
vim.keymap.set({ "i", "c" }, "<A-b>", "<C-Left>", { silent = true })
vim.keymap.set({ "i", "c" }, "<A-f>", "<C-Right>", { silent = true })
vim.keymap.set({ "i", "c" }, "<A-d>", "<C-o>dw", { silent = true })
vim.keymap.set({ "i", "c" }, "<C-d>", "<C-o>dl", { silent = true })
vim.keymap.set({ "i", "c" }, "<C-k>", "<Esc>lDa", { silent = true })
vim.keymap.set({ "i", "c" }, "<C-u>", "<Esc>d0xi", { silent = true })
vim.keymap.set("i", "<A-}>", "<C-o>}", { silent = true })
vim.keymap.set("i", "<A-{>", "<C-o>{", { silent = true })
vim.keymap.set("i", "<C-x><C-s>", "<Esc>:w<CR>a", { silent = true })

-- Normal mode in command line
vim.keymap.set("c", "<C-o>", "<C-f>", { silent = true })

-- -- Buffer Movement
-- vim.keymap.set("n", "<C-w>p", vim.cmd.bp, { silent = false, desc = "Next Buffer" })
-- vim.keymap.set("n", "<leader>wp", vim.cmd.bp, { silent = false, desc = "Next Buffer" }i)
-- vim.keymap.set("n", "<leader>bp", vim.cmd.bp, { silent = false, desc = "Next Buffer" })
-- vim.keymap.set("n", "<C-w>n", vim.cmd.bn, { silent = false, desc = "Previous Buffer" })
-- vim.keymap.set("n", "<leader>wn", vim.cmd.bn, { silent = false, desc = "Previous Buffer" })
-- vim.keymap.set("n", "<leader>bn", vim.cmd.bn, { silent = false, desc = "Previous Buffer" })

-- Normal mode in command line
-- vim.keymap.set("n", "<leader>;", ":<c-f>", { silent = true, desc = "Vi Command Mode" })

-- Diagnostic keymaps (quickstart keymaps)
-- vim.keymap.set("n", "<leader>qf", vim.diagnostic.setloclist, { desc = "Open Diagnostic Quickfix List" })
-- vim.keymap.set("n", "<leader>qn", "<Cmd>cnext<Cr>", { desc = "Open Next in Quickfix List" })
-- vim.keymap.set("n", "<leader>qp", "<Cmd>cprev<Cr>", { desc = "Open Previous in Quickfix List" })
-- vim.keymap.set("n", "<leader>qo", "<Cmd>copen<Cr>", { desc = "Open Quickfix List" })
-- vim.keymap.set("n", "<leader>qc", "<Cmd>cclose<Cr>", { desc = "Close Quickfix List" })

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
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste Without Copy" })
vim.keymap.set("n", "<leader>fx", ":!chmod +x %<Cr>", { desc = "Make File Executable" })

vim.keymap.set("n", "<leader>fX", ":!%<Cr>", { desc = "Execute File" })
vim.keymap.set("n", "<leader>fs", ":so %<Cr>", { desc = "Source File" })

vim.keymap.set("n", "g<leader>", "`", { desc = "Go to Marks" })

-- Remove Lazyvim default keymap
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

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

---------------
-- OBSIDIAN ---
---------------

-- Obsidian Daily Note
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

vim.keymap.set("n", "<leader>oop", function()
  vim.cmd("!git push")
  print("Push Changes")
end, { desc = "Push Changes" })

----------------------
-- VS CODE CONFIG  ---
----------------------
if vim.g.vscode then
  vim.keymap.set("n", "<leader>,", "<Cmd>call VSCodeNotify('workbench.action.showAllEditors')<CR>")
  vim.keymap.set("n", "<leader>e", "<Cmd>call VSCodeNotify('workbench.view.explorer')<CR>")
  vim.keymap.set("n", "<leader><Cr>", "<Cmd>call VSCodeNotify('oil-code.open')<CR>")
  vim.keymap.set("n", "<leader>tn", "<Cmd>call VSCodeNotify('workbench.action.createTerminalEditor')<CR>")
  vim.keymap.set("n", "<leader>/", "<Cmd>call VSCodeNotify('workbench.action.quickTextSearch')<CR>")
  vim.keymap.set("n", "<leader>gg", "<Cmd>call VSCodeNotify('lazygit.openLazygit')<CR>")
  vim.keymap.set("n", "gd", "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>")
  vim.keymap.set("n", "gr", "<Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>")
  vim.keymap.set("n", "<leader>1", "`1")
  vim.keymap.set("n", "<leader>2", "`2")
  vim.keymap.set("n", "<leader>3", "`3")
  vim.keymap.set("n", "<leader>4", "`4")
  vim.keymap.set("n", "<leader>5", "`5")
  vim.keymap.set("n", "<leader>6", "`6")
  vim.keymap.set("n", "<leader>7", "`7")
  vim.keymap.set("n", "<leader>8", "`8")
  vim.keymap.set("n", "<leader>9", "`9")
  vim.o.showmode = true
  -- config from https://www.reddit.com/r/neovim/comments/1kspket/comment/mtslipm/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  -- vim.keymap.set('n', "<leader>f", "<Cmd> call VSCodeNotify('editor.action.formatDocument') end, {})
  -- vim.keymap.set('i', "<c-k>", "<Cmd> call VSCodeNotify('editor.action.triggerParameterHints') end, {})
  vim.keymap.set("n", "<leader>bo", "<Cmd>call VSCodeNotify('workbench.action.closeOtherEditors')<Cr>")
  -- vim.keymap.set('n', "<leader>se", "<Cmd> call VSCodeNotify('editor.action.showHover')", {})
  vim.keymap.set("n", "<leader>ca", "<Cmd>call VSCodeNotify('editor.action.quickFix')<Cr>", {})
  vim.keymap.set("n", "<leader>cr", "<Cmd>call VSCodeNotify('editor.action.rename')<Cr>", {})
  -- vim.keymap.set('n', "<leader>h", "<Cmd> call VSCodeNotify('workbench.action.navigateLeft')<Cr>", {})
  -- vim.keymap.set('n', "<leader>l", "<Cmd> call VSCodeNotify("workbench.action.navigateRight")", {})
  vim.keymap.set("n", "K", "<Cmd> call VSCodeNotify('editor.action.showHover')<Cr>")
  vim.keymap.set("n", "<leader>wq", "<Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<Cr>", {})
  vim.keymap.set("n", "gd", "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<Cr>", {})
  vim.keymap.set("n", "gr", "<Cmd>call VSCodeNotify('editor.action.goToReferences')<Cr>", {})
  vim.keymap.set("n", "gi", "<Cmd>call VSCodeNotify('editor.action.goToImplementation')<Cr>", {})
  vim.keymap.set("n", "zM", "<Cmd>call VSCodeNotify('editor.foldAll')<Cr>", { noremap = true, silent = true })
  vim.keymap.set("n", "zR", "<Cmd>call VSCodeNotify('editor.unfoldAll')<Cr>", { noremap = true, silent = true })
  vim.keymap.set("n", "zc", "<Cmd>call VSCodeNotify('editor.fold')<Cr>", { noremap = true, silent = true })
  vim.keymap.set("n", "zC", "<Cmd>call VSCodeNotify('editor.foldRecursively')<Cr>", { noremap = true, silent = true })
  vim.keymap.set("n", "zo", "<Cmd>call VSCodeNotify('editor.unfold')<Cr>", { noremap = true, silent = true })
  vim.keymap.set(
    "n",
    "zO",
    "<Cmd> call VSCodeNotify('editor.unfoldRecursively')<Cr>",
    { noremap = true, silent = true }
  )
  vim.keymap.set("n", "za", "<Cmd> call VSCodeNotify('editor.toggleFold')<Cr>", { noremap = true, silent = true })
else
  -----------------------------
  ---  REMAP DEFAULT PICKER ---
  -----------------------------
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
    Snacks.picker.files({
      hidden = true,
    })
  end, { desc = "Snacks Picker Files" })
  vim.keymap.set("n", "<leader>/", function()
    Snacks.picker.grep({
      hidden = true,
    })
  end, { desc = "Snacks Picker Grep" })
  vim.keymap.set("n", "<leader>sP", function()
    Snacks.picker.grep({
      hidden = true,
      cwd = "~/.config/nvim/lua/",
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
end

----------------------
-- NEOVIDE          --
----------------------
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

-- Tokyonight_night_transparency = false
-- vim.keymap.set("n", "<leader>ou", function()
--   if Tokyonight_night_transparency then
--     require("tokyonight").setup({
--       transparent = false,
--       styles = {
--         sidebars = "transparent",
--         floats = "transparent",
--       },
--       on_colors = function(colors)
--         colors.bg_statusline = colors.none -- To check if its working try something like "#ff00ff" instead of colors.none
--       end,
--     })
--     vim.cmd("colorscheme default")
--     vim.cmd("colorscheme tokyonight-night")
--     Tokyonight_night_transparency = false
--   else
--     require("tokyonight").setup({
--       transparent = false,
--       styles = {
--         sidebars = "transparent",
--         floats = "transparent",
--       },
--       on_colors = function(colors)
--         colors.bg_statusline = colors.none -- To check if its working try something like "#ff00ff" instead of colors.none
--       end,
--     })
--     vim.cmd("colorscheme default")
--     vim.cmd("colorscheme tokyonight-night")
--     Tokyonight_night_transparency = true
--   end
-- end, { desc = "Turn on opacity" })

-- vim.keymap.set("n", "<leader>ou", function()
--   require("tokyonight").setup({
--     transparent = true,
--     styles = {
--       sidebars = "transparent",
--       floats = "transparent",
--     },
--     on_colors = function(colors)
--       colors.bg_statusline = colors.none -- To check if its working try something like "#ff00ff" instead of colors.none
--     end,
--   })
--   vim.cmd("colorscheme tokyonight-night")
-- end, { desc = "Turn on opacity" })
--
-- vim.keymap.set("n", "<leader>oU", function()
--   require("tokyonight").setup({
--     transparent = false,
--     styles = {
--       sidebars = "dark",
--       floats = "dark",
--     },
--   })
--   vim.cmd("colorscheme tokyonight-night")
-- end, { desc = "Turn off opacity" })
