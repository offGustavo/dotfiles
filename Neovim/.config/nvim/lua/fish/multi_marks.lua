local M = {}

-- Helper: get current loclist for this window
local function get_loclist()
  return vim.fn.getloclist(0)
end

-- Helper: set loclist (com título opcional)
local function set_loclist(list, title)
  vim.fn.setloclist(0, list, 'r') -- só atualiza a lista
  if title then
    vim.fn.setloclist(0, {}, 'a', { title = title }) -- só atualiza o título
  end
end

-- Add current line/col as a loclist entry
function M.add_mark()
  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local list = get_loclist()

  table.insert(list, {
    bufnr = buf,
    lnum = row,
    col = col + 1, -- loclist é 1-based
    text = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1],
  })

  set_loclist(list, "Marks")
  print("Mark adicionada em linha " .. row .. ", coluna " .. col)
end

-- Go to next mark (wrap around)
function M.goto_mark()
  if vim.fn.getloclist(0, {size = 0}).size == 0 then
    print("Nenhuma mark definida")
    return
  end
  vim.cmd("try | lnext | catch /^Vim\\%((\\a\\+)\\)\\=:E553/ | lfirst | endtry")
end

-- Go to start of next marked line
function M.goto_mark_start()
  if vim.fn.getloclist(0, {size = 0}).size == 0 then
    print("Nenhuma mark definida")
    return
  end
  vim.cmd("try | lnext | catch /^Vim\\%((\\a\\+)\\)\\=:E553/ | lfirst | endtry")
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_win_set_cursor(0, {row, 0})
end

-- Clear all marks
function M.clear_marks()
  set_loclist({}, "Marks")
  print("Todas as marks foram removidas")
end

-- Delete all marked lines
function M.delete_marks()
  local list = get_loclist()
  if #list == 0 then return end
  table.sort(list, function(a,b) return a.lnum > b.lnum end)
  for _, item in ipairs(list) do
    vim.api.nvim_buf_set_lines(item.bufnr, item.lnum-1, item.lnum, false, {})
  end
  M.clear_marks()
end

-- Copy all marked lines
function M.copy_marks()
  local list = get_loclist()
  if #list == 0 then return end
  local lines = {}
  for _, item in ipairs(list) do
    table.insert(lines, vim.api.nvim_buf_get_lines(item.bufnr, item.lnum-1, item.lnum, false)[1])
  end
  vim.fn.setreg('"', table.concat(lines, "\n"))
  print(#lines .. " linhas copiadas")
end

-- Change all marked lines with function f
function M.change_marks(f)
  local list = get_loclist()
  if #list == 0 then return end
  for _, item in ipairs(list) do
    local line = vim.api.nvim_buf_get_lines(item.bufnr, item.lnum-1, item.lnum, false)[1]
    vim.api.nvim_buf_set_lines(item.bufnr, item.lnum-1, item.lnum, false, {f(line)})
  end
end

-- keymaps
vim.keymap.set('n', 'm<space>', M.add_mark, {desc="Adicionar mark"})
-- vim.keymap.set('n', '<space>', M.goto_mark, {desc="Ir para mark (cíclico)"})
vim.keymap.set('n', "'<space>", M.goto_mark_start, {desc="Ir para início da mark (cíclico)"})
vim.keymap.set('n', 'm<BS>', M.clear_marks, {desc="Limpar marks"})
vim.keymap.set('n', "d'<space>", M.delete_marks, {desc="Deletar linhas marcadas"})
vim.keymap.set('n', "y'<space>", M.copy_marks, {desc="Copiar linhas marcadas"})

return M
