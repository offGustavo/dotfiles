-- -- TODO(local plugins): add a custom highlither here
--
-- -- Comment
-- -- TODO: this is a todo
-- -- FIX: this is a fix
-- -- FIXME: this is a fixme
-- -- PERF: this is a perf
-- -- NOTE: this is a note

local ns = vim.api.nvim_create_namespace("keyword_highlight")
local config = {
  keywords = {
    { word = "FIX",   hl = "TodoFix",  icon = " " },
    { word = "BUG",   hl = "TodoFix",  icon = " " },
    { word = "ISSUE", hl = "TodoFix",  icon = " " },
    { word = "HACK",  hl = "TodoHack", icon = " " },
    { word = "TODO",  hl = "TodoTodo", icon = " " },
    { word = "NOTE",  hl = "TodoNote", icon = " " },
    { word = "PERF",  hl = "TodoPerf", icon = " " },
  },
}

---Create a new highlight
---@param name string highlight name to be created
---@param hl string highlight color to be used as background
local function set_hl(name, hl)
  vim.api.nvim_set_hl(0, name, {
    fg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg,
    bg = vim.api.nvim_get_hl(0, { name = hl, link = false }).fg,
    bold = true,
  })
end

--- Define 
local function define_groups()
  -- Clean Default Todo highlight
  set_hl("Todo", "Comment")

  -- Set new highlights
  set_hl("TodoFix", "DiagnosticError")
  set_hl("TodoHack", "DiagnosticWarn")
  set_hl("TodoTodo", "DiagnosticInfo")
  set_hl("TodoNote", "DiagnosticHint")
  set_hl("TodoPerf", "DiagnosticOk")
end

autocmd(
  { "BufEnter", "Colorscheme" },
  define_groups,
  nil,
  fish_group,
  "Remove default Todo highlight and Add Our Custom"
)

-- Same idea as grep "TODO.*:" but stops at the first colon, with a word boundary
local patterns = {}
for _, keyword in ipairs(config.keywords) do
  patterns[#patterns + 1] = { "%f[%w]" .. keyword.word .. "[^:]*:", keyword.hl }
end

vim.api.nvim_set_decoration_provider(ns, {
  on_win = function(_, _, bufnr)
    -- skip special buffers (terminals, prompts, etc.)
    return vim.bo[bufnr].buftype == ""
  end,
  on_line = function(_, _, bufnr, row)
    local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
    if not line or line == "" then
      return
    end

    for _, p in ipairs(patterns) do
      local init = 1
      while true do
        local s, e = line:find(p[1], init)
        if not s then
          break
        end
        vim.api.nvim_buf_set_extmark(bufnr, ns, row, s - 1, {
          end_col = e,
          hl_group = p[2],
          ephemeral = true,
          priority = 200,
        })
        init = e + 1
      end
    end
  end,
})
