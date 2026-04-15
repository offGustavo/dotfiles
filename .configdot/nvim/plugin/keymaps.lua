-- vim: foldmethod=marker

vim.keymap.set("n", "<C-Down>", "}", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Up>",   "{", { noremap = true, silent = true })

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("n", "<leader>qo", vim.cmd.copen, { desc = "QuickFix Open", silent = true })
vim.keymap.set("n", "<leader>qc", vim.cmd.cclose, { desc = "QuickFix Close", silent = true })

vim.keymap.set("n", "<leader>qq", vim.cmd.quit, { desc = "Quit", silent = true })
vim.keymap.set("n", "<leader>qQ", ":qa!<Cr>", { desc = "Force Quit All", silent = true })
vim.keymap.set("n", "ZR", vim.cmd.restart, { desc = "Restart", silent = true })

vim.keymap.set("n", "<leader>fC", ":e $MYVIMRC<Cr>", { silent = true, desc = "Edit the Init.lua file" })
vim.keymap.set("n", "<leader>fD", ":e $MYVIMDIR<Cr>", { silent = true, desc = "Edit the Init.lua file" })
vim.keymap.set("n", "<leader>fn", ":enew<Cr>", { silent = true, desc = "Edit the Init.lua file" })

vim.keymap.set("n", "<leader>bb", ":b #<Cr>", { desc = "Alternative Buffer" })
vim.keymap.set("n", "<M-a>", ":b #<Cr>", { desc = "Alternative Buffer" })
vim.keymap.set("n", "<leader>bd", ":bd<Cr>", { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bD", ":bufdo bd<Cr>", { desc = "Delete All Buffers" })

vim.keymap.set( "n", "s/", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute Current Word Globally" })
vim.keymap.set("n", "s.", [[:s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute Current Word" })
vim.keymap.set("n", "sf", ":s/", { desc = "Substitute in Line" })
vim.keymap.set("n", "sg", ":%s/", { desc = "Substitute in all file" })
vim.keymap.set("n", "SG", ":%s/", { desc = "Substitute in all file" })
vim.keymap.set("x", "S", ":s/", { desc = "Substitute in selection" })
vim.keymap.set("x", "sg", [[:s//gI<Left><Left><Left>]], { desc = "Substitute Global" })

vim.cmd([[
   nmap <C-BS> <C-w>
]])

vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "U", require("undotree").open)

vim.keymap.set("n", "<M-d>", ":t.<cr>")
vim.keymap.set("x", "<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "<C-k>", ":m '<-2<CR>gv=gv")

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
vim.keymap.set({ "x", "n", "i", "t" }, "<M-S-j>", function()
	vim.cmd.wincmd("w")
end)
vim.keymap.set({ "x", "n", "i", "t" }, "<M-S-k>", function()
	vim.cmd.wincmd("W")
end)
vim.keymap.set({ "x", "n", "i", "t" }, "<M-S-s>", function()
	vim.cmd.wincmd("s")
end)
vim.keymap.set({ "x", "n", "i", "t" }, "<M-S-v>", function()
	vim.cmd.wincmd("v")
end)
vim.keymap.set({ "x", "n", "i", "t" }, "<M-S-o>", function()
	vim.cmd.wincmd("o")
end)
vim.keymap.set("n", "<M-=>", function()
	vim.cmd.wincmd("=")
end, { desc = "Windows" })
vim.keymap.set("n", "<M-S-=>", function()
	vim.cmd.wincmd("+")
end, { desc = "Windows" })
vim.keymap.set("n", "<M-->", function()
	vim.cmd.wincmd("-")
end, { desc = "Windows" })
vim.keymap.set("n", "<M-S-,>", function()
	vim.cmd.wincmd("<")
end, { desc = "Windows" })
vim.keymap.set("n", "<M-S-.>", function()
	vim.cmd.wincmd(">")
end, { desc = "Windows" })

--- }}}

--{{{ -- Terminal
vim.keymap.set({ "i", "c", "n", "v", "x" }, "<C-c>", "<Esc>", { desc = "Fix <C-c>", silent = true })
vim.keymap.set("t", "<M-;>", "<C-\\><C-n>", { silent = true, desc = "Go To Normal Mode in Terminal", nowait = true })
vim.keymap.set("t", "<S-Esc>", "<C-\\><C-n>", { silent = true, desc = "Go To Normal Mode in Terminal", nowait = true })
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { silent = true, desc = 'Go To Normal Mode in Terminal', nowait = true })
vim.keymap.set("n", "<M-t>", ":term ")
vim.keymap.set("n", "<leader>tn", ":term ")
vim.keymap.set('n', '<leader>th', ':hor term ')
vim.keymap.set('n', '<leader>tv', ':vert term ')
vim.keymap.set('n', '<leader>tg', ':hor term rg ')

-- Copy Entire Buffer
vim.keymap.set("n", "gA", "<Cmd>%y +<Cr>", { silent = true, desc = "Yank entire file to System" })
vim.keymap.set("n", "g<M-a>", "<Cmd>%y<Cr>", { silent = true, desc = "Yank entire file" })

-- Normal mode in command line
vim.keymap.set("n", "<leader>;", ":<c-f>", { silent = true, desc = "Vi Command Mode" })

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
	vim.keymap.set(
		"n",
		"<leader>q" .. i,
		"<Cmd>chistory " .. i .. "<Cr>",
		{ silent = true, desc = "Go to " .. i .. " Quickfix" }
	)
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
---{{{ Tab
vim.keymap.set("n", "<leader><Tab>z", ":tcd ", { desc = "Tab Cd" })
vim.keymap.set("n", "<leader><Tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><Tab><Tav>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><Tab>c", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><Tab>L", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><Tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader><Tab>F", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "]<Tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "[<Tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

--- Scroll
vim.cmd([[
 nmap  <S-ScrollWheelUp> zh
 nmap  <S-ScrollWheelDown> zl
 ]])

---------------
-- OBSIDIAN ---
---------------
vim.keymap.set("n", "<leader>ad", function()
	local current_date = os.date("%Y-%m-%d")
	local daily_note_date = "~/Notes/DailyNotes/" .. current_date .. ".md"
	vim.cmd("e " .. daily_note_date)
end, { desc = "Today's Daily Note" })

vim.keymap.set("n", "<leader>gcc", function()
	local current_date_and_time = os.date("%Y-%m-%d %H:%M:%S")
	local commit_date = "vault backup: " .. current_date_and_time
	vim.cmd('!git add ~/Notes && git commit -m "' .. commit_date .. '"')
	print("Commit: " .. commit_date)
end, { desc = "Commit All Changes From Vault" })

vim.keymap.set("n", "<leader>gcp", function()
	vim.cmd("!git pull")
	print("Pull Changes")
end, { desc = "Pull Changes" })

vim.keymap.set("n", "<leader>gcP", function()
	vim.cmd("!git push")
	print("Push Changes")
end, { desc = "Push Changes" })

----------
-- Make --
----------
vim.keymap.set("n", "<leader>cm", ":make ", { desc = "Make", remap = true })
vim.keymap.set("n", "<leader>cM", "<Cmd>make<CR>", { desc = "Run Make" })

vim.keymap.set("n", "gX", function()
	local file = vim.fn.expand("%:p")
	if file ~= "" then
		vim.ui.open(file)
	else
		vim.notify("No file to open", vim.log.levels.WARN)
	end
end, { desc = "Open current file" })


-- vim.keymap.set("c", "w!!", "w !sudo tee > /dev/null %", { silent = true, desc = "Write as Sudo" })
