-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.keymap.set({ "n", "v" }, "n", "nzz", { silent = true, desc = "Next Search Result" })
-- vim.keymap.set("n", "N", "Nzz", { silent = true, desc = "Previous Search Result" })
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, desc = "Half Scroll Down and Center" })
-- vim.keymap.set("n", "<C-u>", "<c-u>zz", { silent = true, desc = "Half Scroll Up and Center" })
vim.keymap.set("x", ">", ">gv", { silent = true, desc = "Better Indent" })
vim.keymap.set("x", "<", "<gv", { silent = true, desc = "Better Indent" })
vim.keymap.set("n", "gJ", "kJ_", { silent = true, desc = "Join Line Above" })
vim.keymap.set("n", "J", "J_", { silent = true, desc = "Better Join Line" })

pcall(function()
    -- Del LazyVim Keymaps
    vim.keymap.set({ "x", "n" }, "<Left>", "<Left>")
    vim.keymap.set({ "x", "n" }, "<Up>", "<Up>")
    vim.keymap.set({ "x", "n" }, "<Down>", "<Down>")
    vim.keymap.set({ "x", "n" }, "<Right>", "<Right>")

    -- vim.keymap.del({ "n" }, "<C-h>")
    -- vim.keymap.del({ "n" }, "<C-j>")
    -- vim.keymap.del({ "n" }, "<C-k>")
    -- vim.keymap.del({ "n" }, "<C-l>")
end)
-----------------
--- DASHBOARD ---
-----------------
vim.keymap.set("n", "<leader>od", function()
    Snacks.dashboard()
end, { silent = true, desc = "Open Dashboard" })

----------------
--- TERMINAL ---
----------------
---- Normal neovim Mode to Terminal
---- Remap default C-/ Lazyvim
vim.keymap.set({ "n", "t", "i", "v" }, "<c-/>", function()
  Snacks.terminal("tmux", { cwd = vim.uv.cwd() })
end, { silent = true, desc = "Open Float Terminal" })

-- vim.keymap.set({ "n", "t", "i", "v" }, "<leader>tf", function()
--   Snacks.terminal("zellij")
-- end, { silent = true, desc = "Open Float  Terminal" })

vim.keymap.set("n", "<leader>tn", ":terminal ", { silent = true, desc = "New Buffer Terminal With Command" } )
vim.keymap.set("n", "<leader>tv", ":vertical terminal ", { silent = true, desc = "Vertical Terminal With Command" } )
vim.keymap.set("n", "<leader>ts", ":horizontal terminal ", { silent = true, desc = "Horizontal Terminal With Command" } )

vim.keymap.set("n", "<leader>tN", "<Cmd>terminal<Cr>", { silent = true, desc = "New Buffer Terminal" })
vim.keymap.set("n", "<leader>tV", "<Cmd>vertical terminal<CR>", { silent = true, desc = "Vertical Terminal" })
vim.keymap.set("n", "<leader>tS", "<Cmd>horizontal terminal<CR>", { silent = true, desc = "Horizontal Terminal" })

-- vim.keymap.set("n", "<leader>occ", ":hor term ", { desc = "Compile Mode" })
vim.keymap.set("n", "<leader>occ", ":hor term ", { desc = "Compile Mode" })
vim.keymap.set("n", "<leader>olg", "<Cmd>term lazygit<CR><Cmd>start<Cr>", { desc = "Lazygit" })
vim.keymap.set("n", "<leader>o?", ":hor term rg --vimgrep ", { desc = "Grep" })

---- Terminal Mode to Normal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true, desc = "Go To Normal Mode in Terminal" })

---- Move in windows on Terminal Mode
-- vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h")
-- vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j")
-- vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k")
-- vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l")

-- -- Move Window
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- resize window
-- vim.keymap.set("n", "<C-A-h>", "<C-w><", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-A-l>", "<C-w>>", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-A-k>", "<C-w>-", { desc = "Move window to the upper" })
-- vim.keymap.set("n", "<C-A-j>", "<C-w>+", { desc = "Move window to the lower" })
-- Close Window
vim.keymap.set("n", "<leader>wc", "<Cmd>close<Cr>")

-- Toggle Comment
-- vim.keymap.set("n", "<C-/>", ":normal gcc<Cr>", { desc = "Toggle Comment", silent = true })
-- vim.keymap.set("x", "<C-/>", ":>normal gcc<Cr>", { desc = "Toggle Comment", silent = true })

-- Move Lines Up/Down
-- vim.keymap.set("x", "<C-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move Line Up" })
-- vim.keymap.set("x", "<C-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move Line Down" })

