-- -- Comment
-- -- TODO: this is a todo
-- -- FIX: this is a fix
-- -- FIXME(test): this is a fixme
-- -- ISSUE(test): this is a fixme
-- -- PERF: this is a perf
-- -- NOTE: this is a note

local ns = vim.api.nvim_create_namespace("keyword_highlight")

local config = {
  keywords = {
    ["%f[%w]FIX[^:]*:"] = { hl = "TodoFix", sign_hl = "TodoSignFix", icon = "" },
    ["%f[%w]BUG[^:]*:"] = { hl = "TodoFix", sign_hl = "TodoSignFix", icon = "" },
    ["%f[%w]ISSUE[^:]*:"] = { hl = "TodoFix", sign_hl = "TodoSignFix", icon = "" },
    ["%f[%w]HACK[^:]*:"] = { hl = "TodoHack", sign_hl = "TodoSignHack", icon = "" },
    ["%f[%w]TODO[^:]*:"] = { hl = "TodoTodo", sign_hl = "TodoSignTodo", icon = "" },
    ["%f[%w]NOTE[^:]*:"] = { hl = "TodoNote", sign_hl = "TodoSignNote", icon = "" },
    ["%f[%w]PERF[^:]*:"] = { hl = "TodoPerf", sign_hl = "TodoSignPerf", icon = "" },
  },
  show_sign = true,
}

-- name: keyword badge group, sign_name: sign group, src: group to take the color from
local function set_hl(text_hl, sign_hl, src)
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local signcol = vim.api.nvim_get_hl(0, { name = "SignColumn", link = false })
  local color = vim.api.nvim_get_hl(0, { name = src, link = false }).fg

  -- keyword text: colored badge (dark text on colored background)
  vim.api.nvim_set_hl(0, text_hl, {
    fg = normal.bg,
    bg = color,
    bold = true,
  })

  -- sign: colored icon on the sign column background
  vim.api.nvim_set_hl(0, sign_hl, {
    fg = color,
    bg = signcol.bg,
    bold = true,
  })
end

local function define_groups()
  vim.api.nvim_set_hl(0, "Todo", { link = "Comment" })

  set_hl("TodoFix", "TodoSignFix", "DiagnosticError")
  set_hl("TodoHack", "TodoSignHack", "DiagnosticWarn")
  set_hl("TodoTodo", "TodoSignTodo", "DiagnosticInfo")
  set_hl("TodoNote", "TodoSignNote", "DiagnosticHint")
  set_hl("TodoPerf", "TodoSignPerf", "DiagnosticOk")
end

local function in_comment(buf, row, col)
  -- row/col are 0-indexed
  -- 1) Treesitter: walk up from the node under the cursor position
  local ok, node = pcall(vim.treesitter.get_node, { bufnr = buf, pos = { row, col } })
  if ok and node then
    while node do
      if node:type():find("comment") then
        return true
      end
      node = node:parent()
    end
    return false
  end

  -- 2) Fallback: classic :syntax groups (no parser available)
  for _, id in ipairs(vim.fn.synstack(row + 1, col + 1)) do
    if vim.fn.synIDattr(vim.fn.synIDtrans(id), "name") == "Comment" then
      return true
    end
  end
  return false
end

local function refresh(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" then
    return
  end
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  -- make sure the syntax tree is current (matters for TextChangedI)
  local has_parser, parser = pcall(vim.treesitter.get_parser, buf)
  if has_parser and parser then
    parser:parse()
  end

  for row, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local first_s, first_e, first_p
    for pattern, p in pairs(config.keywords) do
      local init = 1
      while true do
        local s, e = line:find(pattern, init)
        if not s then
          break
        end
        -- only accept matches that sit inside a comment
        if in_comment(buf, row - 1, s - 1) then
          if not first_s or s < first_s then
            first_s, first_e, first_p = s, e, p
          end
          break -- earliest valid match for this pattern is enough
        end
        init = e + 1 -- not in a comment, keep looking on this line
      end
    end

    if first_p then
      vim.api.nvim_buf_set_extmark(buf, ns, row - 1, first_s - 1, {
        end_col = first_e,
        hl_group = first_p.hl,
        sign_text = config.show_sign and first_p.icon or nil,
        sign_hl_group = config.show_sign and first_p.sign_hl or nil,
        priority = 200,
      })
    end
  end
end

local group = vim.api.nvim_create_augroup("KeywordHighlight", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  desc = "Redefine custom Todo highlights",
  callback = function()
    define_groups()
    refresh(vim.api.nvim_get_current_buf())
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
  group = group,
  desc = "Refresh keyword highlights and signs",
  callback = function(ev)
    refresh(ev.buf)
  end,
})

define_groups()
refresh(vim.api.nvim_get_current_buf())
