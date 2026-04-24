-- TODO: move this functions back to this file...
local render_with_mode_color = require("fish.mode_colors").render_with_mode_color
local render_with_mode_color_inverted = require("fish.mode_colors").render_with_mode_color_inverted

local function get_file_name()
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
    return "%<" .. file_path .. "%>" .. "%#CursorLineNr#" .. file_name .. " "
  else
    return "%<" .. file_path .. "%>" .. file_name .. " "
  end
end

local function git_info()
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
    return vim.b.minigit_summary_string .. " %#Normal#" .. highlighted_diff .. "%#Normal# "
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

local function lsp_diagnostics()
  if not Fish.did_lsp_setup then
    return ""
  end
  local info = vim.diagnostic.status()
  if info == ""
  then
    return ""
  end
  return info .. " "
end

-- TODO: if lsp crash, should turn red...
local function lsp_info()
  if not Fish.did_lsp_setup then
    return ""
  end
  local msg = ""
  -- local msg = "No Active Lsp"
  local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
  local clients = vim.lsp.get_clients()
  if next(clients) == nil then
    return msg
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return client.name .. " "
    end
  end
  return msg
end

local function fileformat()
  local format = vim.bo.fileformat
  if format == "" then
    return
  end
  format = format .. " "
  return format:upper()
end

function Fish.build_statusline()
  return render_with_mode_color(" ")
      .. render_with_mode_color_inverted("  ")
      .. "%#Normal#"
      .. get_file_name()
      .. "%#Normal#"
      .. lsp_diagnostics()
      .. "%l:%c %L:%p%% "
      .. "%="
      .. show_macro_recording()
      .. git_info()
      -- .. "%S "
      -- .. "%r "
      .. "%#Normal#"
      .. "%y "
      .. lsp_info()
      .. fileformat()
      .. render_with_mode_color("  ")
end

function Fish.build_statusline_inactive()
  local active_win = vim.fn.win_getid()
  local status_win = vim.g.statusline_winid
  if status_win ~= active_win then
    return render_with_mode_color(" ")
        .. render_with_mode_color_inverted("   ")
        .. "%#StatusLineNC#"
        .. get_file_name()
        .. "%#StatusLineNC#"
        .. "%l:%c %L:%p%%"
        .. "%="
        .. render_with_mode_color("  ")
  end
end

-- FIXME: Quero usar o laststatus = 0, mas o nome do arquivo não fica salvo per janela
vim.o.laststatus = 3
vim.o.showmode = false


-- set statusline=%<%f\ %h%w%m%r\ %{%\ v:lua.require('vim._core.util').term_exitcode()\ %}%=%{%\ luaeval('(package.loaded[''vim.ui'']\ and\ vim.api.nvim_get_current_win()\ ==\ tonumber(vim.g.actual_curwin\ or\ -1)\ and\ vim.ui.progress_status())\ or\ ''''\ ')%}%{%\ &showcmdloc\ ==\ 'statusline'\ ?\ '%-10.S\ '\ :\ ''\ %}%{%\ exists('b:keymap_name')\ ?\ '<'..b:keymap_name..'>\ '\ :\ ''\ %}%{%\ &busy\ >\ 0\ ?\ '◐\ '\ :\ ''\ %}%{%\ luaeval('(package.loaded[''vim.diagnostic'']\ and\ next(vim.diagnostic.count())\ and\ vim.diagnostic.status()\ ..\ ''\ '')\ or\ ''''\ ')\ %}%{%\ &ruler\ ?\ (\ &rulerformat\ ==\ ''\ ?\ '%-14.(%l,%c%V%)\ %P'\ :\ &rulerformat\ )\ :\ ''\ %}
-- vim.o.statusline = "%!v:lua.Fish.build_statusline()"

-- From mini.statusline
-- -- Set statusline globally and dynamically decide which content to use
vim.go.statusline =
'%{%(nvim_get_current_win()==#g:actual_curwin || &laststatus==3) ? v:lua.Fish.build_statusline() : v:lua.Fish.build_statusline_inactive()%}'
