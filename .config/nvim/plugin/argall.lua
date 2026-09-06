vim.g.argall = {
  save_local = {
    enable = false,
    file_name = ".args",
  },
  autocmd = true,
}

if not vim.g.argall.autocmd then
  return
end

local augroup = vim.api.nvim_create_augroup("ForgeArglist", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter", "SessionLoadPost" }, {
  group = augroup,
  once = true,
  callback = function()
    require("fish.argall").load()
  end,
  desc = "Auto-load aarguments from session",
})

vim.api.nvim_create_autocmd({ "VimLeavePre", "SessionWritePre" }, {
  group = augroup,
  once = true,
  callback = function()
    require("fish.argall").save()
  end,
  desc = "Auto-save arguments to session",
})

-- TODO: decidir se vou usar isso
-- -- Auto-save the argall buffer whenever it's left or closed
-- vim.api.nvim_create_autocmd("FileType", {
--   group = augroup,
--   pattern = "argall",
--   callback = function(ev)
--     vim.api.nvim_create_autocmd({ "BufWinLeave", "BufDelete" }, {
--       group = augroup,
--       buffer = ev.buf,
--       callback = function()
--         vim.cmd "silent! write"
--       end,
--     })
--   end,
-- })
