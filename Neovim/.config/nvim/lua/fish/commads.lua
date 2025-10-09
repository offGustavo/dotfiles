-- Função de alinhamento estilo align-regexp (substitui linhas no buffer)
local function align_regexp(opts)
  -- pede o padrão ao usuário
  local sep = vim.fn.input("Regex para alinhar: ")
  if sep == "" then return end

  -- pega o range selecionado ou a linha atual
  local start_line = opts.line1
  local end_line = opts.line2

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  -- usa column(1) em Lua: separar e alinhar
  local split_lines = {}
  local col_widths = {}

  -- divide cada linha pelo separador e calcula larguras máximas
  for _, line in ipairs(lines) do
    local parts = vim.split(line, sep, { plain = true, trimempty = false })
    table.insert(split_lines, parts)
    for i, part in ipairs(parts) do
      local len = vim.fn.strdisplaywidth(part)
      col_widths[i] = math.max(col_widths[i] or 0, len)
    end
  end

  -- monta as linhas alinhadas
  local aligned = {}
  for _, parts in ipairs(split_lines) do
    local new_parts = {}
    for i, part in ipairs(parts) do
      local pad = col_widths[i] - vim.fn.strdisplaywidth(part)
      table.insert(new_parts, part .. string.rep(" ", pad))
    end
    table.insert(aligned, table.concat(new_parts, " " .. sep .. " "))
  end

  -- substitui no buffer
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, aligned)
end

-- Cria comando :AlignRegexp
vim.api.nvim_create_user_command("AlignRegexp", align_regexp, { range = true })

-- Map visual e normal
vim.keymap.set("v", "<leader>a", ":AlignRegexp<CR>", { desc = "Align by regex", silent = true })
vim.keymap.set("n", "<leader>a", ":AlignRegexp<CR>", { desc = "Align by regex", silent = true })
