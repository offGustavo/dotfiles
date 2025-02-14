-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.conceallevel = 3
  end,
})

-- vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
--   group = vim.api.nvim_create_augroup("test_buffers", {}),
--   desc = "test buffers",
--   callback = function()
--     local buffers = {}
--     for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--       if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
--         table.insert(buffers, buf)
--       end
--     end
--     for k, v in ipairs(buffers) do
--       vim.keymap.set("n", "<C-" .. k .. ">", "<cmd>buffer " .. v .. "<cr>")
--       -- vim.keymap.set("n", "<leader>" .. k, "<cmd>buffer " .. v .. "<cr>", { desc = "Switch do Buffer " .. k })
--       require("which-key").add({
--         { "<C-" .. k .. ">", hidden = true }, -- hide this keymap
--       })
--     end
--   end,
-- })
