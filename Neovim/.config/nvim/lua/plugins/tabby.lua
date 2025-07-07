if vim.g.neovide then
  return {
    "nanozuki/tabby.nvim",
    enabled = false,
  }
else
  return {
    "nanozuki/tabby.nvim",
    config = function()
      -- vim.o.showtabline = 2
      local theme = {
        bg = "NormalNC",
        bg_alt = "lualine_b_normal",
        fg = "NormalNC",
        fill = "TabLineFill",
        -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
        head = "TabLine",
        current_tab = "TabLineSel",
        tab = "TabLine",
        win = "TabLine",
        tail = "TabLine",
      }
      require("tabby").setup({
        line = function(line)
          return {
            line.tabs().foreach(function(tab)
              local hl = tab.is_current() and theme.current_tab or theme.bg_alt
              return {
                line.sep("", theme.bg, hl),
                tab.number(),
                tab.name(),
                tab.close_btn(""),
                line.sep("", hl, theme.fill),
                hl = hl,
                margin = " ",
              }
            end),
            line.spacer(),
            line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
              return {
                win.is_current() and "" or "",
                win.buf_name(),
                hl = theme.fg,
                margin = " ",
                line.sep(" ", theme.bg, theme.fill),
              }
            end),
            hl = theme.fill,
          }
        end,
        -- option = {}, -- setup modules' option,
      })

      vim.api.nvim_set_keymap("n", "<leader><Tab>{", ":-tabmove<CR>", { desc = "Move Tab Left", noremap = true })
      vim.api.nvim_set_keymap("n", "<leader><Tab>}", ":+tabmove<CR>", { desc = "Move Tab Right ", noremap = true })
    end,
  }
end
