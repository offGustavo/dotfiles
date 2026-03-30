-- Caminho para salvar o tema escolhido
local theme_file = vim.fn.stdpath("config") .. "/.theme"

-- Última versão do tema carregado
local last_theme = nil

-- Função para carregar o tema do arquivo
local function load_theme()
  local f = io.open(theme_file, "r")
  if f then
    local theme = f:read("*l")
    f:close()
    if theme and #theme > 0 and theme ~= last_theme then
      local ok = pcall(vim.cmd, "colorscheme " .. theme)
      if ok then
        last_theme = theme
        -- vim.notify("Tema atualizado para: " .. theme, vim.log.levels.INFO)
      end
    end
  end
end

-- Função para salvar o tema ao trocar
local function save_theme(theme)
  local f = io.open(theme_file, "w")
  if f then
    f:write(theme)
    f:close()
  end
end

-- Autocomando: quando você muda manualmente o colorscheme, salva no arquivo
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local theme = vim.g.colors_name
    if theme then
      save_theme(theme)
    end
  end,
})

-- vim.api.nvim_create_autocmd("OptionSet", {
--   pattern = "background",
--   desc = "Auto switch colorscheme on background change",
--   callback = function()
--   end
-- })

-- Checar o arquivo a cada 2 segundos (2000 ms)
vim.fn.timer_start(2000, function()
  load_theme()
end, { ["repeat"] = -1 })

-- Carrega o tema na inicialização
load_theme()
