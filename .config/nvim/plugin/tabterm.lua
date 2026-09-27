vim.g.tabterm_config = {
  -- Winbar Config
  separator_right = "",
  separator_left = "",
  separator_first = "",
  center = true,
  default_highlight = "%#Normal#",
  tab_highlight = "%#TablineSel#",
  -- Window Config
  vertical_size = 20,
  float = false,
  default_maps = true,
}

vim.keymap.set({ "n", "i", "x", "t" }, "<A-n>", function()
  require("fish.tabterm").new()
end, { desc = "TabTerm New" })
vim.keymap.set({ "n", "i", "x", "t" }, "<A-z>", function()
  require("fish.tabterm").close()
end, { desc = "TabTerm Close" })
vim.keymap.set({ "n", "i", "x", "t" }, "<A-/>", function()
  require("fish.tabterm").toggle()
end, { desc = "TabTerm Toggle" })
for i = 1, 9, 1 do
  vim.keymap.set({ "n", "i", "x", "t" }, "<A-" .. i .. ">", function()
    require("fish.tabterm").go(i)
  end, { desc = "TabTerm Toggle" })
end

vim.api.nvim_create_user_command("TabTermToggle", require("fish.tabterm").toggle, {})

vim.api.nvim_create_user_command("TabTermNew", function(opts)
  require("fish.tabterm").new(opts.args ~= "" and opts.args or nil)
end, { nargs = "?" })

vim.api.nvim_create_user_command("TabTermClose", function(opts)
  if opts.args ~= "" then
    local idx = tonumber(opts.args)
    if idx then
      require("fish.tabterm").close(idx)
    end
  else
    require("fish.tabterm").close(nil)
  end
end, { nargs = "?" })

vim.api.nvim_create_user_command("TabTermRename", function(opts)
  require("fish.tabterm").rename(opts.args)
end, { nargs = "?" })

vim.api.nvim_create_user_command("TabTermGo", function(opts)
  local index = tonumber(opts.args) or 1 -- defaults to 1 if not a number
  require("fish.tabterm").go(index)
end, { nargs = "?" })

autocmd("BufWipeout", function(args)
  local ok, created = pcall(vim.api.nvim_buf_get_var, args.buf, "tabterm_created")
  if ok and created then
    for i, term in ipairs(terminals) do
      if term.bufnr == args.buf then
        table.remove(terminals, i)
        if current_index > #terminals then
          current_index = #terminals
        end
        break
      end
    end
    if require("fish.tabterm").terminal_win and not vim.api.nvim_win_is_valid(M.terminal_win) then
      require("fish.tabterm").terminal_win = nil
    end
    if #terminals == 0 then
      vim.wo.winbar = ""
    end
  end
end)
