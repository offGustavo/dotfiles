local M = {}

local path_name = "espeto"

-- Identificador do projeto (cwd)
local function get_project_key()
  return vim.fn.getcwd():gsub("[^%w]", "_")
end

local function get_storage_path()
  return vim.fn.stdpath("data") .. path_name .. "/" .. get_project_key() .. ".json"
end

local marks = {}
for i = 1, 9 do
  marks[i] = nil
end

function M.load()
  local path = get_storage_path()
  local file = io.open(path, "r")
  if file then
    local content = file:read("*a")
    file:close()
    local ok, data = pcall(vim.json.decode, content)
    if ok and type(data) == "table" then
      for i = 1, 9 do
        marks[i] = data[i]
      end
    end
  end
end

local function save()
  local path = get_storage_path()
  vim.fn.mkdir(vim.fn.stdpath("data") .. path_name, "p")
  local file = io.open(path, "w")
  if file then
    file:write(vim.json.encode(marks))
    file:close()
  end
end

-- API pública
function M.get(index)
  return marks[index]
end

function M.set(index, path)
  if index < 1 or index > 9 then
    vim.notify("Índice deve ser entre 1 e 9", vim.log.levels.ERROR)
    return
  end
  marks[index] = path
  save()
  vim.notify(string.format("Arquivo %s definido na posição %d", path, index), vim.log.levels.INFO)
end

function M.remove(index)
  if index < 1 or index > 9 then
    vim.notify("Índice inválido", vim.log.levels.ERROR)
    return
  end
  marks[index] = nil
  save()
  vim.notify(string.format("Posição %d limpa", index), vim.log.levels.INFO)
end

function M.add(path)
  for i = 1, 9 do
    if marks[i] == nil then
      marks[i] = path
      save()
      vim.notify(string.format("Arquivo %s adicionado na posição %d", path, i), vim.log.levels.INFO)
      return i
    end
  end
  vim.notify("Não há slots vazios", vim.log.levels.WARN)
  return nil
end

function M.list()
  local items = {}
  for i = 1, 9 do
    if marks[i] then
      table.insert(items, string.format("%d: %s", i, marks[i]))
    end
  end
  if #items == 0 then
    vim.notify("No file", vim.log.levels.INFO)
  else
    vim.notify(table.concat(items, "\n"), vim.log.levels.INFO, { title = "Espeto Alt" })
  end
end

function M.go(index)
  local path = marks[index]
  if not path or path == nil then
    vim.notify("No file in " .. index, vim.log.levels.WARN)
    return
  end
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

return M
