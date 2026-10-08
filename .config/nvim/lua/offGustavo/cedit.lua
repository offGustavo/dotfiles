local M = {}

local augroup = vim.api.nvim_create_augroup("CeditCloser", { clear = true })

local function setup_cmdwin()
  vim.api.nvim_create_autocmd("CmdwinEnter", {
    group = augroup,
    desc = "Configure the command-line window",
    callback = function(ev)
      local win = vim.api.nvim_get_current_win()
      local char = vim.fn.getcmdwintype() -- ":", "/" or "?"

      -- Show the cmdwin type char in the left gutter on every line
      vim.wo[win].statuscolumn = "%#PreProc#" .. char .. " "
      vim.wo[win].number = false
      vim.wo[win].relativenumber = false
      vim.wo[win].signcolumn = "no"

      -- <Esc> closes the window (normal mode only)
      vim.keymap.set("n", "<Esc>", "<Cmd>close<CR>", {
        buffer = ev.buf,
        silent = true,
        desc = "Close command-line window",
      })

      vim.cmd("resize 1")
    end,
  })
end

function M.open_and_bind()
  -- Don't try to open a cmdwin from inside one
  if vim.fn.getcmdwintype() ~= "" then
    return
  end
  vim.cmd("normal! q:")
  vim.cmd("startinsert!")
end

function M.setup(opts)
  opts = opts or {}
  local key = opts.key or "<M-x>"

  setup_cmdwin()

  vim.keymap.set("n", key, M.open_and_bind, {
    silent = true,
    desc = "Open command-line window with Esc closer",
  })
end

return M

-- Usage in init.lua:
-- require('cedit_closer').setup({ key = '<M-x>' })
