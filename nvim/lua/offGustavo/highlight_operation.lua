-- TODO: remove when 0.13 become stable
if not is("nvim-0.13") then
  return
end

vim.api.nvim_create_autocmd({ "UiEnter", "ColorScheme" }, {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "HighlightYank", { bg = vim.api.nvim_get_hl(0, { name = "DiffText" }).bg })
    vim.api.nvim_set_hl(0, "HighlightYankSystem", { bg = vim.api.nvim_get_hl(0, { name = "DiffAdd" }).bg })
    vim.api.nvim_set_hl(0, "HighlightCut", { bg = vim.api.nvim_get_hl(0, { name = "DiffDelete" }).bg })
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost", "TextPutPost" }, {
  desc = "Highlight yanked or pasted text with different colors based on register",
  group = fish_group,
  callback = function()
    local hl = vim.v.event.regname == "+" and "HighlightYankSystem" or "HighlightYank"
    vim.hl.hl_op({ higroup = hl, timeout = 200 })
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
    local hl = ev.regname == "+" and "HighlightYankSystem" or "HighlightCut"
    vim.hl.range(0, ns, hl, "'[", "']", {
      regtype = ev.regtype:sub(1, 1), -- blockwise comes as "\22{width}"
      inclusive = true,
    })
    vim.cmd.redraw() -- paint the highlight now
    vim.wait(67) -- keep it on screen before the delete happens
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  end,
})
