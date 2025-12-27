-- Função principal
local function align_regexp(opts)
  -- pede separador (regex)
  local sep = vim.fn.input("Separador (regex ou texto): ")
  if sep == "" then
    return
  end

  -- obtém range
  local start_line = opts.line1
  local end_line = opts.line2
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  -- divide linhas e calcula larguras
  local split_lines = {}
  local col_widths = {}

  for _, line in ipairs(lines) do
    -- usa regex se aplicável
    local parts = vim.split(line, sep, { plain = true, trimempty = false })
    table.insert(split_lines, parts)
    for i, part in ipairs(parts) do
      local len = vim.fn.strdisplaywidth(vim.trim(part))
      col_widths[i] = math.max(col_widths[i] or 0, len)
    end
  end

  -- monta linhas alinhadas
  local aligned = {}
  for _, parts in ipairs(split_lines) do
    local new_parts = {}
    for i, part in ipairs(parts) do
      local pad = col_widths[i] - vim.fn.strdisplaywidth(vim.trim(part))
      table.insert(new_parts, vim.trim(part) .. string.rep(" ", pad))
    end
    table.insert(aligned, table.concat(new_parts, " " .. sep .. " "))
  end

  -- substitui no buffer
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, aligned)
end

-- cria comando
vim.api.nvim_create_user_command("AlignRegexp", align_regexp, { range = true })

