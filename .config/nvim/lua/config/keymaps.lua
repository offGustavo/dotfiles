-- vim: foldmethod=marker
vim.keymap.set('n', '<leader>qo', vim.cmd.copen, { desc = 'QuickFix Open', silent = true })
vim.keymap.set('n', '<leader>qc', vim.cmd.cclose, { desc = 'QuickFix Close', silent = true })

vim.keymap.set('n', '<leader>qq', vim.cmd.quit, { desc = 'Quit', silent = true })
vim.keymap.set('n', '<leader>qQ', ':qa!<Cr>', { desc = 'Force Quit All', silent = true })
vim.keymap.set('n', '<leader>qr', vim.cmd.restart, { desc = 'Restart', silent = true })

vim.keymap.set('n', '<leader>fC', ':e $MYVIMRC<Cr>', { silent = true, desc = "Edit the Init.lua file"  })

vim.keymap.set('n', '<leader>bb', ':b #<Cr>', { desc = "Alternative Buffer"})
vim.keymap.set('n', '<M-a>', ':b #<Cr>', { desc = "Alternative Buffer"})
vim.keymap.set('n', '<leader>bd', ':bd<Cr>', { desc = "Delete Buffer"})
vim.keymap.set('n', '<leader>bD', ':bufdo bd<Cr>', { desc = "Delete All Buffers"})

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