-- Emacs Keybinds in Insert Mode
-- set this better
vim.keymap.set({ "i", "c" }, "<C-p>", "<Up>", { silent = true })
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { silent = true })
vim.keymap.set({ "i", "c" }, "<C-n>", "<Down>", { silent = true })
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
vim.keymap.set("i", "<A-a>", "<C-o>(", { silent = true })
vim.keymap.set("i", "<A-e>", "<C-o>)", { silent = true })
vim.keymap.set("i", "<A-<>", "<C-o>gg", { silent = true })
vim.keymap.set("i", "<A->>", "<C-o>G", { silent = true })
vim.keymap.set("i", "<C-/>", "<C-o>u", { silent = true })
vim.cmd([[
  imap <C-BS> <C-w>
]])
-- vim.keymap.set("i", "<C-x><C-s>", "<Cmod>update<CR>", { silent = true })
-- vim.keymap.set("i", "<C-x><C-x>", "<Esc>:x<CR>", { silent = true })
-- vim.keymap.set("i", "<C-t>", "<Esc>Xpa", { silent = true })
-- vim.keymap.set("i", "<C-]>", "<C-t>", { silent = true })
vim.keymap.set("n", "<A-x>", ":", { desc = "Emacs" })
vim.keymap.set("i", "<A-x>", "<C-o>:", { desc = "Emacs" })
vim.keymap.set("t", "<A-x>", "<C-\\><C-o>:", { desc = "Emacs" })

vim.keymap.set({ "i", "x", "n" }, "<C-s>", "<Cmd>update<CR>", { silent = true })

-- Indent with tab
vim.keymap.set("i", "<Tab>", "<C-t>")
vim.keymap.set("i", "<S-Tab>", "<C-d>")

-- Emacs Keybinds in Command Mode
vim.keymap.set({ "c" }, "<C-p>", "<Up>")
vim.keymap.set({ "c" }, "<C-n>", "<Down>")
vim.keymap.set({ "c" }, "<C-a>", "<Home>")
vim.keymap.set({ "c" }, "<C-f>", "<Right>")
vim.keymap.set({ "c" }, "<C-b>", "<Left>")
vim.keymap.set({ "c" }, "<C-e>", "<End>")
vim.keymap.set({ "c" }, "<A-b>", "<S-Left>")
vim.keymap.set({ "c" }, "<A-f>", "<S-Right>")

-- Normal mode in command line
vim.keymap.set("c", "<C-o>", "<C-f>")

-- Visual Keymaps - Markdown Text
vim.keymap.set(
    "x",
    "<C-i>",
    ":<Del><Del><Del><Del><Del>norm saiw*<Cr>gv",
    { silent = true, desc = "Add Italic/Bold(*)" }
)
vim.keymap.set(
    "x",
    "<C-o>",
    ":<Del><Del><Del><Del><Del>norm sd*<Cr>gv",
    { silent = true, desc = "Remove Italic/Bold(*)" }
)

--- Buffers
-- Remove Lazyvim default keymap
pcall(function()
    vim.keymap.del("n", "<S-h>")
    vim.keymap.del("n", "<S-l>")
end)
vim.keymap.set("n", "<C-S-PageUp>", vim.cmd.bnext, { desc = "Next Buffer" })
vim.keymap.set("n", "<C-S-PageDown>", vim.cmd.bprev, { desc = "Previous Buffer" })
-- vim.keymap.set("n", "<leader>bp", vim.cmd.bp, { silent = false, desc = "Next Buffer" })
-- vim.keymap.set("n", "<leader>bn", vim.cmd.bn, { silent = false, desc = "Previous Buffer" })
-- vim.keymap.set("n", "<C-w>p", vim.cmd.bp, { silent = false, desc = "Next Buffer" })
-- vim.keymap.set("n", "<leader>bp", vim.cmd.bp, { silent = false, desc = "Next Buffer" })
-- vim.keymap.set("n", "<C-w>n", vim.cmd.bn, { silent = false, desc = "Previous Buffer" })
-- vim.keymap.set("n", "<leader>wn", vim.cmd.bn, { silent = false, desc = "Previous Buffer" })

-- Copy Entire Buffer
vim.keymap.set("n", "gA", "<Cmd>%y<Cr>", { silent = true, desc = "Yank entire file" })

