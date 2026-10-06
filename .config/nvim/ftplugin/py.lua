map {
  { "n", "<localleader>r", "<Cmd>!python %<Cr>",  silent = true, desc = "Execute File with Python", buffer = true },
  { "n", "<localleader>R", "<Cmd>term python %<Cr>",  silent = true, desc = "Execute File with Python", buffer = true },
}

set_local {
  shiftwidth = 4,       -- Size of an indent
  tabstop = 4,          -- Number of spaces tabs count for
  softtabstop = 4,      -- Number of spaces tabs count for in insert mode
  expandtab = true,     -- Convert tabs to spaces
  autoindent = true,    -- Copy indent from current line
  list = true,
}

-- -- Specific listchars for Python to easily spot spacing issues
-- vim.opt_local.listchars = {
--   tab = '» ',                      -- Visual indicator for tabs
--   trail = '·',                     -- Visual indicator for trailing spaces
--   extends = '⟩',                   -- Character shown when line is too long
--   precedes = '⟨',
--   nbsp = '␣',                      -- Non-breaking space
-- }
