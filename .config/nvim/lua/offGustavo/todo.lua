-- TODO: add a custom highlither here

-- Comment
-- TODO: this is a todo
-- FIX: this is a fix
-- FIXME: this is a fixme
-- PERF: this is a perf
-- NOTE: this is a note

-- green: #006000

autocmd({ "BufEnter", "Colorscheme" }, function()
  local nr = vim.api.nvim_get_hl(0, { name = "Comment" })
  vim.api.nvim_set_hl(0, "Todo", { fg = nr.fg, bg = nr.bg })
end, nil, fish_group, "Remove default Todo highlight")

later(function()
  packadd("mini.nvim")

  local censor_extmark_opts = function(_, match, _)
    local mask = string.rep("x", vim.fn.strchars(match))
    return {
      virt_text = { { mask, "Comment" } },
      virt_text_pos = "overlay",
      priority = 200,
      right_gravity = false,
    }
  end

  -- require("mini.hipatterns").setup({
  --   highlighters = {
  --     censor = {
  --       pattern = "password: ()%S+()",
  --       group = "",
  --       extmark_opts = censor_extmark_opts,
  --     },
  --   },
  -- })

  local hipatterns = require("mini.hipatterns")
  hipatterns.setup({
    highlighters = {
      fix = { pattern = "FIXME", group = "MiniHipatternsFixme" },
      fixme = { pattern = "FIX", group = "MiniHipatternsFixme" },
      hack = { pattern = "HACK", group = "MiniHipatternsHack" },
      todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
      note = { pattern = "NOTE", group = "MiniHipatternsNote" },
      perf = { pattern = "PERF", group = "MiniIconsPurple" },
      hex_color = hipatterns.gen_highlighter.hex_color(),
      -- censor = {
      --   pattern = "password: ()%S+()",
      --   group = "",
      --   extmark_opts = censor_extmark_opts,
      -- },
    },
  })
end)
