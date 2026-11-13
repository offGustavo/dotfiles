-- REF: [native fuzzy finder in neovim with lua and cool bindings :: cherry's blog](https://cherryramatis.xyz/posts/native-fuzzy-finder-in-neovim-with-lua-and-cool-bindings/)

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

local function get_cmd()
  if vim.fn.executable("fd") then
    return { "fd", "--hidden --type", "f" }
  end
  if vim.fn.executable("rg") then
    return { "rg", "--files" }
  end
  if vim.fn.executable("find") then
    return { "find", "-type", "f" }
  end
  if vim.fn.executable("git") then
    if vim.v.shell_error == 0 and vim.fn.system("git rev-parse"):match("true") ~= nil then
      return
    end
    return { "git", "ls-files" }
  end
  return nil
end

local function find(cmdarg, cmdcomplete)
  local cmd = get_cmd()

  if cmd ~= nil then
    local ok, result = pcall(vim.fn.systemlist, table.concat(cmd, " "))
    if ok then
      return result
    else
      vim.notify(tostring(result), vim.log.levels.ERROR)
      return
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