vim.keymap.set("n","<M-t>", ":t.<CR>")
vim.keymap.set("x","<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("x","<C-k>", ":m '<-2<CR>gv=gv")

-- {{{ Tabs
vim.keymap.set("n", "<leader><tab>o", "<Cmd>tabonly<CR>")
vim.keymap.set("n", "<leader><tab><tab>", "<Cmd>tabnew<CR>")
vim.keymap.set("n", "[<tab>", "<Cmd>tabprev<CR>")
vim.keymap.set("n", "[<tab>", "<Cmd>tabnext<CR>")
vim.keymap.set("n", "<leader><tab>c", "<Cmd>tabclose<CR>")
---}}}

-- -- Poor man harpoon
-- vim.keymap.set('n', '<leader>ha', function()
--   vim.cmd 'argadd %'
--   vim.cmd 'argdedup'
-- end)
--
-- vim.keymap.set('n', '<leader>hd', function()
--   vim.cmd 'argd %'
-- end)
--
-- -- assign arg to each number
-- for i = 1, 9 do
--   vim.keymap.set('n', '<leader>' .. i, '<CMD>argu ' .. i .. '<CR>', { silent = true, desc = 'Go to arg ' .. i })
--   vim.keymap.set('n', '<leader>h' .. i, '<CMD>' .. i - 1 .. 'arga<CR>',
--     { silent = true, desc = 'Add current to arg ' .. i })
--   vim.keymap.set('n', '<leader>d' .. i, '<CMD>' .. i .. 'argd<CR>', { silent = true, desc = 'Delete current arg' })
-- end
--
-- -- to qf
-- vim.keymap.set('n', '<leader>he', function()
--   local list = vim.fn.argv()
--   if #list > 0 then
--     local qf_items = {}
--     for _, filename in ipairs(list) do
--       table.insert(qf_items, {
--         filename = filename,
--         lnum = 1,
--         text = filename,
--       })
--     end
--     vim.fn.setqflist(qf_items, 'r')
--     vim.cmd.copen()
--   end
-- end, { silent = true, desc = 'Show args in qf' })
--
-- -- Convert quickfix list to argument list
-- vim.keymap.set('n', '<leader>hq', function()
--   local qf_list = vim.fn.getqflist()
--   if #qf_list == 0 then
--     vim.notify("Quickfix list is empty", vim.log.levels.WARN)
--     return
--   end
--   -- Clear current argument list
--   vim.cmd '%argdelete'
--   -- Add each quickfix item to argument list
--   for _, item in ipairs(qf_list) do
--     if item.filename and item.filename ~= '' then
--       -- Use absolute path to avoid issues
--       local filename = vim.fn.fnamemodify(item.filename, ':p')
--       vim.cmd('argadd ' .. vim.fn.fnameescape(filename))
--     elseif item.bufnr and vim.fn.bufexists(item.bufnr) > 0 then
--       -- If we have a buffer number but no filename, use buffer name
--       local bufname = vim.fn.bufname(item.bufnr)
--       if bufname and bufname ~= '' then
--         local filename = vim.fn.fnamemodify(bufname, ':p')
--         vim.cmd('argadd ' .. vim.fn.fnameescape(filename))
--       end
--     end
--   end
--   -- Remove duplicates
--   vim.cmd 'argdedup'
--   vim.notify(string.format("Added %d files from quickfix to argument list", #qf_list))
-- end, { silent = true, desc = 'Quickfix to args' })

--- {{{ Windows
vim.keymap.set("n", "<leader>w", "<C-w>", { desc = "Windows" })
vim.keymap.set({'x', 'n', 'i', 't'}, '<M-S-j>', function () vim.cmd.wincmd("w")
end)
vim.keymap.set({'x', 'n', 'i', 't'}, '<M-S-k>', function ()
  vim.cmd.wincmd("W")
end)
vim.keymap.set("n", "<M-=>", function ()
  vim.cmd.wincmd("=")
end, { desc = "Windows"})
vim.keymap.set("n", "<M-S-=>", function ()
  vim.cmd.wincmd("+")
end, { desc = "Windows"})
vim.keymap.set("n", "<M-->", function ()
  vim.cmd.wincmd("-")
end, { desc = "Windows"})
vim.keymap.set("n", "<M-S-,>", function ()
  vim.cmd.wincmd("<")
end, { desc = "Windows"})
vim.keymap.set("n", "<M-S-.>", function ()
  vim.cmd.wincmd(">")
end, { desc = "Windows"})
  --- }}}

--{{{ -- Terminal
vim.keymap.set({"i", "c", "n", "v", "x" }, '<C-c>', "<Esc>", { desc = 'Fix <C-c>', silent = true })
vim.keymap.set('t', '<M-;>', '<C-\\><C-n>', { silent = true, desc = 'Go To Normal Mode in Terminal', nowait = true })
vim.keymap.set('t', '<S-Esc>', '<C-\\><C-n>', { silent = true, desc = 'Go To Normal Mode in Terminal', nowait = true })
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { silent = true, desc = 'Go To Normal Mode in Terminal', nowait = true })
vim.keymap.set('n', '<leader>tn', ':term ')
vim.keymap.set('n', '<leader>tn', ':term ')
vim.keymap.set('n', '<leader>tn', ':term ')
-- vim.keymap.set('n', '<leader>cc', ':hor term ')
-- vim.keymap.set('n', '<A-c>', ':hor term rg')
-- vim.keymap.set('n', '<leader>cc', ':hor term ')
-- vim.keymap.set('n', '<A-c>', ':hor term ')
-- vim.keymap.set('n', '<leader>tn', ':term ')

-- vim.o.timeout = false
-- local tmux_prefix = "<A-p>"
-- local map = vim.keymap.set
-- local modes = { "n", "x", "i", "t" }
-- local term_insert_mode = "<Cmd>term<Cr><Cmd>start<Cr>"
-- local insert_mode = "<Cmd>start<Cr>"
-- local exit_term_mode = "<C-\\><C-n>" 
--
-- map(modes, tmux_prefix .. "%", "<Cmd>split<Cr>" .. term_insert_mode, { desc = "Tmux Split" })
-- map(modes, "<A-s>", "<Cmd>split<Cr>" .. term_insert_mode, { desc = "Tmux Vertical Split" })
-- map(modes, tmux_prefix .. "\"", "<Cmd>vsplit<Cr>" .. term_insert_mode, { desc = "Tmux Vertical Split" })
-- map(modes, "<A-v>", "<Cmd>vsplit<Cr>" .. term_insert_mode, { desc = "Tmux Vertical Split" })
-- map(modes, tmux_prefix .. "c", "<Cmd>tabnew<Cr>" .. term_insert_mode, { desc = "Tmux New Tab" })
-- map(modes, "<A-n>", "<Cmd>tabnew<Cr>" .. term_insert_mode, { desc = "Tmux New Tab" })
-- map(modes, tmux_prefix .. "x", "<Cmd>close!<Cr>", { desc = "Tmux Close" })
-- map(modes, "<A-x>", "<Cmd>close!<Cr>", { desc = "Tmux Close" })
-- map(modes, tmux_prefix .. "w", ":b term:h", { desc = "Tmux Switch Terminals" })
-- map(modes, tmux_prefix .. "[", exit_term_mode, { desc = "Tmux Copy Mode" })
--
-- map(modes, tmux_prefix .. "h", exit_term_mode .. "<C-w>h" .. insert_mode, { desc = "Tmux Copy Mode" })
-- map(modes, tmux_prefix .. "j", exit_term_mode .. "<C-w>j" .. insert_mode, { desc = "Tmux Copy Mode" })
-- map(modes, tmux_prefix .. "k", exit_term_mode .. "<C-w>k" .. insert_mode, { desc = "Tmux Copy Mode" })
-- map(modes, tmux_prefix .. "l", exit_term_mode .. "<C-w>l" .. insert_mode, { desc = "Tmux Copy Mode" })
-- map(modes, "<A-h>", exit_term_mode .. "<C-w>h" .. insert_mode, { desc = "Tmux Copy Mode" })
-- map(modes, "<A-j>", exit_term_mode .. "<C-w>j" .. insert_mode, { desc = "Tmux Copy Mode" })
-- map(modes, "<A-k>", exit_term_mode .. "<C-w>k" .. insert_mode, { desc = "Tmux Copy Mode" })
-- map(modes, "<A-l>", exit_term_mode .. "<C-w>l" .. insert_mode, { desc = "Tmux Copy Mode" })
--
-- for i = 1, 9, 1 do
--     map({ "n", "x", "i"} , tmux_prefix .. i, "<Cmd>norm " .. i .. "gt<Cr>", { desc = "Tmux to tab " .. i })
--     map("t", tmux_prefix .. i, "<C-\\><C-o>:norm " .. i .. "gt<Cr>", { desc = "Tmux to tab " .. i })
-- end

--}}}


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

-- vim.keymap.set("x", "<leader>rp", '"_dP', { silent = true, desc = "Paste Without Copy" })

vim.keymap.set("n", "gf", ":e <cfile><Cr>", { silent = true, desc = "Better gf" })


--------------------
---- TABBY/TABS ----
--------------------
vim.keymap.set("n", "<leader><Tab>z", ":tcd ", { desc = "Tab Cd" })
vim.keymap.set("n", "<leader><Tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><Tab>c", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "]<Tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "[<Tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

---{{{ Tab
-- -- vim.keymap.set("n", "<leader>tL", "<cmd>tablast<cr>", { desc = "Last Tab" })
-- -- vim.keymap.set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
-- -- vim.keymap.set("n", "<leader>tF", "<cmd>tabfirst<cr>", { desc = "First Tab" })
-- -- vim.keymap.set("n", "<leader>tt", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- -- vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close Tab" })
-- -- vim.keymap.set("n", "<leader>t]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- -- vim.keymap.set("n", "<leader>t[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
--
-- -- vim.o.timeout = false
-- local tmux_prefix = "<A-p>"
-- local map = vim.keymap.set
-- local modes = { "n", "x", "i", "t" }
-- local term_insert_mode = "<Cmd>term<Cr><Cmd>start<Cr>"
--
-- map(modes, tmux_prefix .. "%", "<Cmd>split<Cr>" .. term_insert_mode, { desc = "Tmux Split" })
-- map(modes, tmux_prefix .. "\"", "<Cmd>vsplit<Cr>" .. term_insert_mode, { desc = "Tmux Vertical Split" })
-- map(modes, tmux_prefix .. "c", "<Cmd>tabnew<Cr>" .. term_insert_mode, { desc = "Tmux New Tab" })
-- map(modes, tmux_prefix .. "x", "<Cmd>close!<Cr>", { desc = "Tmux Close" })
-- map(modes, tmux_prefix .. "w", ":b term:h", { desc = "Tmux Switch Terminals" })
-- map(modes, tmux_prefix .. "[", "<C-\\><C-n>", { desc = "Tmux Copy Mode" })
--
-- for i = 1, 9, 1 do
--     map(modes, tmux_prefix .. i, "<Cmd>norm " .. i .. "gt<Cr>", { desc = "Tmux to tab " .. i })
--     vim.keymap.set("n", "<leader><tab>" .. i, "<Cmd>norm" .. i .. "gt<Cr>", { desc = "which_key_ignore" })
-- end
---}}}

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

vim.keymap.set("n", "<leader>gnc", function()
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

-- {{{ Find
-- -------------------------------------
-- ----- CUSTOM SEARCH FILES AND WORD --
-- -------------------------------------
-- ---local function GrepSearch()
-- ---  local input = vim.fn.input("Grep for > ")
-- ---  if input == "" then
-- ---    return
-- ---  end
-- ---  local cmd = string.format("grep -rnI --exclude-dir=.git --exclude-dir=node_modules --color=never '%s' .", input)
-- ---  local tmp = vim.fn.tempname()
-- ---  vim.fn.system(cmd .. " > " .. vim.fn.fnameescape(tmp))
-- ---  vim.cmd("cfile " .. tmp)
-- ---  vim.cmd("copen")
-- ---  os.remove(tmp)
-- ---end
-- ---vim.api.nvim_create_user_command("Grep", GrepSearch, {})
-- ---vim.keymap.set("n", "<leader>o/", ":Grep<CR>", { noremap = true, silent = true, desc = "Grep (Quickfix)" })
--
-- -- function FzfLike()
-- --   local handle = io.popen("find . -type f -not -path '*/.git/*'")
-- --   if not handle then
-- --     vim.notify("Erro ao executar 'find'", vim.log.levels.ERROR)
-- --     return
-- --   end
-- --   local files = {}
-- --   for file in handle:lines() do
-- --     table.insert(files, file)
-- --   end
-- --   handle:close()
-- --   vim.ui.input({ prompt = "Find for > " }, function(input)
-- --     if not input then
-- --       return
-- --     end
-- --     input = input:lower()
-- --     local filtered = {}
-- --     for _, file in ipairs(files) do
-- --       if file:lower():find(input, 1, true) then
-- --         table.insert(filtered, file)
-- --       end
-- --     end
-- --     local count = #filtered
-- --     if count == 0 then
-- --       vim.notify("No File Found.", vim.log.levels.INFO)
-- --       return
-- --     end
-- --     local qf_entries = {}
-- --     for _, file in ipairs(filtered) do
-- --       table.insert(qf_entries, { filename = file, lnum = 1, col = 1, text = file })
-- --     end
-- --     vim.fn.setqflist({}, " ", {
-- --       title = "FzfLike Results",
-- --       items = qf_entries,
-- --     })
-- --     if count == 1 then
-- --       vim.cmd("edit " .. filtered[1])
-- --     else
-- --       vim.cmd("edit " .. filtered[1])
-- --       vim.cmd("copen")
-- --     end
-- --   end)
-- -- end
-- -- vim.keymap.set("n", "<leader>of", FzfLike, { desc = "Fuzzy Find (Quickfix)" })
--
-- vim.keymap.set("n", "<leader>of", ":find ", { desc = "Find" })
-- vim.keymap.set("n", "<leader>og", ":grep ", { desc = "Grep" })
-- vim.keymap.set("n", "<leader>or", ":grep <cword><cr>:cope<Cr>", { desc = "Find Function/Decaration/References" })
-- vim.keymap.set("n", "<leader>o/", ":LiveGrep  %:h<left><left><left><left>") -- Custom Autocmd
-- }}}

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

-- vim.keymap.set("c", "w!!", "w !sudo tee > /dev/null %", { silent = true, desc = "Write as Sudo" })
