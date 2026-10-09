---Check whether Neovim is running on Windows.
---@return boolean
function _G.is_windows()
  return vim.fn.has("win32") == 1
end

-- Augroup
_G.fish_group = vim.api.nvim_create_augroup("Fish.config", {})

---Set options like `:set`.
---
---See `Fish.set` for the supported value types.
---@param opts table<string, OptValue>
---@param scope? OptScope Defaults to `"both"`
---@usage lua
--- set {
---   number     = true,
---   wildignore = { append = { "*.o", "*.obj" }, remove = "*.tmp" },
---   shortmess  = function(o) o:remove("I") end,
--- }
--- set({ wrap = false }, "local") -- same as set_local
function _G.set(opts, scope)
  require("Fish.set_opt").set(opts, scope)
end

---Set options like `:setlocal` (current buffer/window only).
---@param opts table<string, OptValue>
---@usage lua
--- set_local { wrap = false, colorcolumn = "80" }
function _G.set_local(opts)
  require("Fish.set_opt").set(opts, "local")
end

---Set options like `:setglobal` (global value only, not the current buffer/window).
---@param opts table<string, OptValue>
---@usage lua
--- set_global { shiftwidth = 4 }
function _G.set_global(opts)
  require("Fish.set_opt").set(opts, "global")
end

---comment
---@param event string|table
---@param callback? function
---@param pattern? string|table|function
---@param group? any
---@param desc? string
function _G.autocmd(event, callback, pattern, group, desc)
  vim.api.nvim_create_autocmd(event, {
    group = group or fish_group,
    desc = desc or nil,
    pattern = pattern or nil,
    callback = callback or nil,
  })
end

---Define keymaps in bulk.
---
---See `Fish.keymap_set` for the spec format, `{i}` range expansion and lazy loading.
---@param maps KeymapSpec[]
---@usage lua
--- map {
---   { "<leader>w", "<cmd>w<cr>", desc = "Save" },
---   { "i", "jk", "<esc>" },
---   { "<leader>{i}", "<cmd>b{i}<cr>", range = { 1, 9 }, desc = "Buffer {i}" },
--- }
function _G.map(maps)
  later(function()
    require("Fish.keymap_set").map(maps)
  end)
end

function _G.later(fn)
  -- TODO: i should use async here?
  -- vim.async.run(fn)
  vim.schedule(fn)
end

---Load one or more optional plugins with `:packadd`, in the order given.
---
---A plugin that can't be found is reported with `vim.notify` and skipped,
---so one bad name doesn't abort the rest of your config.
---@param names string|string[] plugin name, or a list of names
---@return boolean ok `true` if every plugin was loaded
---@usage lua
--- packadd("nvim-treesitter")
--- packadd({ "plenary.nvim", "telescope.nvim" })
function _G.packadd(names)
  if type(names) == "string" then
    names = { names }
  end

  local ok_all = true
  for _, name in ipairs(names) do
    local ok, err = pcall(vim.cmd.packadd, name)
    if not ok then
      ok_all = false
      vim.notify(("packadd: failed to load %q: %s"):format(name, err), vim.log.levels.ERROR)
    end
  end
  return ok_all
end
