local ns = vim.api.nvim_create_namespace("keyword_highlight")

autocmd({ "BufEnter", "Colorscheme" }, function()
  local nr = vim.api.nvim_get_hl(0, { name = "Comment" })
  vim.api.nvim_set_hl(0, "Todo", { fg = nr.fg, bg = nr.bg })
end, nil, fish_group, "Remove default Todo highlight")

-- Highlight groups (mini.hipatterns defined these for you; now we do)
local function define_groups()
  local function diag_fg(name)
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    return hl.fg
  end
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local function set(name, diag)
    vim.api.nvim_set_hl(0, name, { fg = normal.bg, bg = diag_fg(diag), bold = true })
  end
  set("KwFix", "DiagnosticError")
  set("KwHack", "DiagnosticWarn")
  set("KwTodo", "DiagnosticInfo")
  set("KwNote", "DiagnosticHint")
  set("KwPerf", "DiagnosticOk")
end
define_groups()
vim.api.nvim_create_autocmd("ColorScheme", { callback = define_groups })

-- FIX also covers FIXME because [^:]* consumes the "ME"
local keywords = {
  { "FIX", "KwFix" },
  { "HACK", "KwHack" },
  { "TODO", "KwTodo" },
  { "NOTE", "KwNote" },
  { "PERF", "KwPerf" },
}

-- Same idea as grep "TODO.*:" but stops at the first colon, with a word boundary
local patterns = {}
for _, k in ipairs(keywords) do
  patterns[#patterns + 1] = { "%f[%w]" .. k[1] .. "[^:]*:", k[2] }
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

-- -- TODO(local plugins): add a custom highlither here
--
-- -- Comment
-- -- TODO: this is a todo
-- -- FIX: this is a fix
-- -- FIXME: this is a fixme
-- -- PERF: this is a perf
-- -- NOTE: this is a note
--
-- -- green: #006000
--
-- autocmd({ "BufEnter", "Colorscheme" }, function()
--   local nr = vim.api.nvim_get_hl(0, { name = "Comment" })
--   vim.api.nvim_set_hl(0, "Todo", { fg = nr.fg, bg = nr.bg })
-- end, nil, fish_group, "Remove default Todo highlight")
--
-- later(function()
--   packadd("mini.nvim")
--
--   local censor_extmark_opts = function(_, match, _)
--     local mask = string.rep("x", vim.fn.strchars(match))
--     return {
--       virt_text = { { mask, "Comment" } },
--       virt_text_pos = "overlay",
--       priority = 200,
--       right_gravity = false,
--     }
--   end
--
--   -- require("mini.hipatterns").setup({
--   --   highlighters = {
--   --     censor = {
--   --       pattern = "password: ()%S+()",
--   --       group = "",
--   --       extmark_opts = censor_extmark_opts,
--   --     },
--   --   },
--   -- })
--
--   local hipatterns = require("mini.hipatterns")
--   hipatterns.setup({
--     highlighters = {
--       fix = { pattern = "%f[%w]FIXME[^:]*:", group = "MiniHipatternsFixme" },
--       fixme = { pattern = "%f[%w]FIX[^:]*:", group = "MiniHipatternsFixme" },
--       hack = { pattern = "%f[%w]HACK[^:]*:", group = "MiniHipatternsHack" },
--       todo = { pattern = "%f[%w]TODO[^:]*:", group = "MiniHipatternsTodo" },
--       note = { pattern = "%f[%w]NOTE[^:]*:", group = "MiniHipatternsNote" },
--       perf = { pattern = "%f[%w]PERF[^:]*:", group = "MiniIconsPurple" },
--       hex_color = hipatterns.gen_highlighter.hex_color(),
--       -- censor = {
--       --   pattern = "password: ()%S+()",
--       --   group = "",
--       --   extmark_opts = censor_extmark_opts,
--       -- },
--     },
--   })
-- end)
