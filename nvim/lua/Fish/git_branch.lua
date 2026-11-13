-- lua/fish_git_branch.lua
--
-- Provides two variables:
--   vim.b.fish_git_branch  buffer-local branch (based on the buffer's file dir)
--   vim.g.fish_git_branch  global fallback branch (based on Neovim's cwd)
--
-- Priority: buffer-local branch > global branch (only for buffers that have
-- no file, e.g. terminals, help, [No Name]) > nil.
--
--   * buffer variable: refreshed on BufEnter only
--   * global variable: refreshed on DirChanged (and once on setup)
--   * all git calls are async (vim.system), so the UI never blocks
--
-- Requires Neovim >= 0.10.
--
-- Usage:
--   require("fish_git_branch").setup()
--   require("fish_git_branch").setup({ fallback_when_no_repo = true })

local M = {}

local opts = {
  -- Also use the global branch for *file* buffers that are not inside a git
  -- repo. Default false: such buffers get nil.
  fallback_when_no_repo = false,
}

local group = vim.api.nvim_create_augroup("FishGitBranch", { clear = true })

local pending = {} -- buf -> true while a lookup is running
local global_seq = 0 -- discards stale global lookups

local function trim(s)
  return ((s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function git(args, cwd, on_exit)
  local ok = pcall(vim.system, vim.list_extend({ "git" }, args), {
    cwd = cwd,
    text = true,
    stderr = false,
  }, on_exit)
  return ok
end

-- Resolves the branch for `dir` and calls cb(branch|nil) on the main loop.
-- `--show-current` is empty on a detached HEAD, so fall back to the short hash.
local function lookup(dir, cb)
  local started = git({ "branch", "--show-current" }, dir, function(res)
    local branch = res.code == 0 and trim(res.stdout) or ""
    if branch ~= "" or res.code ~= 0 then
      vim.schedule(function()
        cb(branch ~= "" and branch or nil)
      end)
      return
    end
    local ok = git({ "rev-parse", "--short", "HEAD" }, dir, function(r2)
      local h = r2.code == 0 and trim(r2.stdout) or ""
      vim.schedule(function()
        cb(h ~= "" and h or nil)
      end)
    end)
    if not ok then
      vim.schedule(function()
        cb(nil)
      end)
    end
  end)
  if not started then
    cb(nil)
  end
end

local function set_branch(buf, branch)
  if vim.api.nvim_buf_is_valid(buf) then
    vim.b[buf].fish_git_branch = branch -- nil clears the variable
  end
end

local function is_file_buf(buf)
  return vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= ""
end

local function fallback()
  return vim.g.fish_git_branch
end

local function update_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  -- No file behind this buffer: use the global (cwd) branch
  if not is_file_buf(buf) then
    set_branch(buf, fallback())
    return
  end

  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(buf))
  if not dir or not vim.uv.fs_stat(dir) then
    set_branch(buf, opts.fallback_when_no_repo and fallback() or nil)
    return
  end

  if pending[buf] then
    return
  end
  pending[buf] = true

  lookup(dir, function(branch)
    pending[buf] = nil
    if branch == nil and opts.fallback_when_no_repo then
      branch = fallback()
    end
    set_branch(buf, branch)
  end)
end

local function update_global()
  global_seq = global_seq + 1
  local seq = global_seq

  lookup(vim.fn.getcwd(), function(branch)
    if seq ~= global_seq then
      return -- a newer DirChanged superseded this lookup
    end
    vim.g.fish_git_branch = branch

    -- Refresh the current buffer if it depends on the global fallback
    local cur = vim.api.nvim_get_current_buf()
    if not is_file_buf(cur) then
      set_branch(cur, branch)
    end
  end)
end

function M.setup(user_opts)
  opts = vim.tbl_extend("force", opts, user_opts or {})

  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    desc = "Set vim.b.fish_git_branch for the entered buffer",
    callback = function(args)
      update_buffer(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("DirChanged", {
    group = group,
    desc = "Set vim.g.fish_git_branch from the new cwd",
    callback = update_global,
  })

  vim.api.nvim_create_autocmd("BufDelete", {
    group = group,
    callback = function(args)
      pending[args.buf] = nil
    end,
  })

  update_global()
  update_buffer(vim.api.nvim_get_current_buf())
end

return M
