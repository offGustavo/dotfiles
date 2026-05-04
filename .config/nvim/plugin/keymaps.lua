-- vim: foldmethod=marker:foldlevel=0

--- {{{ Nvim
--- }}}

-- Edit init.lua/init.vim/vimrc
vim.keymap.set("n", "<leader>fC", ":e $MYVIMRC<Cr>", { silent = true, desc = "Edit the init config file" })

-- Fix <C-c> to work like <Esc>
vim.keymap.set("i", "<C-c>", "<Esc>")

--- Better Go to file
vim.keymap.set("n", "gf", ":e <cfile><Cr>", { silent = true, desc = "Better gf" })

-- Better gX(go to file externally)
vim.keymap.set("n", "gX", function()
	local file = vim.fn.expand("%:p")
	if file ~= "" then
		vim.ui.open(file)
	else
		vim.notify("no file to open", vim.log.levels.WARN)
	end
end, { silent = true, desc = "Open current file" })

-- {{{ Better walking between wrap lines
-- Use <Down> and <Up> to get the default behavior
vim.keymap.set("n", "j", "gj", { silent = true })
vim.keymap.set("n", "k", "gk", { silent = true })
--- }}}

-- Comment Line/Selection
vim.cmd([[
 nmap  <C-/> gcc
 xmap  <C-/> :norm gcc<Cr>
]])

--- Scroll
vim.cmd([[
  nmap  <S-ScrollWheelUp> zh
  nmap  <S-ScrollWheelDown> zl
]])

-- -- Normal mode in command line
-- vim.keymap.set("n", "<leader>;", ":<c-f>", { silent = true, desc = "Vi Command Mode" })

-- Builtin Now
---vim.keymap.set("n", "ZR", vim.cmd.restart, { desc = "Restart Session", silent = true })

-- File
vim.keymap.set("n", "<leader>fn", ":enew<Cr>", { silent = true, desc = "New File" })

-- {{{ Buffer
vim.keymap.set("n", "<leader>ba", ":b #<Cr>", { desc = "Alternative Buffer" })
vim.keymap.set("n", "<leader>bd", ":bd<Cr>", { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bD", ":bufdo bd<Cr>", { desc = "Delete All Buffers" })
-- }}}

-- {{{ Substitute
-- ThePrimeagen Keymaps
vim.keymap.set({ "x", "n" }, "s.", [[:s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], { silent = false })
vim.keymap.set({ "x", "n" }, "S>", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], { silent = false })
vim.keymap.set({ "x", "n" }, "sg", ":%s/", { silent = false })
vim.keymap.set({ "x", "n" }, "SG", ":%s//gI<Left><Left><Left>", { silent = false })
vim.keymap.set({ "x", "n" }, "ss", ":s/", { silent = false })
vim.keymap.set({ "x", "n" }, "SS", [[:s//gI<Left><Left><Left>]], { silent = false })
vim.keymap.set("n", "SV", [[S<Esc>]], { silent = false })
vim.keymap.set("x", "SV", [[:normal S<Esc>]], { silent = false })
-- }}}

-- Insert
vim.keymap.set("i", "<C-Bs>", "<C-w>")

-- {{{ Copy/Move
vim.keymap.set("n", "<M-d>", ":t.<cr>")
vim.keymap.set("x", "<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "<C-k>", ":m '<-2<CR>gv=gv")
-- }}}

--{{{ Terminal
vim.keymap.set({ "i", "c", "n", "v", "x" }, "<C-c>", "<Esc>", { desc = "Fix <C-c>", silent = true })
vim.keymap.set("t", "<M-;>", "<C-\\><C-n>", { silent = true, desc = "Go To Normal Mode in Terminal", nowait = true })
vim.keymap.set("t", "<S-Esc>", "<C-\\><C-n>", { silent = true, desc = "Go To Normal Mode in Terminal", nowait = true })
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { silent = true, desc = 'Go To Normal Mode in Terminal', nowait = true })
vim.keymap.set("n", "<M-t>", ":term ")
vim.keymap.set("n", "<leader>tn", ":term ")
vim.keymap.set("n", "<leader>th", ":hor term ")
vim.keymap.set("n", "<leader>tv", ":vert term ")
vim.keymap.set("n", "<leader>tg", ":hor term rg ")
--- }}}

-- {{{ LocList
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
--- }}}

-- {{{ Quickfix
vim.keymap.set("n", "<leader>qn", "<Cmd>cnext<Cr>", { silent = true, desc = "Open Next in Quickfix List" })
vim.keymap.set("n", "<leader>qp", "<Cmd>cprev<Cr>", { silent = true, desc = "Open Previous in Quickfix List" })

-- vim.keymap.set("n", "<leader>qo", vim.cmd.copen, { desc = "QuickFix Open", silent = true })
-- vim.keymap.set("n", "<leader>qc", vim.cmd.cclose, { desc = "QuickFix Close", silent = true })

vim.keymap.set("n", "<leader>qo", "<Cmd>copen<Cr>", { silent = true, desc = "Open Quickfix List" })
vim.keymap.set("n", "<leader>qc", "<Cmd>cclose<Cr>", { silent = true, desc = "Close Quickfix List" })
vim.keymap.set("n", "<leader>qh", "<Cmd>chistory<Cr>", { silent = true, desc = "List Quick Fix History" })
vim.keymap.set("n", "<leader>qn", "<Cmd>cnewer<Cr>", { silent = true, desc = "Next Quickfix List" })
vim.keymap.set("n", "<leader>qp", "<Cmd>colder<Cr>", { silent = true, desc = "Previous Quickfix List" })
for i = 1, 9 do
	vim.keymap.set(
		"n",
		"<leader>q" .. i,
		"<Cmd>chistory " .. i .. "<Cr>",
		{ silent = true, desc = "Go to " .. i .. " Quickfix" }
	)
end
-- }}}

-- {{{ Obsidian
vim.keymap.set("n", "<leader>ad", function()
	local current_date = os.date("%Y-%m-%d")
	local daily_note_date = "~/Notes/DailyNotes/" .. current_date .. ".md"
	vim.cmd("e " .. daily_note_date)
end, { desc = "Today's Daily Note" })

-- TODO: change this keymaps
vim.keymap.set("n", "<leader>ag", function()
	local current_date_and_time = os.date("%Y-%m-%d %H:%M:%S")
	local commit_date = "vault backup: " .. current_date_and_time
	vim.cmd('!git add ~/Notes && git commit -m "' .. commit_date .. '"')
	print("Commit: " .. commit_date)
end, { desc = "Commit All Changes From Vault" })
-- }}}

vim.keymap.set("n", "<leader>gcp", function()
	vim.cmd("!git pull")
	print("Pull Changes")
end, { desc = "Pull Changes" })

vim.keymap.set("n", "<leader>gcP", function()
	vim.cmd("!git push")
	print("Push Changes")
end, { desc = "Push Changes" })
--- }}}

-- {{{ Make
vim.keymap.set("n", "<leader>cm", ":make ", { desc = "Make", remap = true })
vim.keymap.set("n", "<leader>cM", "<Cmd>make<CR>", { desc = "Run Make" })
-- }}}

-- FIXME: try to fix this
-- vim.keymap.set("c", "w!!", "w !sudo tee > /dev/null %", { silent = true, desc = "Write as Sudo" })
