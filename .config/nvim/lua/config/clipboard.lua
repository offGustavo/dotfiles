vim.api.nvim_create_autocmd({ "VimEnter", "VimResume", "UIEnter" }, {
  group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
  callback = function()
    if vim.api.nvim_ui_send then
      vim.api.nvim_ui_send("\x1b]1337;SetUserVar=in_editor=MQo\007")
    else
      io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\007")
    end
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
  callback = function()
    if vim.api.nvim_ui_send then
      vim.api.nvim_ui_send("\x1b]1337;SetUserVar=in_editor=MQo\007")
    else
      io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
    end
  end,
})

-- vim.api.nvim_create_autocmd("TextYankPost", {
-- 	desc = "Highlight when yanking (copying) text",
-- 	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
-- 	callback = function()
-- 		vim.hl.on_yank()
-- 	end,
-- })

-- Define custom highlight groups (choose your own colors)
-- Example: Cyan for normal yanks, Orange for clipboard (+ register) yanks
vim.api.nvim_set_hl(0, "YankHlDefault", { fg = "cyan", bg = "" })
vim.api.nvim_set_hl(0, "YankHlSystem", { fg = "orange", bg = "" })
vim.api.nvim_set_hl(0, "YankHlBlackHole", { fg = "orange", bg = "" })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text with different colors based on register",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    local reg = vim.v.event.regname
    if reg == "+" then
      -- Yank to system clipboard → orange highlight
      -- vim.highlight.on_yank({ higroup = "YankHighlightClipboard", timeout = 150 })
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    -- elseif reg == "_" then
    -- 	-- Yank to system clipboard → orange highlight
    -- 	-- vim.highlight.on_yank({ higroup = "YankHighlightClipboard", timeout = 150 })
    -- 	vim.highlight.on_yank({ higroup = "ErrorMsg", timeout = 150 })
    else
      -- Any other yank (default register, "*", named registers, etc.) → cyan highlight
      -- vim.highlight.on_yank({ higroup = "YankHighlightNormal", timeout = 150 })
      vim.highlight.on_yank({ higroup = "Search", timeout = 150 })
    end
  end,
})

vim.keymap.set({ "n", "x" }, "<C-S-v>", '"+p')
vim.keymap.set({ "i" }, "<C-S-v>", "<C-r>+")
vim.keymap.set({ "n", "x" }, "<C-S-c>", '"+y')
vim.keymap.set({ "n", "x" }, "<C-S-x>", '"+d')

vim.keymap.set({ "n", "x" }, "<S-Insert>", '"+p')
vim.keymap.set({ "i" }, "<S-Insert>", "<C-r>+")
vim.keymap.set({ "n", "x" }, "<C-Insert>", '"+y')
vim.keymap.set({ "n", "x" }, "<S-Del>", '"+d')

vim.keymap.set({ "n", "x" }, "<leader>+", '"+', { desc = "System clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>_", '"_', { desc = "Black Hole Register" })

-- -- FIXME: remove some keybinds
-- -- free <leader>p
-- vim.keymap.set({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from system register" })
-- vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to system register" })
-- vim.keymap.set({ "n", "x" }, "<leader>x", '"+d', { desc = "Cut to system register" })
