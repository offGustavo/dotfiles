local M = {}
-- https://www.reddit.com/r/neovim/comments/1t828uv/how_to_use_quickfix_list/

function M.qf_format(info)
  local items
  if info.quickfix == 1 then
    items = vim.fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end

  -- Collect raw fields for the slice we need to render
  local rows = {}
  for i = info.start_idx, info.end_idx do
    local e  = items[i]
    local fname = e.bufnr > 0
        and vim.fn.fnamemodify(vim.fn.bufname(e.bufnr), ":.")
        or  ""
    local lnum = e.lnum  > 0 and tostring(e.lnum)  or "-"
    local col  = e.col   > 0 and tostring(e.col)   or "-"
    local msg  = vim.trim(e.text)
    rows[#rows + 1] = { fname, lnum, col, msg }
  end

  -- Compute column widths for alignment
  local w = { 0, 0, 0 }
  for _, r in ipairs(rows) do
    w[1] = math.max(w[1], #r[1])
    w[2] = math.max(w[2], #r[2])
    w[3] = math.max(w[3], #r[3])
  end

  -- Build output lines
  local lines = {}
  for _, r in ipairs(rows) do
    lines[#lines + 1] = string.format(
      "%#Directory#%-" .. w[1] .. "s%#Normal#:%#Number#%-" .. w[2] .. "s%#Normal#:%#Number#%-" .. w[3] .. "s: %s",
      r[1], r[2], r[3], r[4]
    )
  end
  return lines
end

return M

-- Source - https://stackoverflow.com/a/79596365
-- Posted by Carson, modified by community. See post 'Timeline' for change history
-- Retrieved 2026-05-10, License - CC BY-SA 4.0

function _G.qftf(info)
  local items
  local ret = {}

  if info.quickfix == 1 then
    items = vim.fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local valid_fmt = "%s:%d:%d:%s %s" -- filepath : line : col : type : text

  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ""
    local str

    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = vim.fn.bufname(e.bufnr)
        if fname == "" then
          fname = "[No Name]"
        else
          fname = fname:gsub("^" .. vim.env.HOME, "~")
        end
      end
      local lnum = e.lnum
      local col = e.col
      local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
      str = valid_fmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end

  return ret
end

-- Source - https://stackoverflow.com/a/79596365
-- Posted by Carson, modified by community. See post 'Timeline' for change history
-- Retrieved 2026-05-10, License - CC BY-SA 4.0

vim.o.quickfixtextfunc = "{info -> v:lua._G.qftf(info)}"

