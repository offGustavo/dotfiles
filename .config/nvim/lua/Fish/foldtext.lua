local M = {}

-- Attribute keys nvim_get_hl can return; if none of these are set on a
-- group, it has no real visual style.
local style_attrs = {
  "fg",
  "bg",
  "sp",
  "bold",
  "italic",
  "underline",
  "undercurl",
  "underdouble",
  "underdotted",
  "underdashed",
  "strikethrough",
  "reverse",
  "standout",
  "nocombine",
}

-- Does `name` (or one of its dotted fallbacks, e.g. "@a.b.c" -> "@a.b" -> "@a")
-- resolve to a highlight group with any actual visual attribute? Mirrors the
-- fallback Neovim itself does when rendering "@..." highlight names, since
-- nvim_get_hl doesn't perform that fallback for us.
local function resolve_style(name)
  local candidate = name
  while candidate do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = candidate, link = false })
    if ok and hl then
      for _, attr in ipairs(style_attrs) do
        if hl[attr] ~= nil then
          return candidate
        end
      end
    end
    candidate = candidate:match("^(.*)%.[^.]+$")
  end
  return nil
end

-- Resolve a highlight group for (row, col) in `buffer`.
-- - If treesitter is NOT highlighting the buffer: use Vim's native :syntax,
--   falling back to "Normal" when a position has no syntax group at all
--   (instead of leaving it unhighlighted / grey).
-- - If treesitter IS highlighting the buffer: prefer an LSP semantic token
--   at this position, but only if it actually resolves to a styled group;
--   otherwise fall back to the treesitter capture.
-- row/col are 0-indexed (treesitter/LSP convention).
local function hl_at(buffer, filetype, ts_active, row, col)
  if not ts_active then
    local id = vim.fn.synID(row + 1, col + 1, 1)
    if id ~= 0 then
      local name = vim.fn.synIDattr(vim.fn.synIDtrans(id), "name")
      if name ~= "" then
        return name
      end
    end
    return "Normal"
  end

  local ok, tokens = pcall(vim.lsp.semantic_tokens.get_at_pos, buffer, row, col)
  if ok and tokens and #tokens > 0 then
    local token = tokens[#tokens]
    local resolved = resolve_style("@lsp.type." .. token.type .. "." .. filetype)
    if resolved then
      return resolved
    end
  end

  local hl_captures = vim.treesitter.get_captures_at_pos(buffer, row, col)
  if #hl_captures > 0 then
    local last = hl_captures[#hl_captures]
    return "@" .. last.capture .. "." .. last.lang
  end

  return nil
end

M.build_fold_text = function()
  local fragments = {}
  local foldmethod = vim.wo.foldmethod
  local buffer = vim.api.nvim_get_current_buf()
  local first_line = vim.fn.getbufline(buffer, vim.v.foldstart)[1] or ""
  local last_line = vim.fn.getbufline(buffer, vim.v.foldend)[1] or ""
  local filetype = vim.bo[buffer].filetype

  -- Indent: preserve indentation of the fold start line
  if foldmethod == "indent" then
    local indent = first_line:match("^%s*") or ""
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

    -- Strip the opening marker and trailing whitespace from the start line
    -- local content = first_line:gsub(vim.pesc(open_marker) .. "%d*%s*$", ""):gsub("%s+$", "")

    for _, char in ipairs(vim.fn.split(first_line, "\\zs")) do
      table.insert(fragments, { char, "@comment" })
    end
    for _, char in ipairs(vim.fn.split(" ... ", "\\zs")) do
      table.insert(fragments, { char, "@comment" })
    end
    for _, char in ipairs(vim.fn.split(close_marker, "\\zs")) do
      table.insert(fragments, { char, "@comment" })
    end

    return fragments
  end

  -- Expr: first line + delimiter + last line (syntax highlighted)
  if foldmethod == "expr" then
    -- Is treesitter actually highlighting this buffer right now?
    local ts_active = require("vim.treesitter.highlighter").active[buffer] ~= nil

    for p, char in ipairs(vim.fn.split(first_line, "\\zs")) do
      local hl = hl_at(buffer, filetype, ts_active, vim.v.foldstart - 1, p - 1)
      table.insert(fragments, hl and { char, hl } or { char })
    end

    for _, char in ipairs(vim.fn.split(" ... ", "\\zs")) do
      table.insert(fragments, { char, "@comment" })
    end

    local whitespace = #(last_line:match("^%s*") or "")
    for p, char in ipairs(vim.fn.split(last_line, "\\zs")) do
      if p > whitespace then
        local hl = hl_at(buffer, filetype, ts_active, vim.v.foldend - 1, p - 1)
        table.insert(fragments, hl and { char, hl } or { char })
      end
    end

    return fragments
  end

  -- Manual, Diff, Syntax: we use the default fold text from vim
  return vim.fn.foldtext()
end

return M
