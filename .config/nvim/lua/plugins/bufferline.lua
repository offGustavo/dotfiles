if vim.g.neovide then
  return {
    "akinsho/bufferline.nvim",
    enabled = false,
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<Cr>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<Cr>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bh", "<Cmd>BufferLineCloseRight<Cr>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<Cr>", desc = "Delete Buffers to the Left" },
      -- { "<S-h>", "<cmd>BufferLineCyclePrev<Cr>", desc = "Prev Buffer" },
      -- { "<S-l>", "<cmd>BufferLineCycleNext<Cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<Cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<Cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<Cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<Cr>", desc = "Move buffer next" },
      -- { "<leader>fp", "<Cmd>BufferLinePick<Cr>", desc = "Buffer Picker" },
    },
    opts = {
      options = {
        -- numbers = "ordinal",
        numbers = "buffer_id",
      -- stylua: ignore
      close_command = function(n) Snacks.bufdelete(n) end,
      -- stylua: ignore
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = LazyVim.config.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "snacks_layout_box",
          },
        },
        ---@param opts bufferline.IconFetcherOpts
        get_element_icon = function(opts)
          return LazyVim.config.icons.ft[opts.filetype]
        end,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
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
      --       require("which-key").add({
      --         { "<C-" .. k .. ">", hidden = true }, -- hide this keymap
      --       })
      --     end
      --   end,
      -- })

      -- End config
    end,
  }
else
  return {
    "akinsho/bufferline.nvim",
    enabled = false,
  }
end
