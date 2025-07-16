return {
  dir = "~/Projects/TabTerm.nvim/",
  config = function()
    require("TabTerm").setup()
    -- require('tabterminal').setup({
    --     separator = "",  -- Outro símbolo triangular
    --     separator_highlight = "%#MyHighlightGroup#",  -- Grupo de highlight personalizado
    --     default_highlight = "%#Normal#"  -- Cor para abas não selecionadas
    -- })

    vim.keymap.set({ "n", "i", "t" }, "<A-n>", function()
      require("TabTerm").new_terminal()
    end, { desc = "Novo Terminal" })

    vim.keymap.set({ "n", "i", "t" }, "<A-m>c", function()
      require("TabTerm").new_terminal()
    end, { desc = "Novo Terminal" })

    vim.keymap.set({ "n", "i", "t" }, "<A-/>", function()
      require("TabTerm").toggle_terminal_window()
    end)

    vim.keymap.set({ "n", "i", "t" }, "<A-m>d", function()
      require("TabTerm").toggle_terminal_window()
    end)

    vim.keymap.set({ "n", "i", "t" }, "<A-x>", function()
      require("TabTerm").close_terminal()
    end)

    vim.keymap.set({ "n", "i", "t" }, "<A-m>x", function()
      require("TabTerm").close_terminal()
    end)

    vim.keymap.set({ "n", "i", "t" }, "<A-m>,", ":TabTermRename<CR>")

    vim.keymap.set({ "n", "i", "t" }, "<A-,>", function()
      TabTerminal.rename_terminal()
    end)

    for i = 1, 10, 1 do
      vim.keymap.set({ "n", "i", "t" }, "<A-m>" .. i, function()
        require("TabTerm").goto_terminal(i)
      end, { desc = "Go to Terminal " .. i .. "" })
      vim.keymap.set({ "n", "i", "t" }, "<A-" .. i .. ">", function()
        require("TabTerm").goto_terminal(i)
      end, { desc = "Go to Terminal " .. i .. "" })
    end
  end,
}
