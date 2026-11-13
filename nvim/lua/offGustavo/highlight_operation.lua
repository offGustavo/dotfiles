-- TODO: remove when 0.13 become stable
if not is("nvim-0.13") then
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank({
        higroup = "DiffAdd", -- Highlight group to use
        timeout = 100, -- Time in milliseconds
      })
    end,
  })
end

vim.api.nvim_create_autocmd("TextPutPost", {
  -- desc = "Highlight yanked text with different colors based on register",
  -- group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    local reg = vim.v.event.regname
    if reg == "+" then
      -- Yank to system clipboard → orange highlight
      -- vim.highlight.on_yank({ higroup = "YankHighlightClipboard", timeout = 100 })
      vim.hl.hl_op({ higroup = "DiffAdd", timeout = 100 })
      -- elseif reg == "_" then
      -- 	-- Yank to system clipboard → orange highlight
      -- 	-- vim.highlight.on_yank({ higroup = "YankHighlightClipboard", timeout = 100 })
      -- 	vim.highlight.on_yank({ higroup = "ErrorMsg", timeout = 100 })
    else
      -- Any other yank (default register, "*", named registers, etc.) → cyan highlight
      -- vim.highlight.on_yank({ higroup = "YankHighlightNormal", timeout = 100 })
      vim.hl.hl_op({ higroup = "DiffAdd", timeout = 100 })
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text with different colors based on register",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    local reg = vim.v.event.regname
    if reg == "+" then
      -- Yank to system clipboard → orange highlight
      -- vim.highlight.on_yank({ higroup = "YankHighlightClipboard", timeout = 100 })
      vim.hl.hl_op({ higroup = "DiffAdd", timeout = 100 })
      -- elseif reg == "_" then
      -- 	-- Yank to system clipboard → orange highlight
      -- 	-- vim.highlight.on_yank({ higroup = "YankHighlightClipboard", timeout = 50 })
      -- 	vim.highlight.on_yank({ higroup = "ErrorMsg", timeout = 50 })
    else
      -- Any other yank (default register, "*", named registers, etc.) → cyan highlight
      -- vim.highlight.on_yank({ higroup = "YankHighlightNormal", timeout = 50 })
      vim.hl.hl_op({ higroup = "DiffAdd", timeout = 100 })
    end
  end,
})

local ns = vim.api.nvim_create_namespace("pre_delete_hl")

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight text about to be deleted",
  group = vim.api.nvim_create_augroup("PreDeleteHighlight", { clear = true }),
  callback = function()
    local ev = vim.v.event
    if ev.operator ~= "d" and ev.operator ~= "c" then
      return
    end
    local hl = ev.regname == "+" and "DiffAdd" or "DiffDelete"
    vim.hl.range(0, ns, hl, "'[", "']", {
      regtype = ev.regtype:sub(1, 1), -- blockwise comes as "\22{width}"
      inclusive = true,
    })
    vim.cmd.redraw() -- paint the highlight now
    vim.wait(50) -- keep it on screen before the delete happens
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  end,
})

-- local group = vim.api.nvim_create_augroup("HighlightOps", { clear = true })
-- local ns = vim.api.nvim_create_namespace("op_highlight")
-- local regtypes = { line = "V", char = "v", block = "\22" }
--
-- -- Delete: highlight first, then delete
-- local delete_reg = '"'
-- function _G.highlight_and_delete(motion_type)
--   local v = regtypes[motion_type]
--   vim.hl.range(0, ns, "DiffDelete", "'[", "']", {
--     regtype = v, inclusive = true, timeout = 150,
--   })
--   vim.cmd.redraw()
--   vim.wait(50) -- blocks briefly so the highlight is visible
--   vim.cmd(('normal! `[%s`]"%sd'):format(v, delete_reg))
-- end
--
-- vim.keymap.set("n", "d", function()
--   delete_reg = vim.v.register
--   vim.go.operatorfunc = "v:lua.highlight_and_delete"
--   return "g@"
-- end, { expr = true, silent = true })
--
-- vim.keymap.set("n", "dd", function()
--   delete_reg = vim.v.register
--   vim.go.operatorfunc = "v:lua.highlight_and_delete"
--   return "g@_"
-- end, { expr = true, silent = true })
