local M = {}

-- TODO: Improve Type

---@class DiredConfig
---@field evil_keybinds? boolean Set Evil(Vim) Keybinds for Dired
M.dired = {
  evil_keybinds = false,
}

---@alias cfg DiredConfig
function M.setup(cfg)
  if cfg == nil then
    return
  end
end

-- In First user we laod
M.setup(vim.g.dired)

---@alias vim.g.dired DiredConfig
vim.g.dired = {}

return M
