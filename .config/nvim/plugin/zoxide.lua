local function zoxide_list()
  local handle = io.popen("zoxide query --list")
  if not handle then
    return {}
  end
  local results = {}
  for line in handle:lines() do
    if line ~= "" then
      table.insert(results, line)
    end
  end
  handle:close()
  return results
end

local function format_zoxide_item(item)
  -- Shorten home directory path for cleaner display
  -- local home = vim.env.HOME or vim.env.USERPROFILE
  -- if home and item:sub(1, #home) == home then
  -- 	return "~" .. item:sub(#home + 1)
  -- end
  return item
end

local function zoxide_select(prompt, cmd)
  local items = zoxide_list()
  if #items == 0 then
    vim.notify("No zoxide entries found", vim.log.levels.WARN)
    return
  end

  vim.ui.select(items, {
    prompt = prompt,
    format_item = format_zoxide_item,
  }, function(choice)
    if choice then
      vim.cmd(cmd .. " " .. vim.fn.fnameescape(choice))
      vim.notify("Changed directory to: " .. choice)
    end
  end)
end

-- Shared completion function for both Z and Zt commands
local function zoxide_complete(_, line)
  local arg = line:match("^%S+%s+(.*)$") or ""
  local paths = zoxide_list()
  if arg == "" then
    return paths
  end

  local matches = {}
  for _, path in ipairs(paths) do
    if path:find(arg, 1, true) then
      table.insert(matches, path)
    end
  end
  return matches
end

-- Shared execution function for both Z and Zt commands
local function zoxide_execute(target, cd_cmd)
  if target == "" then
    vim.cmd(cd_cmd .. " ~")
    return
  end

  local handle = io.popen("zoxide query " .. vim.fn.shellescape(target))
  if not handle then
    vim.notify("Failed to run zoxide", vim.log.levels.ERROR)
    return
  end

  local result = handle:read("*l")
  handle:close()

  if result and result ~= "" then
    vim.cmd(cd_cmd .. " " .. vim.fn.fnameescape(result))
    print("Changed directory to: " .. result)
  else
    print("zoxide: no match for '" .. target .. "'")
  end
end

-- Better Cd with Zoxide (window)
vim.api.nvim_create_user_command("Z", function(opts)
  zoxide_execute(opts.args, "cd")
end, { nargs = "?", complete = zoxide_complete })

-- Better Cd with Zoxide (tab)
vim.api.nvim_create_user_command("Zt", function(opts)
  zoxide_execute(opts.args, "tcd")
end, { nargs = "?", complete = zoxide_complete })

-- Keybinds using vim.ui.select
vim.keymap.set("n", "<space>z", function()
  zoxide_select("Zoxide (cd):", "cd")
end, { desc = "Zoxide picker (cd)" })

vim.keymap.set("n", "<space>Z", function()
  zoxide_select("Zoxide (tcd):", "tcd")
end, { desc = "Zoxide picker(tcb)" })
