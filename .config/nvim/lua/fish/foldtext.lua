local M = {}

M.build_fold_text = function()
  local foldmethod = vim.wo.foldmethod

  -- Indent: preserve indentation of the fold start line
  if foldmethod == "indent" then
    local buffer = vim.api.nvim_get_current_buf()
    local start_line = vim.fn.getbufline(buffer, vim.v.foldstart)[1] or ""
    local indent = start_line:match("^%s*") or ""
    return {
      { indent },
      { "... ", "@comment" },
    }
  end

  -- Marker: first line (stripped of opening marker) + delimiter + closing marker
  if foldmethod == "marker" then
    local foldmarker = vim.wo.foldmarker
    local open_marker = vim.fn.split(foldmarker, ",")[1]
    local close_marker = vim.fn.split(foldmarker, ",")[2]

    local buffer = vim.api.nvim_get_current_buf()
    local start_line = vim.fn.getbufline(buffer, vim.v.foldstart)[1] or ""

    -- Strip the opening marker and trailing whitespace from the start line
    local content = start_line:gsub(vim.pesc(open_marker) .. "%d*%s*$", ""):gsub("%s+$", "")

    local fragments = {}
    for _, char in ipairs(vim.fn.split(content, "\\zs")) do
      table.insert(fragments, { char, "@comment"  })
    end
    for _, char in ipairs(vim.fn.split(" ... ", "\\zs")) do
      table.insert(fragments, { char, "@comment" })
    end
    for _, char in ipairs(vim.fn.split(close_marker, "\\zs")) do
      table.insert(fragments, { char, "@comment"  })
    end

    return fragments
  end



  -- Expr / treesitter: first line + delimiter + last line (syntax highlighted)
  local buffer = vim.api.nvim_get_current_buf()
  local start_line = vim.fn.getbufline(buffer, vim.v.foldstart)[1] or ""
  local end_line = vim.fn.getbufline(buffer, vim.v.foldend)[1] or ""

    -- Markdown: heading folds show only the first line, syntax-highlighted.
  -- The end line is meaningless (blank line or unrelated content), so we
  -- omit it and match the native treesitter fold appearance.
  local ft = vim.bo[buffer].filetype
  if ft == "markdown" or ft == "mdx" then
    local fragments = {}
    for p, char in ipairs(vim.fn.split(start_line, "\\zs")) do
      local hl_captures = vim.treesitter.get_captures_at_pos(buffer, vim.v.foldstart - 1, p - 1)
      if #hl_captures > 0 then
        local last = hl_captures[#hl_captures]
        table.insert(fragments, { char, "@" .. last.capture .. "." .. last.lang })
      else
        table.insert(fragments, { char })
      end
    end
    for _, char in ipairs(vim.fn.split(" ... ", "\\zs")) do
      table.insert(fragments, { char, "@comment" })
    end
    return fragments
  end

  local fragments = {}

  for p, char in ipairs(vim.fn.split(start_line, "\\zs")) do
    local hl_captures = vim.treesitter.get_captures_at_pos(buffer, vim.v.foldstart - 1, p - 1)
    if #hl_captures > 0 then
      local last = hl_captures[#hl_captures]
      table.insert(fragments, { char, "@" .. last.capture .. "." .. last.lang })
    else
      table.insert(fragments, { char })
    end
  end

  for _, char in ipairs(vim.fn.split(" ... ", "\\zs")) do
    table.insert(fragments, { char, "@comment" })
  end

  local whitespace = #(end_line:match("^%s*") or "")
  for p, char in ipairs(vim.fn.split(end_line, "\\zs")) do
    if p > whitespace then
      local hl_captures = vim.treesitter.get_captures_at_pos(buffer, vim.v.foldend - 1, p - 1)
      if #hl_captures > 0 then
        local last = hl_captures[#hl_captures]
        table.insert(fragments, { char, "@" .. last.capture .. "." .. last.lang })
      else
        table.insert(fragments, { char })
      end
    end
  end

  return fragments
end

return M
