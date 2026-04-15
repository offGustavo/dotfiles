return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    -- vim.o.laststatus = 1
    vim.o.laststatus = 3
  end,
  config = function()
    local lualine = require("lualine")

    -- This enables automatic theme detection and updates
    local lazy_status = require("lazy.status") -- Optional: if using lazy.nvim

    lualine.setup({
      options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = {
          {
            function()
              return "▊"
            end,
            -- color = { fg = "blue" },
            padding = { left = 0, right = 1 },
          },
          {
            function()
              return ""
              -- return ""
            end,
            -- color = function()
            --   local mode_color = {
            --     n = "red",
            --     i = "green",
            --     v = "blue",
            --     [""] = "blue",
            --     V = "blue",
            --     c = "magenta",
            --     no = "red",
            --     s = "orange",
            --     S = "orange",
            --     [""] = "orange",
            --     ic = "yellow",
            --     R = "violet",
            --     Rv = "violet",
            --     cv = "red",
            --     ce = "red",
            --     r = "cyan",
            --     rm = "cyan",
            --     ["r?"] = "cyan",
            --     ["!"] = "red",
            --     t = "red",
            --   }
            --   return { fg = mode_color[vim.fn.mode()] }
            -- end,
            padding = { right = 1 },
          },
        },
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            file_status = true,
            newfile_status = false,
            path = 4,
            -- shorting_target = 20,
            symbols = {
              modified = "[+]",
              readonly = "[-]",
              unnamed = "[No Name]",
              newfile = "[*]",
            },
          },
          "filesize",
          "location",
          "progress",
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
            colored = true,
            update_in_insert = false,
            always_visible = false,
          },
          --
          -- "%=",
          -- "tabs",
          -- "%=",
        },
        lualine_x = {
          {
            "branch",
            -- icon = "",
            icon = "",
          },
          "diff",
          {
            function()
              local msg = ""
              -- local msg = "No Active Lsp"
              local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
              local clients = vim.lsp.get_clients()
              if next(clients) == nil then
                return msg
              end
              for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                  return client.name
                end
              end
              return msg
            end,
            -- icon = " LSP:",
            -- color = { fg = "white", gui = "bold" },
          },
          "encoding",
          {
            "fileformat",
            symbols = {
              unix = "UNIX", -- e712
              dos = "DOS", -- e70f
              mac = "MAC", -- e711
            },
          },
        },
        lualine_y = {},
        lualine_z = {
          {
            function()
              return "▊"
            end,
            -- color = { fg = "blue" },
            padding = { left = 1 },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {
        -- lualine_a = {
        --   "tabs"
        -- },
        -- lualine_y = {
        --   "windows"
        -- }
      },
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })

    -- vim.cmd("set showtabline=1")
    vim.o.laststatus = 3
  end,
}
