-- lazy_pack.lua
-- Wrapper de lazy-loading por keymap para vim.pack (Neovim 0.12+)
--
-- Replica o mecanismo do lazy.nvim:
--   1. Registra um keymap "fantasma" para cada `keys` da spec.
--   2. No primeiro uso, remove o fantasma, carrega o plugin de verdade
--      (vim.pack.add com load=true) e roda opts/config.
--   3. Refaz o feed da tecla para o mapeamento real do plugin responder.

local M = {}

-- specs ainda não carregadas, indexadas pelo nome do plugin
local pending = {}

--- Roda opts/config de uma spec, no mesmo espírito do lazy.nvim
---@param spec table
local function apply_config(spec)
  if type(spec.config) == "function" then
    spec.config(spec, spec.opts or {})
  elseif spec.opts then
    local ok, mod = pcall(require, spec.name)
    if ok and mod.setup then
      mod.setup(spec.opts)
    end
  end
end

--- Carrega de fato um plugin pendente
---@param name string
local function load_plugin(name)
  local spec = pending[name]
  if not spec or spec.loaded then
    return
  end
  spec.loaded = true
  pending[name] = nil

  -- load = true: além de garantir que está no packpath, executa o
  -- source do plugin (plugin/, ftplugin/, etc.) agora mesmo.
  vim.pack.add({
    { src = spec.src, version = spec.version, name = spec.name },
  }, { load = true })

  apply_config(spec)
end

--- Cria os keymaps fantasma de uma spec com `keys`
---@param spec table
local function register_keys(spec)
  for _, keymap in ipairs(spec.keys) do
    local lhs = keymap[1] or keymap.lhs
    local mode = keymap.mode or "n"
    local rhs = keymap[2] -- função ou string original (ex: função do plugin)
    local desc = keymap.desc

    local modes = type(mode) == "table" and mode or { mode }

    vim.keymap.set(modes, lhs, function()
      -- remove o(s) fantasma(s) antes de carregar, para não recursar
      -- quando o plugin registrar o mapeamento real por cima
      for _, m in ipairs(modes) do
        pcall(vim.keymap.del, m, lhs)
      end

      load_plugin(spec.name)

      if type(rhs) == "function" then
        -- a própria função original da spec já assume que o plugin
        -- está carregado (ex: function() require("flash").jump() end)
        rhs()
      else
        -- refeed: repete a tecla como se tivesse sido pressionada agora,
        -- contra o mapeamento real que o plugin acabou de criar
        local keys = vim.api.nvim_replace_termcodes(lhs, true, true, true)
        vim.api.nvim_feedkeys(keys, "m", false)
      end
    end, { desc = desc, silent = true })
  end
end

--- API pública: registra uma lista de specs
--- (mesmo formato do wrapper opts/config: src, version, name, opts, config, keys)
---@param specs table[]
function M.setup(specs)
  for _, spec in ipairs(specs) do
    if spec.keys and #spec.keys > 0 then
      pending[spec.name] = spec
      register_keys(spec)
    else
      -- sem `keys`: carrega direto, sem lazy-loading
      vim.pack.add({ { src = spec.src, version = spec.version, name = spec.name } })
      apply_config(spec)
    end
  end
end

return M

--[[
-- Exemplo de uso:
require("lv").setup({
  {
    src = "https://github.com/folke/flash.nvim",
    name = "flash.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
})
--]]
