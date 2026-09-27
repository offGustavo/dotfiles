vim.schedule(function()
  vim.lsp.config("*", {
    capabilities = {
      textDocument = {
        semanticTokens = { multilineTokenSupport = true },
      },
    },
    root_markers = {
      ".git",
    },
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      Fish.did_lsp_setup = true

      vim.diagnostic.config({
        virtual_lines = false,
        virtual_text = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰐼",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
        -- :help vim.diagnostic.Opts.Status  (Neovim 0.12+)
        status = {
          format = function(counts)
            local sign_text = vim.diagnostic.config().signs.text
            local hls = {
              [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
              [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
              [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
              [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
            }
            local parts = {}
            for severity in ipairs(vim.diagnostic.severity) do
              local count = counts[severity]
              if count then
                parts[#parts + 1] = ("%%#%s#%s %d%%##"):format(hls[severity], sign_text[severity], count)
              end
            end
            return table.concat(parts, " ")
          end,
        },
      }) -- Diagnostics

      local client = vim.lsp.get_client_by_id(ev.data.client_id)

      -- -- Disable LSP Highlight
      -- if client and client.server_capabilities then
      --   client.server_capabilities.semanticTokensProvider = nil
      -- end

      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
      end

      -- Diagnostic keymaps
      map({
        {
          "<leader>ca",
          function()
            vim.lsp.buf.code_action()
          end,
          desc = "Code Action",
          buf = ev.buf,
        },
        {
          "<leader>cd",
          function()
            vim.lsp.buf.definition()
          end,
          desc = "Open Definition",
          buf = ev.buf,
        },
        {
          "<leader>cr",
          function()
            vim.lsp.buf.references()
          end,
          desc = "Open References",
          buf = ev.buf,
        },
        {
          "<leader>cR",
          function()
            vim.lsp.buf.rename()
          end,
          desc = "Lsp Rename",
          buf = ev.buf,
        },
        {
          "<leader>cF",
          function()
            vim.lsp.buf.format()
          end,
          desc = "Lsp Code Format",
          buf = ev.buf,
        },
        {
          "<leader>cq",
          function()
            vim.diagnostic.setqflist()
          end,
          desc = "Open Diagnostics Quickfix list",
          buf = ev.buf,
        },
        { "<leader>ce", vim.diagnostic.open_float, desc = "Line Diagnostics Error", buf = ev.buf },
        { "<leader>K", vim.lsp.buf.hover, desc = "Go to lsp help", buf = ev.buf },
        { "<S-space>K", vim.lsp.buf.hover, desc = "Go to lsp help", buf = ev.buf },
        { "<leader>ch", vim.lsp.buf.hover, desc = "Line Diagnostics Error", buf = ev.buf },
      })

      -- NOTE: Remove lsp-default mappings
      pcall(function()
        vim.cmd([[
        nnoremap <nowait> gr gr
        nnoremap <nowait> gd gd
        nnoremap <nowait> K K
        " unamp gd
        ]])
        vim.keymap.del("n", "gd", { buf = ev.buf })
        vim.keymap.del("n", "K", { buf = ev.buf })
      end)
    end,
  })
end)