-- Normal mode in command line
-- vim.keymap.set("n", "<leader>;", ":<c-f>", { silent = true, desc = "Vi Command Mode" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

---------------
--- LazyVim ---
---------------
pcall(function()
    vim.keymap.del("n", "<leader>l")
end)
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
vim.keymap.set("n", "<leader>qh", "<Cmd>chistory<Cr>", { silent = true, desc = "List Quick Fix History" })
vim.keymap.set("n", "<leader>qn", "<Cmd>cnewer<Cr>", { silent = true, desc = "Next Quickfix List" })
vim.keymap.set("n", "<leader>qN", "<Cmd>colder<Cr>", { silent = true, desc = "Previous Quickfix List" })
for i = 1, 9 do
  vim.keymap.set("n", "<leader>q" .. i, "<Cmd>chistory " .. i .. "<Cr>", { silent = true, desc = "Go to " .. i .. " Quickfix" })
end

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
    "<leader>rg",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Substitute Current Word Globally" }
)
vim.keymap.set(
    "n",
    "<leader>rw",
    [[:s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Substitute Current Word" }
)
vim.keymap.set({ "x", "n" }, "<leader>rr", ":s/", { desc = "Search and Replace" })
vim.keymap.set("x", "S", ":s/", { desc = "Substitute in line(or selection)" })

vim.keymap.set("x", "<leader>rp", '"_dP', { silent = true, desc = "Paste Without Copy" })

vim.keymap.set("n", "gf", ":e <cfile><Cr>", { silent = true, desc = "Better gf" })


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
vim.keymap.set("n", "<leader><Tab>z", ":tcd ", { desc = "Tab Cd" })
vim.keymap.set("n", "<leader><Tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><Tab>c", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "]<Tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "[<Tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- vim.keymap.set("n", "<leader>tL", "<cmd>tablast<cr>", { desc = "Last Tab" })
-- vim.keymap.set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
-- vim.keymap.set("n", "<leader>tF", "<cmd>tabfirst<cr>", { desc = "First Tab" })
-- vim.keymap.set("n", "<leader>tt", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close Tab" })
-- vim.keymap.set("n", "<leader>t]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- vim.keymap.set("n", "<leader>t[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- vim.o.timeout = false
local tmux_prefix = "<A-p>"
local map = vim.keymap.set
local modes = { "n", "x", "i", "t" }
local term_insert_mode = "<Cmd>term<Cr><Cmd>start<Cr>"

map(modes, tmux_prefix .. "%", "<Cmd>split<Cr>" .. term_insert_mode, { desc = "Tmux Split" })
map(modes, tmux_prefix .. "\"", "<Cmd>vsplit<Cr>" .. term_insert_mode, { desc = "Tmux Vertical Split" })
map(modes, tmux_prefix .. "c", "<Cmd>tabnew<Cr>" .. term_insert_mode, { desc = "Tmux New Tab" })
map(modes, tmux_prefix .. "x", "<Cmd>close!<Cr>", { desc = "Tmux Close" })
map(modes, tmux_prefix .. "w", ":b term:h", { desc = "Tmux Switch Terminals" })
map(modes, tmux_prefix .. "[", "<C-\\><C-n>", { desc = "Tmux Copy Mode" })

for i = 1, 9, 1 do
    map(modes, tmux_prefix .. i, "<Cmd>norm " .. i .. "gt<Cr>", { desc = "Tmux to tab " .. i })
    vim.keymap.set("n", "<leader><tab>" .. i, "<Cmd>norm" .. i .. "gt<Cr>", { desc = "which_key_ignore" })
end


vim.cmd([[
 nmap  <S-ScrollWheelUp> zh
 nmap  <S-ScrollWheelDown> zl
 ]])

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

vim.keymap.set("n", "<leader>oop", function()
    vim.cmd("!git pull")
    print("Pull Changes")
end, { desc = "Pull Changes" })

vim.keymap.set("n", "<leader>ooP", function()
    vim.cmd("!git push")
    print("Push Changes")
end, { desc = "Push Changes" })

vim.keymap.set("x", "<leader>oof", ':! tr -s " " | column -t -s "|" -o "|"<Cr>', { desc = "Format Table in Markdown" })

vim.keymap.set("x", "<leader>a", ":AlignRegexp<CR>", { desc = "Align by regex", silent = true })


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
vim.keymap.set("n", "<leader>or", ":grep <cword><cr>:cope<Cr>", { desc = "Find Function/Decaration/References" })
vim.keymap.set("n", "<leader>o/", ":LiveGrep  %:h<left><left><left><left>") -- Custom Autocmd

----------
-- Make --
----------
vim.keymap.set("n", "<leader>cm", ":make ", { desc = "Make", remap = true })
vim.keymap.set("n", "<leader>cM", "<Cmd>make<CR>", { desc = "Run Make" })


vim.keymap.set('n', 'gX', function()
    local file = vim.fn.expand("%:p")
    if file ~= "" then
        vim.ui.open(file)
    else
        vim.notify("No file to open", vim.log.levels.WARN)
    end
end, { desc = "Open current file" })

vim.keymap.set("c", "w!!", "w !sudo tee > /dev/null %", { silent = true, desc = "Write as Sudo" })
