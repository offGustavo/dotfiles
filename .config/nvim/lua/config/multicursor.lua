-- vim.keymap.set("n", "<C-S-d>", ":g/<cword>/normal! Q<Cr>")
-- map {
--   { { "n", "x" }, "<M-q>", "Q" },
--   { "<C-m>", "q=" },
--   { "<C-K>", ":norm! Qk<Cr>" },
--   { "<C-J>", ":norm! Qj<Cr>" },
--   -- TODO: fix this
--   { "<C-p>", "#" },
--   { "<C-n>", "*" },
--   -- { "<C-;>", function ()
--   { "<C-,>", ":normal! Q#<Cr>" },
--   { "<C-.>", ":normal! Q*<Cr>" },
--   --   print"oi"
--   -- end, mode = "x" },
--   -- { "<C-;>", "<Cmd>MultipleCursorsAddMatchesV<Cr>" },
-- }

-- NOTE: See https://github.com/neovim/neovim/discussions/41997

_G.MultiCursor = {}

MultiCursor.pattern = nil

local ns_mc = vim.api.nvim_create_namespace("nvim.multicursor")
-- local ns_mc_cursor = vim.api.nvim_create_namespace("nvim.multicursor.cursor")
-- local ns_mc_visual = vim.api.nvim_create_namespace("nvim.multicursor.visual")

---@param buf integer
local get_main = function(buf)
  return vim.api.nvim_buf_call(buf, vim.pos.cursor)
end

---@param buf integer
---@param insert_main? boolean
MultiCursor.get_all = function(buf, insert_main)
  local extmarks = vim.api.nvim_buf_get_extmarks(buf, ns_mc, 0, -1)
  local to_pos = function(extm)
    return vim.pos.extmark(extm[1], extm[2], extm[3])
  end
  local mcursors = vim.tbl_map(to_pos, extmarks)
  local main = get_main(buf)
  if insert_main then
    table.insert(mcursors, main)
    table.sort(mcursors)
    vim.list.unique(mcursors)
  end
  return mcursors, main
end

---@param pos vim.Pos
MultiCursor.set = function(pos)
  vim.api.nvim_mcursor(pos.buf, pos:to_cursor())
end

---@param pos vim.Pos
MultiCursor.del = function(pos)
  local at = { pos:to_extmark() }
  local extmarks = vim.api.nvim_buf_get_extmarks(pos.buf, ns_mc, at, at)
  for _, extm in ipairs(extmarks) do
    local id = extm[1]
    vim.api.nvim_buf_del_extmark(pos.buf, ns_mc, id)
  end
end

---@param buf integer
MultiCursor.clear = function(buf)
  MultiCursor.pattern = nil
  vim.api.nvim_buf_clear_namespace(buf, ns_mc, 0, -1)
end

MultiCursor.actions = {}

