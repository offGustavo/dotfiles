-- lsp
--------------------------------------------------------------------------------
-- See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
-- of how the lsp setup works in neovim 0.11+.
-- This actually just enables the lsp servers.
-- The configuration is found in the lsp folder inside the nvim config folder,
-- so in ~.config/lsp/lua_ls.lua for lua_ls, for example.

if true then return {} end
return {
  "https://github.com/neovim/nvim-lspconfig",
  lazy = true,
  event = "VeryLazy",
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        -- Diagnostics
        vim.diagnostic.config({
          -- Use the default configuration
          virtual_lines = false,
          virtual_text = true,
          -- signs = {
          --   text = {
          --     [vim.diagnostic.severity.ERROR] = "󰐼",
          --     [vim.diagnostic.severity.WARN] = "",
          --     [vim.diagnostic.severity.INFO] = "",
          --     [vim.diagnostic.severity.HINT] = "",
          --   }
          -- }
        })
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
          vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
          vim.keymap.set("n", "<leader>ca", function()
            vim.lsp.buf.code_action()
          end, { desc = "Code Action" })
          vim.keymap.set("n", "<leader>cd", function()
            vim.lsp.buf.definition()
          end, { desc = "Open Definition" })
          vim.keymap.set("n", "<leader>cr", function()
            vim.lsp.buf.references()
          end, { desc = "Open References" })
          vim.keymap.set("n", "<leader>cR", function()
            vim.lsp.buf.rename()
          end, { desc = "Lsp Rename" })
          vim.keymap.set("n", "<leader>cF", function()
            vim.lsp.buf.format()
          end, { desc = "Lsp Code Format" })
          vim.keymap.set("n", "<leader>cq", function()
            vim.diagnostic.setqflist()
          end, { desc = "Open Diagnostics Quickfix list" })
          -- Diagnostic keymaps
          vim.keymap.set("n", "<leader>ce", vim.diagnostic.open_float, { desc = "Line Diagnostics [E]rror" })
        end
      end,
    })
  end,
}
