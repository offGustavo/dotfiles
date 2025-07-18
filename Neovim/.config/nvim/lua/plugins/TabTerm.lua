 return {
  dir = "~/Projects/TabTerm.nvim/",
  config = function()
    -- require("TabTerm").setup()
    require("TabTerm").setup({
      -- separator = "",
    })

    vim.keymap.set({ "n", "i", "t" }, "<A-n>", function()
      require("TabTerm").new()
    end, { desc = "Novo Terminal" })

    vim.keymap.set({ "n", "i", "t" }, "<A-m>c", function()
      require("TabTerm").new()
    end, { desc = "New Terminal" })

    vim.keymap.set({ "n", "i", "t" }, "<A-/>", function()
      require("TabTerm").toggle()
    end)

    vim.keymap.set({ "n", "i", "t" }, "<A-m>d", function()
      require("TabTerm").toggle()
    end, { desc = "Detach/Atach TabTerm" })

    vim.keymap.set({ "n", "i", "t" }, "<A-x>", function()
      require("TabTerm").close()
    end)

    vim.keymap.set({ "n", "i", "t" }, "<A-m>x", function()
      require("TabTerm").close()
    end, { desc = "Close Terminal" })

    vim.keymap.set({ "n", "i", "t" }, "<A-m>,", ":TabTermRename<CR>", {desc = "Rename Terminal"})

    vim.keymap.set({ "n", "i", "t" }, "<A-,>", function()
      require("TabTerm").rename()
    end)

    for i = 1, 9, 1 do
      vim.keymap.set({ "n", "i", "t" }, "<A-m>" .. i, function()
        require("TabTerm").goto(i)
      end, { desc = "Go to Terminal " .. i .. "" })
      vim.keymap.set({ "n", "i", "t" }, "<A-" .. i .. ">", function()
        require("TabTerm").goto(i)
      end, { desc = "Go to Terminal " .. i .. "" })
    end
  end,
}
