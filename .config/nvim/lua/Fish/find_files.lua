-- REF: [native fuzzy finder in neovim with lua and cool bindings :: cherry's blog](https://cherryramatis.xyz/posts/native-fuzzy-finder-in-neovim-with-lua-and-cool-bindings/)

local function has(cmd)
  return vim.fn.executable(cmd)
end

local function is_git_repo()
  local res = vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0 and res:match("true") ~= nil
end

local function lua_fallback(cmdarg)
  local results = {}

  local function scan(path)
    local handle = vim.uv.fs_scandir(path)
    if not handle then
      return
    end

    while true do
      local name, type = vim.uv.fs_scandir_next(handle)
      if not name then
        break
      end

      local full_path = path .. "/" .. name

      if type == "directory" then
        -- Skip hidden or heavy directories like .git or node_modules
        if name ~= ".git" and name ~= "node_modules" then
          scan(full_path)
        end
      elseif type == "file" then
        -- If there's a search term, filter files containing it (or change to pattern matching)
        if #cmdarg == 0 or full_path:find(cmdarg, 1, true) then
          table.insert(results, full_path)
        end
      end
    end
  end

  -- Start scanning from the current working directory
  scan(vim.uv.cwd())
  return results
end

local function find(cmdarg, cmdcomplete)
  local cmd = nil

  if has("fd") then
    cmd = { "fd", "--hidden --type", "f" }
    -- // If the user typed a search query, append it to the command (e.g., for fd <query>)
    if cmdarg and #cmdarg > 0 then
      table.insert(cmd, cmdarg)
    end
  end

  if has("rg") then
    cmd = { "rg", "--files" }
  end

  if has("find") then
    cmd = { "find", "-type", "f" }
  end

  if has("git") and is_git_repo() then
    cmd = { "git", "ls-files" }
  end

  if cmd ~= nil then
    local ok, result = pcall(vim.fn.systemlist, table.concat(cmd, " "))
    if ok then
      return result
    else
      vim.notify(tostring(result), vim.log.levels.ERROR)
    end
  end

  return lua_fallback(cmdarg)
end

return function(cmdarg, cmdcomplete)
  local fnames = find(cmdarg, cmdcomplete)

  -- vim.print(vim.inspect(fnames))
  if #cmdarg == 0 then
    return fnames
  end

  return vim.fn.matchfuzzy(fnames, cmdarg)
end
