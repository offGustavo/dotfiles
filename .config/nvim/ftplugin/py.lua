vim.keymap.set("n", "<localleader>r", "<Cmd>!python %<Cr>", { silent = true, desc = "Execute File with Python", buffer = true })
vim.keymap.set("n", "<localleader>R", "<Cmd>term python %<Cr>", { silent = true, desc = "Execute File with Python", buffer = true })

vim.opt_local.shiftwidth = 4       -- Size of an indent
vim.opt_local.tabstop = 4          -- Number of spaces tabs count for
vim.opt_local.softtabstop = 4      -- Number of spaces tabs count for in insert mode
vim.opt_local.expandtab = true     -- Convert tabs to spaces
vim.opt_local.autoindent = true    -- Copy indent from current line

-- Specific listchars for Python to easily spot spacing issues
vim.opt_local.list = true
vim.opt_local.listchars = {
  tab = '» ',                      -- Visual indicator for tabs
  trail = '·',                     -- Visual indicator for trailing spaces
  extends = '⟩',                   -- Character shown when line is too long
  precedes = '⟨',
  nbsp = '␣',                      -- Non-breaking space
}
