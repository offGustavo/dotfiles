-------------
-- NEOVIDE --
-------------
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 8
vim.g.neovide_padding_left = 8

autocmd("Colorscheme", function()
  local hl = vim.api.nvim_get_hl
  vim.g.neovide_title_background_color = string.format("%x", hl(0, { name = "Normal" }).bg)
  vim.g.neovide_title_text_color = string.format("%x", hl(0, { name = "Normal" }).fg)
end)

autocmd("UiEnter", function()
  vim.cmd("cd ~")
end)

local font_size = 12

---@param amount integer
---@param log boolean
local function set_font_size(amount, log)
  if amount == 0 then
    font_size = 12
  else
    font_size = font_size + amount
  end
  if vim.uv.os_uname().sysname == "Windows_NT" then
    vim.o.guifont = "JetbrainsMonoNL Nerd Font Propo:h" .. font_size
    if log then
      print("Font Size: " .. font_size)
    end
  else
    vim.o.guifont = "JetbrainsmonoNL NF:h" .. font_size
    if log then
      print("Font Size: " .. font_size)
    end
  end
end

set_font_size(0, false)

map {
  {
    { "i", "v", "n", "c" },
    "<C-+>",
    function()
      set_font_size(1, true)
    end,
    desc = "Increase Font Size in neovide",
    silent = true,
  },
  {
    { "i", "v", "n", "c" },
    "<C-_>",
    function()
      set_font_size(-1, true)
    end,
    desc = "Decrease Font Size in neovide",
    silent = true,
  },
  {
    { "i", "v", "n", "c" },
    "<C-S-BS>",
    function()
      set_font_size(0, true)
    end,
    desc = "Restore Font Size in neovide",
    silent = true,
  },
}
