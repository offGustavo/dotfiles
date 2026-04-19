local render_with_mode_color = require("extern.mode_colors").render_with_mode_color
local render_with_mode_color_inverted = require("extern.mode_colors").render_with_mode_color_inverted

local function fileName()
  local modified = vim.bo[0].modified
  local full_path = vim.fn.expand("%~:.")

  local file_name = vim.fn.fnamemodify(full_path, ":t")
  if file_name == "" then
    file_name = "[No Name]"
  end

  local file_path = vim.fn.fnamemodify(full_path, ":h")
  if file_path == "." then
    file_path = ""
  elseif file_path ~= "" then
    file_path = file_path .. "/"
  end

  if modified then
    return "%#Normal#" .. file_path .. "%#CursorLineNr#" .. file_name .. "%#Normal# "
  else
    return "%#Normal#" .. file_path .. "%#Normal#" .. file_name .. "%#Normal# "
  end
end

local function gitInfo()
  if vim.b.minigit_summary_string and vim.b.minidiff_summary_string then
    local diff_parts = vim.split(vim.b.minidiff_summary_string, " ")
    local highlighted_parts = {}

    for _, part in ipairs(diff_parts) do
      if part:match("^%+%d+") then
        -- Added lines: +1, +42, etc.
        table.insert(highlighted_parts, "%#StatuslineDiffAdd#" .. part)
      elseif part:match("^%~%d+") then
        -- Modified lines: ~1, ~42, etc.
        table.insert(highlighted_parts, "%#StatuslineDiffChange#" .. part)
      elseif part:match("^%-%d+") then
        -- Deleted lines: -1, -42, etc.
        table.insert(highlighted_parts, "%#StatuslineDiffDelete#" .. part)
      else
        -- Any other non-matching parts (shouldn't happen with normal diff output)
        table.insert(highlighted_parts, part)
      end
    end

    local highlighted_diff = table.concat(highlighted_parts, " ")
    return vim.b.minigit_summary_string .. " %#Normal#" .. highlighted_diff .. "%#Normal#"
  end
  return ""
end

local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()

  if recording_register == "" then
    return ""
  else
    return "%#CursorLineNr#@" .. recording_register .. "%#Normal# "
  end
end

function Fish.build_global_statusline()
  -- return render_with_mode_color_inverted("▊ ")
  return render_with_mode_color(" ")
      .. render_with_mode_color_inverted("  ")
      .. render_with_mode_color_inverted(" ")
      .. fileName()
      -- .. "%="
      .. "%l:%c %L:%p%% "
      .. "%="
      .. show_macro_recording()
      .. gitInfo()
      .. " %r "
      .. "%#Normal#"
      .. "%y "
      -- .. render_with_mode_color(" ▊")
      .. render_with_mode_color("  ")
end

-- FIXME: Quero usar o laststatus = 0, mas o nome do arquivo não fica salvo per janela
-- temporariamente vamos deixar assim(confia)
vim.o.laststatus = 3

vim.o.statusline = "%!v:lua.Fish.build_global_statusline()"