---@param dir -1|1
---@param nowrap? boolean
MultiCursor.actions.jump_next = function(dir, nowrap)
  local mcursors = MultiCursor.get_all(0)
  local cursor = vim.pos.cursor()
  local count = vim.v.count1
  if nowrap then
    local before = vim.tbl_filter(function(pos)
      if dir > 0 then
        return pos > cursor
      else
        return pos < cursor
      end
    end, mcursors)
    count = math.min(#before, count)
  end
  -- BUG: Unwrap when resolved: https://github.com/neovim/neovim/issues/41995
  vim.cmd("norm! 2q=")
  vim.schedule(function()
    require("vim._core.mcursor").jump(dir > 0, count)
    vim.cmd("norm! 1q=")
  end)
  if #mcursors ~= #MultiCursor.get_all(0) then
    MultiCursor.del(cursor)
  end
end

---@param dir -1|1
MultiCursor.actions.line_add = function(dir)
  local mcursors = MultiCursor.get_all(0)
  local cursor = vim.pos.cursor()
  local at_edge = vim.tbl_isempty(mcursors)
    or (dir < 0 and cursor <= mcursors[1])
    or (dir > 0 and cursor >= mcursors[#mcursors])
  if at_edge then
    local line_count = vim.api.nvim_buf_line_count(0)
    local row = cursor.row + dir
    while row >= 0 and row < line_count do
      local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
      if cursor.col < math.max(#line, 1) then
        MultiCursor.set(cursor)
        vim.cmd("norm! 2q=")
        vim.api.nvim_win_set_cursor(0, { row + 1, cursor.col })
        vim.cmd("norm! 1q=")
        break
      end
      row = row + dir
    end
  else
    MultiCursor.actions.jump_next(dir, true)
    -- BUG: See `jump_next`
    vim.schedule(function()
      MultiCursor.del(cursor)
      MultiCursor.del(vim.pos.cursor())
    end)
  end
end

---@return string[]?, vim.Range?
local get_visual = function()
  local regtype = string.match(vim.api.nvim_get_mode().mode, "[vV\22]")
  if not regtype then
    return
  end
  local vpos, cpos = vim.fn.getpos("v"), vim.fn.getpos(".")
  local reg = vim.fn.getregion(vpos, cpos, { type = regtype, exclusive = false })
  local regpos = vim.fn.getregionpos(vpos, cpos, { type = regtype, exclusive = false, eol = false, bounds = true })
  local line1, col1 = regpos[1][1][2], regpos[1][1][3]
  local line2, col2 = regpos[#regpos][2][2], regpos[#regpos][2][3]
  local range = vim.range(0, line1 - 1, col1 - 1, line2 - 1, col2)
  return reg, range
end

---@param pattern string
local matchpos_current = function(pattern)
  local pos = function(flags)
    local row, col = unpack(vim.fn.searchpos(pattern, flags))
    return vim.pos(0, row - 1, col - 1)
  end
  local back_end, back_start, forw_end = pos("benW"), pos("bcnW"), pos("cenW")
  local cursor = vim.pos.cursor()
  if back_end >= back_start or cursor < back_start or cursor > forw_end then
    return
  end
  return back_start, forw_end
end

---@param pattern string
local set_search = function(pattern, hlsearch)
  MultiCursor.pattern = pattern
  vim.fn.setreg("/", pattern)
  vim.v.hlsearch = hlsearch or 0
end

---@param force boolean
local expand_search = function(force)
  local reg = vim.fn.getreg("/")
  if not force and vim.v.hlsearch == 1 and reg ~= "" then
    return reg
  end
  local stored = MultiCursor.pattern
  if not force and stored and stored ~= "" then
    return stored
  end
  local vis = get_visual()
  if vis then
    return vis[1]
  end
  local cpos = vim.fn.getpos(".")
  local char = vim.fn.getregion(cpos, cpos)[1]
  if vim.fn.matchstr(char, [[\k]]) ~= "" then
    return [[\<]] .. vim.fn.expand("<cword>") .. [[\>]]
  end
  return [[\V]] .. char
end

---@param force boolean
local search_cursor = function(force, hlsearch)
  local vis = get_visual()
  local pattern = vis and vis[1] or expand_search(force)
  local cursor_match = matchpos_current(pattern)
  if not cursor_match then
    return nil, {}, {}
  end
  if vis then
    vim.cmd("norm! " .. vim.keycode("<Esc>"))
  end
  set_search(pattern, hlsearch)
  vim.cmd("norm! 2q=")
  vim.api.nvim_win_set_cursor(0, cursor_match:to_cursor())
  return pattern, cursor_match, vis
end

MultiCursor.actions.search_current = function()
  search_cursor(true, 1)
end

---@param dir -1|1
---@param add boolean
local match_next = function(dir, add)
  local pattern, cursor_match, vis = search_cursor(true)
  if not pattern then
    return
  end
  if add then
    MultiCursor.set(cursor_match)
  end
  vim.fn.search(pattern, (dir < 0 and "b" or "") .. "W")
  vim.cmd("norm! 1q=")
  if vis then
    vim.cmd("norm! gn")
  end
end

---@param dir -1|1
MultiCursor.actions.match_add = function(dir)
  match_next(dir, true)
end
---@param dir -1|1
MultiCursor.actions.match_skip = function(dir)
  match_next(dir, false)
end

_G.MiniInput = _G.MiniInput

---@param on_confirm fun(input?: string)
---@param on_change? fun(input?: string)
MultiCursor.input = function(opts, on_confirm, on_change)
  on_change = on_change or function() end
  if MiniInput then
    local input = MiniInput.get({
      completion = opts.completion,
      prompt = opts.prompt,
      scope = opts.scope,
      init_keys = { opts.default },
      handlers = {
        key = function(state, key)
          state = MiniInput.default_key(state, key) or state
          on_change(state.input)
          return state
        end,
      },
    })
    on_confirm(input)
  else
    local au_input = vim.api.nvim_create_augroup("multicursor/input", { clear = true })
    vim.api.nvim_create_autocmd("CmdlineChanged", {
      group = au_input,
      callback = function()
        local input = vim.fn.getcmdline()
        on_change(input)
        -- HACK: Needed to update `/` search highlight
        vim.api.nvim__redraw({ flush = true })
      end,
    })
    vim.ui.input(opts, function(input)
      vim.api.nvim_clear_autocmds({ group = au_input })
      on_confirm(input)
    end)
  end
end

---@param pattern? string
---@param range? vim.Range
MultiCursor.actions.search = function(pattern, range, _cursor)
  local vis, vis_range = get_visual()
  range = range or vis_range
  local line_count = vim.api.nvim_buf_line_count(0)
  local filter = ""
  if range and not (range.start_row == 0 and range.end_row == line_count - 1) then
    -- PERF: Use line ranges
    local r1, r2 = range.start_row + 1, range.end_row + 1
    filter = string.gsub([[\%>{R1}l\%<{R2}l]], "{(%w+)}", {
      R1 = r1 - 1,
      R2 = r2 + 1,
    })
  end
  local to_search = function(input)
    return filter .. input
  end
  local restore_pattern = vim.fn.getreg("/")
  local on_confirm = function(input)
    input = input or ""
    local search = to_search(input)
    if input == "" or vim.fn.search(search, "nw") < 1 then
      set_search(restore_pattern, 0)
      if _cursor then
        vim.api.nvim_win_set_cursor(0, _cursor:to_cursor())
      end
      return
    end
    set_search(search)
    -- vim.fn.histadd("search", pattern)
    if vis then
      vim.cmd("norm! " .. vim.keycode("<Esc>"))
    end
    local hlsearch = vim.v.hlsearch
    vim.cmd("silent! norm! 2q=1n1Q1q=")
    vim.v.hlsearch = hlsearch
    MultiCursor.del(vim.pos.cursor())
    -- if vis then
    --   vim.cmd("norm! gn")
    -- end
  end
  local on_change = function(input)
    local search = input ~= "" and to_search(input) or ""
    set_search(search, 1)
  end
  if pattern then
    on_confirm(pattern)
  else
    MultiCursor.input({ prompt = "Match: " }, on_confirm, on_change)
  end
end

-- NOTE: Range search: `<key>ip` creates cursors at pattern matches in the paragraph
MultiCursor.actions.search_operator = function()
  local cursor = vim.pos.cursor()
  local on_operator = function()
    local pos1 = vim.fn.getpos("'[")
    local pos2 = vim.fn.getpos("']")
    local range = vim.range(0, pos1[2] - 1, pos1[3] - 1, pos2[2] - 1, pos2[3])
    MultiCursor.actions.search(nil, range, cursor)
  end
  vim.go.operatorfunc = on_operator ---@diagnostic disable-line
  return "g@"
end

-- NOTE: Counted motions: `3<key>j` = `QjQjQj`, `2<key>w` = `QwQw`
--
-- ```lua
-- vim.keymap.set("n", "Q", function()
--   return vim.v.count > 0 and MultiCursor.actions.motion_operator() or "Q"
-- end, { expr = true })
-- ```
MultiCursor.actions.motion_operator = function()
  local on_atom = function(e)
    local d = e.data
    if d.type == "operator" then
      for _ = 1, d.count or 1 do
        vim.api.nvim_mcursor(0, vim.pos.cursor():to_cursor())
        vim.cmd("norm " .. d.cmd)
      end
      vim.cmd("norm! 1q=")
    end
  end
  vim.api.nvim_create_autocmd("CmdAtom", { once = true, callback = on_atom })
  vim.go.operatorfunc = function() end ---@diagnostic disable-line
  return "g@"
end

MultiCursor.actions.align = function()
  local mcursors, cursor = MultiCursor.get_all(0, true)
  ---@type vim.Pos
  local rightmost = vim.iter(mcursors):fold(cursor, function(max, mc)
    return mc.col >= max.col and mc or max
  end)
  for _, mc in ipairs(mcursors) do
    local delta = rightmost.col - mc.col
    if delta > 0 then
      local pad = string.rep(" ", delta)
      vim.api.nvim_buf_set_text(0, mc.row, mc.col, mc.row, mc.col, { pad })
    end
  end
end

MultiCursor.actions.split_visual = function()
  -- How?
end

vim.keymap.set("n", "<Esc>", function()
  MultiCursor.clear(0)
  vim.cmd("nohls")
  return "<Esc>"
end, { expr = true, desc = "Clear on <Esc>" })
                          
-- stylua: ignore star   t
vim.keymap.set({ "n", "x" }, "<C-8>", function() MultiCursor.actions.search_current() end, { desc = "Expand search" }) -- <C-*>
-- vim.keymap.set("n", "<S-Right>", function() MultiCursor.actions.jump_next(1) end, { desc = "Cursors: next" })
-- vim.keymap.set("n", "<S-Left>", function() MultiCursor.actions.jump_next(-1) end, { desc = "Cursors: previous" })
-- vim.keymap.set("n", "<S-Down>", function() MultiCursor.actions.line_add(1) end, { desc = "Cursors: add below" })
-- vim.keymap.set("n", "<S-Up>", function() MultiCursor.actions.line_add(-1) end, { desc = "Cursors: add above" })
vim.keymap.set("n", "<C-S-j>", function() MultiCursor.actions.line_add(1) end, { desc = "Cursors: add below" })
vim.keymap.set("n", "<C-S-k>", function() MultiCursor.actions.line_add(-1) end, { desc = "Cursors: add above" })
-- vim.keymap.set({ "n", "x" }, "<Right>", function() MultiCursor.actions.match_add(1) end, { desc = "Cursors: add match next" })
-- vim.keymap.set({ "n", "x" }, "<Left>", function() MultiCursor.actions.match_add(-1) end, { desc = "Cursors: add match previous" })
-- vim.keymap.set({ "n", "x" }, "<Down>", function() MultiCursor.actions.match_skip(1) end, { desc = "Cursors: skip match next" })
-- vim.keymap.set({ "n", "x" }, "<Up>", function() MultiCursor.actions.match_skip(-1) end, { desc = "Cursors: skip match previous" })
vim.keymap.set({ "n", "x" }, "<C-.>", function() MultiCursor.actions.match_add(1) end, { desc = "Cursors: add match next" })
vim.keymap.set({ "n", "x" }, "<C-,>", function() MultiCursor.actions.match_add(-1) end, { desc = "Cursors: add match previous" })
vim.keymap.set({ "n", "x" }, "<C-n>", function() MultiCursor.actions.match_skip(1) end, { desc = "Cursors: skip match next" })
vim.keymap.set({ "n", "x" }, "<C-p>", function() MultiCursor.actions.match_skip(-1) end, { desc = "Cursors: skip match previous" })
-- vim.keymap.set("x", "gm", function() MultiCursor.actions.search() end, { desc = "Cursors: match search" })
-- vim.keymap.set("n", "gm", MultiCursor.actions.search_operator, { expr = true, desc = "Cursors: match search" })
vim.keymap.set("n", "gQ", function() MultiCursor.actions.align() end, { desc = "Cursors: align" })
