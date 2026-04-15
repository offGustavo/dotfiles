-------------
-- NEOVIDE --
-------------
-- Neovide Font Resize
if vim.g.neovide then
  local FontSize = 12
  local function SetFontSize(amount)
    if amount == 0 then
      FontSize = 12
    else
      FontSize = FontSize + amount
    end
    if vim.uv.os_uname().sysname == "Windows_NT" then
      vim.o.guifont = "JetbrainsMonoNL Nerd Font:h" .. FontSize
      print("Font Size: " .. FontSize)
    else
      vim.o.guifont = "JetbrainsmonoNL NF:h" .. FontSize
      print("Font Size: " .. FontSize)
    end
  end
  SetFontSize(0)
  vim.keymap.set({ "i", "v", "n", "c" }, "<C-=>", function()
    SetFontSize(1)
  end, { desc = "Increase Font Size in neovide", silent = true })
  vim.keymap.set({ "i", "v", "n", "c" }, "<C-->", function()
    SetFontSize(-1)
  end, { desc = "Decrease Font Size in neovide", silent = true })
  vim.keymap.set({ "i", "v", "n", "c" }, "<C-0>", function()
    SetFontSize(0)
  end, { desc = "Restore Font Size in neovide", silent = true })
end
