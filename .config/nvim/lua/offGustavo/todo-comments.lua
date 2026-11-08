-- -- Comment
-- -- TODO:
-- -- FIX:
-- -- FIXME():
-- -- ISSUE(test):
-- -- PERF:
-- -- NOTE:
-- -- TASK:
-- -- TASK(20261108-1218):

local ns = vim.api.nvim_create_namespace("keyword_highlight")

---------------------------------------------------------------------------
-- Config
---------------------------------------------------------------------------
local config = {
  show_sign = true,
  styles = {
    fix = { text_hl = "TodoFix", sign_hl = "TodoSignFix", ref = "DiagnosticError", icon = "" },
    hack = { text_hl = "TodoHack", sign_hl = "TodoSignHack", ref = "DiagnosticWarn", icon = "" },
    note = { text_hl = "TodoNote", sign_hl = "TodoSignNote", ref = "DiagnosticHint", icon = "" },
    perf = { text_hl = "TodoPerf", sign_hl = "TodoSignPerf", ref = "DiagnosticOk", icon = "" },
    todo = { text_hl = "TodoTodo", sign_hl = "TodoSignTodo", ref = "DiagnosticInfo", icon = "" },
    task = { text_hl = "TodoTask", sign_hl = "TodoSignTask", ref = "Boolean", icon = "" },
  },
  keywords = {
    FIX = "fix",
    BUG = "fix",
    ISSUE = "fix",
    HACK = "hack",
    NOTE = "note",
    PERF = "perf",
    TASK = "task",
    TODO = "todo",
  },
}

---------------------------------------------------------------------------
-- Matchers: one Lua pattern per keyword, built once
---------------------------------------------------------------------------

-- Matches e.g. "TODO:", "FIXME():", "ISSUE(test):", "TASK(20261108-1218):"
local function build_matchers()
  local matchers = {}
  for word, style_name in pairs(config.keywords) do
    matchers[#matchers + 1] = {
      pattern = "%f[%w]" .. word .. "[^:%s]*:",
      style = config.styles[style_name],
    }
  end
  return matchers
end

local matchers = build_matchers()

---------------------------------------------------------------------------
-- Highlight groups
---------------------------------------------------------------------------

local function set_style_hl(style)
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local signcol = vim.api.nvim_get_hl(0, { name = "SignColumn", link = false })
  local color = vim.api.nvim_get_hl(0, { name = style.ref, link = false }).fg

  -- keyword text: dark text on a colored badge
  vim.api.nvim_set_hl(0, style.text_hl, { fg = normal.bg, bg = color, bold = true })
  -- sign: colored icon on the sign column background
  vim.api.nvim_set_hl(0, style.sign_hl, { fg = color, bg = signcol.bg, bold = true })
end

local function define_groups()
  vim.api.nvim_set_hl(0, "Todo", { link = "Comment" })
  for _, style in pairs(config.styles) do
    set_style_hl(style)
  end
end

---------------------------------------------------------------------------
-- Comment detection
---------------------------------------------------------------------------

-- row/col are 0-indexed
local function in_comment(buf, row, col)
  -- 1) Treesitter: walk up from the node under the position
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

---------------------------------------------------------------------------
-- Matching
---------------------------------------------------------------------------

-- Returns the earliest keyword match on `line` that sits inside a comment.
-- Result: { start = 1-indexed, finish = 1-indexed inclusive, style = table } or nil
local function find_keyword(buf, row, line)
  local best

  for _, m in ipairs(matchers) do
    local init = 1
    while true do
      local s, e = line:find(m.pattern, init)
      if not s then
        break
      end
      if in_comment(buf, row, s - 1) then
        if not best or s < best.start then
          best = { start = s, finish = e, style = m.style }
        end
        break -- earliest valid match for this pattern is enough
      end
      init = e + 1 -- not in a comment; keep looking on this line
    end
  end

  return best
end

---------------------------------------------------------------------------
-- Rendering
---------------------------------------------------------------------------

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

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for i, line in ipairs(lines) do
    local row = i - 1 -- 0-indexed
    local hit = find_keyword(buf, row, line)

    if hit then
      local style = hit.style
      vim.api.nvim_buf_set_extmark(buf, ns, row, hit.start - 1, {
        end_col = hit.finish,
        hl_group = style.text_hl,
        sign_text = config.show_sign and style.icon or nil,
        sign_hl_group = config.show_sign and style.sign_hl or nil,
        priority = 200,
      })
    end
  end
end

---------------------------------------------------------------------------
-- Autocmds & initial run
---------------------------------------------------------------------------

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
