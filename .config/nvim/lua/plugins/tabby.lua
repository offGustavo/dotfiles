return {
  "nanozuki/tabby.nvim",
  enabled = true,
  config = function()
    -- vim.o.showtabline = 2
    local theme = {
      bg = "NormalNC",
      bg_alt = "lualine_b_normal",
      fg = "NormalNC",
      fill = "TabLineFill",
      -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
      head = "TabLine",
      current_tab = "lualine_a_normal",
      tab = "TabLine",
      win = "TabLine",
      tail = "TabLine",
    }

    -- return {
    --   line.sep("", theme.bg, hl),
    --   tab.number(),
    --   tab.name(),
    --   tab.close_btn(""),
    --   line.sep("", hl, theme.fill),
    --   hl = hl,
    --   margin = " ",
    -- }
    require("tabby").setup({
      line = function(line)
        return {
          "%=", 
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.bg
            return {
              line.sep(" ", hl, theme.bg),
              tab.number(),
              tab.name(),
              tab.close_btn(""),
              line.sep(" ", hl, theme.bg),
              hl = hl,
              margin = " ",
            }
          end),
          line.spacer(),
          -- line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
          --   return {
          --     win.is_current() and "" or "",
          --     win.buf_name(),
          --     hl = theme.fg,
          --     margin = " ",
          --     line.sep(" ", theme.bg, theme.fill),
          --   }
          -- end),
          -- hl = theme.fill,
        }
      end,
      -- option = {}, -- setup modules' option,
    })

    vim.keymap.set("n", "<leader><Tab>r", ":TabRename ", { desc = "Rename Tab" })
    vim.keymap.set("n", "<leader><Tab>{", "<Cmd>-tabmove<Cr>", { desc = "Move Tab Left" })
    vim.keymap.set("n", "<leader><Tab>}", "<Cmd>+tabmove<Cr>", { desc = "Move Tab Right" })
    vim.keymap.set("n", "<leader><Tab>p", "<Cmd>Tabby pick_window<Cr>", { desc = "Pick Windows" })
  end,
}
