-- helix.lua: a Helix keybind/paradigm emulation layer for Neovim (>= 0.10)
--
-- Paradigm: Helix is "selection -> action". Neovim's Visual mode is used as the
-- selection. In Normal mode, motions *create* a selection (so `w` then `d` works
-- exactly like Helix). After a selection exists:
--   * a motion starts a NEW selection from the cursor   (Helix normal mode)
--   * `v` toggles "select mode", where motions EXTEND   (Helix select mode)
--
-- Usage:
--   require("helix").setup()
-- Tweak or add bindings before setup() through `require("helix").keymaps`.

local M = {}

local api, fn = vim.api, vim.fn

M.extend = false -- true while in Helix "select mode"
M.enabled = false

---------------------------------------------------------------------------
-- helpers
---------------------------------------------------------------------------

local function t(keys)
  return api.nvim_replace_termcodes(keys, true, false, true)
end

local function feed(keys)
  vim.cmd.normal({ args = { t(keys) }, bang = true })
end

local function in_visual()
  return fn.mode():match("^[vV\22]") ~= nil
end

local function char_under_cursor()
  local col = fn.col(".")
  return fn.getline("."):sub(col, col)
end

--- Selection bounds as 0-based, end-inclusive (srow, scol, erow, ecol).
local function selection()
  local a, b = fn.getpos("v"), fn.getpos(".")
  local s, e = a, b
  if a[2] > b[2] or (a[2] == b[2] and a[3] > b[3]) then s, e = b, a end
  local srow, scol, erow, ecol = s[2] - 1, s[3] - 1, e[2] - 1, e[3] - 1
  if fn.mode() == "V" then
    scol = 0
    ecol = math.max(#fn.getline(erow + 1) - 1, 0)
  end
  return srow, scol, erow, ecol
end

local function leave_visual()
  if in_visual() then feed("<Esc>") end
end

--- Cursor is the "head". Return true if the head is before the anchor.
local function head_first()
  local a, b = fn.getpos("v"), fn.getpos(".")
  return b[2] < a[2] or (b[2] == a[2] and b[3] < a[3])
end

local function pick(builtin, fallback)
  return function()
    local ok, tb = pcall(require, "telescope.builtin")
    if ok and tb[builtin] then return tb[builtin]() end
    vim.cmd(fallback)
  end
end

---------------------------------------------------------------------------
-- motion builders
---------------------------------------------------------------------------

--- Motion that CREATES a selection (w, b, e, f, t, ...).
--- Normal: `v` + motion. Visual: extend in select mode, else new selection.
local function select_motion(keys, opts)
  opts = opts or {}
  return function()
    local char
    if opts.char then
      char = fn.getcharstr()
      if char == "\27" then return end
    end
    local was_visual = in_visual()
    if was_visual and not M.extend then
      feed("<Esc>")
      -- Helix starts the next `e` just after the previous selection
      if opts.step and fn.col(".") < fn.col("$") - 1 then feed("l") end
    end
    -- continuing from "foo |" -> start at the next word, like Helix
    if was_visual and opts.skip_blank and char_under_cursor():match("%s") then
      feed(opts.skip_blank)
    end
    if not in_visual() then feed("v") end
    local start_row, start_col = unpack(api.nvim_win_get_cursor(0))
    feed(keys .. (char or ""))
    if opts.trim then
      -- Helix `w` stops before the next word start; Vim lands on it
      local row, col = unpack(api.nvim_win_get_cursor(0))
      if row ~= start_row then
        local prev = row - 1
        api.nvim_win_set_cursor(0, { prev, math.max(#fn.getline(prev) - 1, 0) })
      elseif col > start_col then
        feed("h")
      end
    end
  end
end

--- Motion that MOVES the cursor (h j k l gh gl ...): collapses the selection
--- unless in select mode.
local function move(keys)
  return function()
    if in_visual() and not M.extend then feed("<Esc>") end
    feed(keys)
  end
end

--- Run a function with the selection collapsed to a usable state.
local function collapse() leave_visual() end

---------------------------------------------------------------------------
-- search
---------------------------------------------------------------------------

local function select_match(backward)
  return function()
    local pat = fn.getreg("/")
    if pat == "" then return end
    local extending = in_visual() and M.extend
    if in_visual() and not extending then
      -- search relative to the selection edge we are moving away from
      if backward ~= head_first() then feed("o") end
      feed("<Esc>")
    end
    if fn.search(pat, backward and "bW" or "W") == 0 then return end
    local e = fn.searchpos(pat, "cenW")
    if backward then
      -- select the match, head at its start
      if not in_visual() then
        api.nvim_win_set_cursor(0, { e[1], math.max(e[2] - 1, 0) })
        feed("v")
        fn.search(pat, "bcW")
      end
    else
      if not in_visual() then feed("v") end
      api.nvim_win_set_cursor(0, { e[1], math.max(e[2] - 1, 0) })
    end
  end
end

local function search_selection()
  local text, pat
  if in_visual() then
    local srow, scol, erow, ecol = selection()
    text = table.concat(api.nvim_buf_get_text(0, srow, scol, erow, ecol + 1, {}), "\n")
    pat = [[\V]] .. fn.escape(text, [[\]]):gsub("\n", [[\n]])
  else
    text = fn.expand("<cword>")
    if text == "" then return end
    pat = [[\V\<]] .. fn.escape(text, [[\]]) .. [[\>]]
  end
  fn.setreg("/", pat)
  vim.o.hlsearch = true
end

---------------------------------------------------------------------------
-- insert / paste relative to the selection
---------------------------------------------------------------------------

local function insert_at(where)
  return function()
    if not in_visual() then
      return feed(where == "start" and "i" or "a")
    end
    local linewise = fn.mode() == "V"
    -- put the cursor on the requested end of the selection
    if (where == "start") ~= head_first() then feed("o") end
    feed("<Esc>")
    if where == "start" then
      if linewise then feed("0") end
      vim.cmd.startinsert()
    elseif linewise or fn.col(".") >= fn.col("$") - 1 then
      vim.cmd.startinsert({ bang = true })
    else
      local pos = api.nvim_win_get_cursor(0)
      api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
      vim.cmd.startinsert()
    end
  end
end

local function paste_at(where, key)
  return function()
    if not in_visual() then return feed(key) end
    local hf = head_first()
    if (where == "start") ~= hf then feed("o") end
    feed("<Esc>" .. key)
  end
end

---------------------------------------------------------------------------
-- match mode: surround + text objects
---------------------------------------------------------------------------

local pairs_map = {
  ["("] = { "(", ")" }, [")"] = { "(", ")" }, b = { "(", ")" },
  ["["] = { "[", "]" }, ["]"] = { "[", "]" },
  ["{"] = { "{", "}" }, ["}"] = { "{", "}" }, B = { "{", "}" },
  ["<"] = { "<", ">" }, [">"] = { "<", ">" },
}

local function pair_of(ch)
  return pairs_map[ch] or { ch, ch }
end

local function surround_add()
  local ch = fn.getcharstr()
  if ch == "\27" then return end
  local p = pair_of(ch)
  local srow, scol, erow, ecol
  if in_visual() then
    srow, scol, erow, ecol = selection()
  else
    local pos = api.nvim_win_get_cursor(0)
    srow, scol, erow, ecol = pos[1] - 1, pos[2], pos[1] - 1, pos[2]
  end
  collapse()
  -- close first so the start offsets stay valid
  api.nvim_buf_set_text(0, erow, ecol + 1, erow, ecol + 1, { p[2] })
  api.nvim_buf_set_text(0, srow, scol, srow, scol, { p[1] })
end

--- Locate the pair of `ch` around the cursor -> open{row,col}, close{row,col} (1-based).
local function find_surround(ch)
  local p = pair_of(ch)
  local save = api.nvim_win_get_cursor(0)
  local open, close
  if p[1] == p[2] then
    local line = fn.getline(".")
    local col = save[2] + 1
    local s = col
    while s > 0 and line:sub(s, s) ~= p[1] do s = s - 1 end
    local e = line:find(p[1], col + 1, true)
    if s > 0 and e then open, close = { save[1], s }, { save[1], e } end
  else
    local o, c = [[\V]] .. p[1], [[\V]] .. p[2]
    local here = char_under_cursor()
    local op = here == p[1] and { save[1], save[2] + 1 } or fn.searchpairpos(o, "", c, "bnW")
    local cl = here == p[2] and { save[1], save[2] + 1 } or fn.searchpairpos(o, "", c, "nW")
    if op[1] ~= 0 and cl[1] ~= 0 then open, close = op, cl end
  end
  return open, close
end

local function surround_delete()
  local ch = fn.getcharstr()
  local open, close = find_surround(ch)
  collapse()
  if not open then return end
  api.nvim_buf_set_text(0, close[1] - 1, close[2] - 1, close[1] - 1, close[2], {})
  api.nvim_buf_set_text(0, open[1] - 1, open[2] - 1, open[1] - 1, open[2], {})
end

local function surround_replace()
  local from = fn.getcharstr()
  local to = fn.getcharstr()
  local open, close = find_surround(from)
  collapse()
  if not open then return end
  local p = pair_of(to)
  api.nvim_buf_set_text(0, close[1] - 1, close[2] - 1, close[1] - 1, close[2], { p[2] })
  api.nvim_buf_set_text(0, open[1] - 1, open[2] - 1, open[1] - 1, open[2], { p[1] })
end

local obj_alias = {
  w = "w", W = "W", p = "p", s = "s", t = "t",
  ["("] = "(", [")"] = "(", b = "(", ["["] = "[", ["]"] = "[",
  ["{"] = "{", ["}"] = "{", B = "{", ["<"] = "<", [">"] = "<",
  ['"'] = '"', ["'"] = "'", ["`"] = "`",
}

local function textobject(kind) -- kind = "i" | "a"
  return function()
    local ch = fn.getcharstr()
    local obj = obj_alias[ch]
    if not obj then return end
    if in_visual() and not M.extend then feed("<Esc>") end
    if not in_visual() then feed("v") end
    feed(kind .. obj)
  end
end

---------------------------------------------------------------------------
-- keymaps   { mode, lhs, rhs, opts? }      (mode may be a table)
---------------------------------------------------------------------------

local nx = { "n", "x" }

local keymaps = {
  -- select mode ---------------------------------------------------------
  { "n", "v", function() feed("v"); M.extend = true end, { desc = "select mode" } },
  { "x", "v", function() M.extend = not M.extend end, { desc = "toggle select mode" } },
  { "x", "<Esc>", "<Esc>", { desc = "collapse selection" } },
  { "x", ";", "<Esc>", { desc = "collapse selection" } },
  { "n", ";", "<Nop>", { desc = "collapse selection" } },
  { "x", "<A-;>", "o", { desc = "flip selection" } },

  -- movement (cursor) -----------------------------------------------------
  { nx, "h", move("h"), { desc = "left" } },
  { nx, "j", move("gj"), { desc = "down" } },
  { nx, "k", move("gk"), { desc = "up" } },
  { nx, "l", move("l"), { desc = "right" } },
  { nx, "gh", move("0"), { desc = "left" } },

  -- word motions (selection) --------------------------------------------
  { nx, "w", select_motion("w", { trim = true, skip_blank = "w" }), { desc = "next word start" } },
  { nx, "W", select_motion("W", { trim = true, skip_blank = "W" }), { desc = "next WORD start" } },
  { nx, "b", select_motion("b"), { desc = "prev word start" } },
  { nx, "B", select_motion("B"), { desc = "prev WORD start" } },
  { nx, "e", select_motion("e", { step = true }), { desc = "next word end" } },
  { nx, "E", select_motion("E", { step = true }), { desc = "next WORD end" } },

  -- find char -------------------------------------------------------------
  { nx, "f", select_motion("f", { char = true }), { desc = "find char" } },
  { nx, "t", select_motion("t", { char = true }), { desc = "till char" } },
  { nx, "F", select_motion("F", { char = true }), { desc = "find prev char" } },
  { nx, "T", select_motion("T", { char = true }), { desc = "till prev char" } },
  { nx, "<A-.>", ";", { desc = "repeat last find", remap = false } },

  -- goto mode -------------------------------------------------------------
  { nx, "gg", move("gg"), { desc = "file start" } },
  { nx, "ge", move("G"), { desc = "file end" } },
  { nx, "gh", move("0"), { desc = "line start" } },
  { nx, "gl", move("$"), { desc = "line end" } },
  { nx, "gs", move("^"), { desc = "first non-blank" } },
  { nx, "gt", move("H"), { desc = "window top" } },
  { nx, "gc", move("M"), { desc = "window center" } },
  { nx, "gb", move("L"), { desc = "window bottom" } },
  { nx, "ga", "<C-^>", { desc = "last accessed file" } },
  { nx, "gn", "<Cmd>bnext<CR>", { desc = "next buffer" } },
  { nx, "gp", "<Cmd>bprevious<CR>", { desc = "prev buffer" } },
  { nx, "g.", "`.", { desc = "last modification" } },
  { nx, "gd", function() vim.lsp.buf.definition() end, { desc = "definition" } },
  { nx, "gD", function() vim.lsp.buf.declaration() end, { desc = "declaration" } },
  { nx, "gy", function() vim.lsp.buf.type_definition() end, { desc = "type definition" } },
  { nx, "gr", function() vim.lsp.buf.references() end, { desc = "references" } },
  { nx, "gi", function() vim.lsp.buf.implementation() end, { desc = "implementation" } },

  -- line / whole-file selection ---------------------------------------------
  { "n", "x", "V", { desc = "select line" } },
  { "x", "x", function()
      if fn.mode() == "V" then feed("j") else feed("<Esc>V") end
    end, { desc = "extend line selection" } },
  { nx, "X", "V", { desc = "select line bounds" } },
  { nx, "%", "ggVG", { desc = "select all" } },

  -- changes -----------------------------------------------------------------
  { "n", "d", "vd", { desc = "delete" } },
  { "n", "c", "vc", { desc = "change" } },
  { "n", "y", "vy", { desc = "yank" } },
  { "n", "<A-d>", [[v"_d]], { desc = "delete (no yank)" } },
  { "x", "<A-d>", [["_d]], { desc = "delete (no yank)" } },
  { "n", "<A-c>", [[v"_c]], { desc = "change (no yank)" } },
  { "x", "<A-c>", [["_c]], { desc = "change (no yank)" } },
  { "x", "i", insert_at("start"), { desc = "insert at selection start" } },
  { "x", "a", insert_at("end"), { desc = "append at selection end" } },
  { "x", "p", paste_at("end", "p"), { desc = "paste after" } },
  { "x", "P", paste_at("start", "P"), { desc = "paste before" } },
  { "n", "R", "vP", { desc = "replace with yanked" } },
  { "x", "R", "P", { desc = "replace with yanked" } },
  { "n", "U", "<C-r>", { desc = "redo" } },
  { "n", "`", "vu", { desc = "lowercase" } },
  { "x", "`", "u", { desc = "lowercase" } },
  { "n", "<A-`>", "vU", { desc = "uppercase" } },
  { "x", "<A-`>", "U", { desc = "uppercase" } },
  { "n", "~", "v~", { desc = "switch case" } },
  { "n", ">", ">>", { desc = "indent" } },
  { "n", "<", "<<", { desc = "unindent" } },
  { "x", ">", ">gv", { desc = "indent" } },
  { "x", "<", "<gv", { desc = "unindent" } },
  { "n", "<C-c>", "gcc", { desc = "toggle comment", remap = true } },
  { "x", "<C-c>", "gc", { desc = "toggle comment", remap = true } },
  { "x", "s", [[:s/\%V]], { desc = "regex within selection" } },

  -- search ------------------------------------------------------------------
  { nx, "n", select_match(false), { desc = "select next match" } },
  { nx, "N", select_match(true), { desc = "select prev match" } },
  { nx, "*", search_selection, { desc = "selection as search" } },

  -- macros ------------------------------------------------------------------
  { "n", "Q", function() return fn.reg_recording() ~= "" and "q" or "qq" end, { desc = "record macro", expr = true } },
  { "n", "q", "@q", { desc = "replay macro" } },

  -- match mode --------------------------------------------------------------
  { nx, "mm", "%", { desc = "matching bracket", remap = false } },
  { nx, "mi", textobject("i"), { desc = "select inside object" } },
  { nx, "ma", textobject("a"), { desc = "select around object" } },
  { nx, "ms", surround_add, { desc = "surround add" } },
  { nx, "md", surround_delete, { desc = "surround delete" } },
  { nx, "mr", surround_replace, { desc = "surround replace" } },

  -- space mode --------------------------------------------------------------
  { nx, "<Space>f", pick("find_files", "Explore"), { desc = "file picker" } },
  { nx, "<Space>b", pick("buffers", "buffers"), { desc = "buffer picker" } },
  { nx, "<Space>/", pick("live_grep", "vimgrep"), { desc = "global search" } },
  { nx, "<Space>?", pick("commands", "history :"), { desc = "command palette" } },
  { nx, "<Space>s", function() vim.lsp.buf.document_symbol() end, { desc = "symbols" } },
  { nx, "<Space>S", function() vim.lsp.buf.workspace_symbol() end, { desc = "workspace symbols" } },
  { nx, "<Space>d", function() vim.diagnostic.setloclist() end, { desc = "diagnostics" } },
  { nx, "<Space>D", function() vim.diagnostic.setqflist() end, { desc = "workspace diagnostics" } },
  { nx, "<Space>k", function() vim.lsp.buf.hover() end, { desc = "hover" } },
  { nx, "<Space>r", function() vim.lsp.buf.rename() end, { desc = "rename" } },
  { nx, "<Space>a", function() vim.lsp.buf.code_action() end, { desc = "code action" } },
  { nx, "<Space>w", "<C-w>", { desc = "window mode" } },
  { nx, "<Space>y", [["+y]], { desc = "yank to clipboard" } },
  { nx, "<Space>p", [["+p]], { desc = "paste clipboard after" } },
  { nx, "<Space>P", [["+P]], { desc = "paste clipboard before" } },
  { "x", "<Space>R", [["+P]], { desc = "replace with clipboard" } },

  -- unimpaired-style ----------------------------------------------------------
  { nx, "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "next diagnostic" } },
  { nx, "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "prev diagnostic" } },
  { nx, "]g", "]c", { desc = "next change", remap = false } },
  { nx, "[g", "[c", { desc = "prev change", remap = false } },
}

M.keymaps = keymaps

---------------------------------------------------------------------------
-- setup / teardown
---------------------------------------------------------------------------

local applied = {}
local augroup

function M.enable()
  if M.enabled then return end
  M.enabled = true
  for _, key in ipairs(M.keymaps) do
    local opts = vim.tbl_extend("force", { noremap = true, silent = true }, key[4] or {})
    if opts.remap then opts.noremap = nil end
    opts.desc = "<helix> " .. (opts.desc or key[2])
    vim.keymap.set(key[1], key[2], key[3], opts)
    local modes = type(key[1]) == "table" and key[1] or { key[1] }
    for _, m in ipairs(modes) do applied[#applied + 1] = { m, key[2] } end
  end

  augroup = api.nvim_create_augroup("HelixEmulation", { clear = true })
  api.nvim_create_autocmd("ModeChanged", {
    group = augroup,
    pattern = "*:*",
    callback = function()
      -- select mode ends as soon as we leave Visual mode
      if not vim.v.event.new_mode:match("^[vV\22sS\19]") then M.extend = false end
    end,
  })
end

function M.disable()
  if not M.enabled then return end
  M.enabled = false
  M.extend = false
  for _, k in ipairs(applied) do pcall(vim.keymap.del, k[1], k[2]) end
  applied = {}
  if augroup then api.nvim_del_augroup_by_id(augroup) end
end

function M.toggle()
  if M.enabled then M.disable() else M.enable() end
end

function M.setup(opts)
  opts = opts or {}
  if opts.keymaps then
    for _, k in ipairs(opts.keymaps) do table.insert(M.keymaps, k) end
  end
  M.enable()
  api.nvim_create_user_command("HelixToggle", M.toggle, {})
end

return M
