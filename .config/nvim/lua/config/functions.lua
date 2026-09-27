---Check whether Neovim is running on Windows.
---@return boolean
function Fish.is_windows()
  return vim.fn.has("win32") == 1
end

local fish_group = vim.api.nvim_create_augroup("Fish.config", {})

---comment
---@param event string|table
---@param callback? function
---@param pattern? string|table
---@param group? any
---@param desc? string
function _G.autocmd(event, callback, pattern, group, desc)
  vim.api.nvim_create_autocmd(event, {
    group = group or fish_group,
    desc = desc or nil,
    pattern = pattern or nil,
    callback = callback or nil,
  })
end

---Set Neovim options in bulk.
---Scalar values (boolean/number/string) are applied via `vim.o`.
---Table values (lists/maps, e.g. `listchars`, `shortmess`) are applied via `vim.opt`,
---which performs the correct comma-list/flag/map conversion.
---@param opts table<string, boolean|number|string|table> Map of option name -> value
---@usage
--- set {
---   number = true,
---   relativenumber = true,
---   wrap = false,
---   listchars = { tab = "» ", trail = "·" }, -- routed to vim.opt
--- }
function _G.set(opts)
  for name, value in pairs(opts) do
    if type(value) == "table" then
      vim.opt[name] = value
    else
      vim.o[name] = value
    end
  end
end

---@class KeymapSpec
---@field [1] string|string[]|nil mode or lhs (see mode-detection rules)
---@field [2] string|function lhs or rhs
---@field [3]? string|function|nil rhs or nil
---@field mode? string|string[]
---@field buf? integer buffer number, or 0 for current buffer
---@field noremap? boolean
---@field remap? boolean inverse of noremap; ignored if `noremap` is set explicitly
---@field silent? boolean
---@field opts? table extra vim.keymap.set opts (desc, expr, nowait, etc.)
---@field load? string name of a plugin to `:packadd` (once) before running rhs

local VALID_MODES = {
  n = true,
  v = true,
  x = true,
  s = true,
  o = true,
  i = true,
  l = true,
  c = true,
  t = true,
  [""] = true,
}

---@param v any
---@return boolean
local function is_mode(v)
  if type(v) == "table" then
    for _, mm in ipairs(v) do
      if not VALID_MODES[mm] then
        return false
      end
    end
    return true
  elseif type(v) == "string" then
    return VALID_MODES[v] == true
  end
  return false
end

--- Evaluate `+ - * /` with parentheses and unary minus, where `i` is the range value.
--- Returns nil if `expr` isn't valid or doesn't reference `i`.
---@param expr string
---@param i integer
---@return string|nil
local function eval_expr(expr, i)
  if not expr:find("i", 1, true) then
    return nil
  end

  local pos = 1

  -- skip whitespace, return the next char ("" at end of input)
  local function peek()
    pos = expr:find("%S", pos) or (#expr + 1)
    return expr:sub(pos, pos)
  end

  local parse_expr

  local function parse_atom()
    local c = peek()
    if c == "(" then
      pos = pos + 1
      local v = parse_expr()
      if v == nil or peek() ~= ")" then
        return nil
      end
      pos = pos + 1
      return v
    elseif c == "-" then -- unary minus
      pos = pos + 1
      local v = parse_atom()
      return v and -v
    elseif c == "i" then
      pos = pos + 1
      return i
    end
    local num = expr:match("^%d+%.?%d*", pos)
    if not num then
      return nil
    end
    pos = pos + #num
    return tonumber(num)
  end

  -- * and / bind tighter than + and -
  local function parse_term()
    local v = parse_atom()
    while v ~= nil do
      local op = peek()
      if op ~= "*" and op ~= "/" then
        break
      end
      pos = pos + 1
      local rhs = parse_atom()
      if rhs == nil or (op == "/" and rhs == 0) then
        return nil
      end
      if op == "*" then
        v = v * rhs
      else
        v = v / rhs
      end
    end
    return v
  end

  parse_expr = function()
    local v = parse_term()
    while v ~= nil do
      local op = peek()
      if op ~= "+" and op ~= "-" then
        break
      end
      pos = pos + 1
      local rhs = parse_term()
      if rhs == nil then
        return nil
      end
      if op == "+" then
        v = v + rhs
      else
        v = v - rhs
      end
    end
    return v
  end

  local result = parse_expr()
  if result == nil or peek() ~= "" then -- parse failed or trailing junk
    return nil
  end

  if result == math.floor(result) then
    return string.format("%d", result)
  end
  return tostring(result)
end

---Replace `{expr}` placeholders (e.g. `{i}`, `{i-1}`, `{i*2}`) in strings,
---recursing into lhs lists. No-op when i is nil.
local function expand(v, i)
  if i == nil then
    return v
  end
  if type(v) == "string" then
    return (
      v:gsub("{([^{}]+)}", function(expr)
        return eval_expr(expr, i) -- nil keeps the original text untouched
      end)
    )
  elseif type(v) == "table" then
    return vim.tbl_map(function(x)
      return expand(x, i)
    end, v)
  end
  return v
end

-- Nomes de plugins já carregados via :packadd (cache global do módulo,
-- compartilhado entre todos os mapeamentos que apontam pro mesmo `load`)
local loaded = {}

---@param name string
local function packadd_once(name)
  if loaded[name] then
    return
  end
  loaded[name] = true
  vim.cmd.packadd(name)
end

---Embrulha o rhs original numa função que primeiro garante o `:packadd`
---do plugin e só então executa o rhs, exatamente como ele seria executado
---se não houvesse lazy-loading nenhum.
---@param name string plugin to packadd
---@param rhs string|function original rhs
---@return function
local function wrap_load(name, rhs)
  return function(...)
    packadd_once(name)

    if type(rhs) == "function" then
      return rhs(...)
    end

    -- rhs é string: mesmo comportamento que vim.keymap.set daria a ela,
    -- ou seja, refeed das teclas/comando originais
    local keys = vim.api.nvim_replace_termcodes(rhs, true, true, true)
    vim.api.nvim_feedkeys(keys, "m", false)
  end
end

-- ---------------------------------------------------------------------------
-- Error reporting helpers
--
-- vim.keymap.set validates its arguments deep inside itself, so a mistake in
-- one of the many `map { ... }` entries only shows up as e.g.
--   "rhs: expected string|function, got boolean"
-- with a traceback that points at set_one/vim.keymap.set, never at *which*
-- spec in *which* map() call caused it. The helpers below catch bad
-- mode/lhs/rhs values before they reach vim.keymap.set and raise an error
-- that names the offending field, its actual value, its index in the map()
-- call, and a printed copy of the whole spec so it can be found in the file.
-- ---------------------------------------------------------------------------

---@param m KeymapSpec
---@param idx integer|nil index of this spec inside its map() call
---@param i integer|nil range value, if this spec came from a `range`
---@return string
local function describe_spec(m, idx, i)
  local ok, dump = pcall(vim.inspect, m)
  if not ok then
    dump = "<spec could not be printed>"
  end
  local where = string.format("map spec #%s", idx and tostring(idx) or "?")
  if i ~= nil then
    where = where .. string.format(" (range i=%d)", i)
  end
  return string.format("%s:\n%s", where, dump)
end

---Raise a descriptive error for a bad field on a keymap spec.
---@param field string field name, e.g. "rhs"
---@param value any the actual (invalid) value
---@param expected string human-readable expected type(s), e.g. "string|function"
---@param m KeymapSpec
---@param idx integer|nil
---@param i integer|nil
local function fail(field, value, expected, m, idx, i)
  error(
    string.format(
      "set_keymap: invalid `%s` (expected %s, got %s: %s) in %s",
      field,
      expected,
      type(value),
      vim.inspect(value),
      describe_spec(m, idx, i)
    ),
    0
  )
end

---@param value any
---@param expected string[] list of acceptable `type(value)` results
---@return boolean
local function has_type(value, expected)
  for _, t in ipairs(expected) do
    if type(value) == t then
      return true
    end
  end
  return false
end

---Validate mode/lhs/rhs right before handing them to vim.keymap.set, so
---failures are attributed to the actual spec instead of surfacing from
---inside vim.keymap.set's own vim.validate call.
---@param mode any
---@param lhs any
---@param rhs any
---@param m KeymapSpec
---@param idx integer|nil
---@param i integer|nil
local function validate_keymap(mode, lhs, rhs, m, idx, i)
  if not has_type(mode, { "string", "table" }) then
    fail("mode", mode, "string|string[]", m, idx, i)
  end

  if type(lhs) == "table" then
    for n, l in ipairs(lhs) do
      if type(l) ~= "string" then
        fail(string.format("lhs[%d]", n), l, "string", m, idx, i)
      end
    end
  elseif type(lhs) ~= "string" then
    fail("lhs", lhs, "string|string[]", m, idx, i)
  end

  if not has_type(rhs, { "string", "function" }) then
    fail("rhs", rhs, "string|function", m, idx, i)
  end
end

---@param m KeymapSpec
---@param i integer|nil current range value
---@param idx integer|nil index of this spec inside its map() call
local function set_one(m, i, idx)
  local mode, lhs, rhs

  if m.mode ~= nil then
    mode = m.mode
    lhs, rhs = m[1], m[2]
  elseif is_mode(m[1]) then
    mode = m[1]
    lhs, rhs = m[2], m[3]
  else
    mode = "n"
    lhs, rhs = m[1], m[2]
  end

  local opts = vim.tbl_extend("force", {}, m.opts or {})

  -- NOTE: use remap or noremap
  if m.noremap ~= nil then
    opts.noremap = m.noremap
  end

  if m.remap ~= nil then
    opts.noremap = not m.remap
  end

  if m.silent ~= nil then
    opts.silent = m.silent
  end

  if m.buf ~= nil then
    opts.buffer = m.buf
  end

  if m.desc ~= nil then
    opts.desc = m.desc
  end

  -- lazy-load: embrulha o rhs original ANTES da expansão de range, pra que
  -- a expansão de `{i}` (quando houver) continue funcionando sobre a ação real
  if m.load then
    if not has_type(rhs, { "string", "function" }) then
      fail("rhs (before load-wrap)", rhs, "string|function", m, idx, i)
    end
    rhs = wrap_load(m.load, rhs)
  end

  -- range expansion
  lhs = expand(lhs, i)
  opts.desc = expand(opts.desc, i)
  if i ~= nil then
    if type(rhs) == "function" then
      local fn = rhs
      rhs = function(...)
        return fn(i, ...) -- return keeps `expr = true` maps working
      end
    else
      rhs = expand(rhs, i)
    end
  end

  -- Catch bad mode/lhs/rhs here, with full context, instead of letting
  -- vim.keymap.set's own validation raise an unattributed error.
  validate_keymap(mode, lhs, rhs, m, idx, i)

  local function do_set(l)
    local ok, err = pcall(vim.keymap.set, mode, l, rhs, opts)
    if not ok then
      error(
        string.format(
          "set_keymap: vim.keymap.set failed (%s) in %s",
          tostring(err),
          describe_spec(m, idx, i)
        ),
        0
      )
    end
  end

  if type(lhs) == "table" then
    for _, l in ipairs(lhs) do
      do_set(l)
    end
  else
    do_set(lhs)
  end
end

function _G.map(maps)
  for idx, m in ipairs(maps) do
    if m.range then
      local first, last, step = m.range[1], m.range[2], m.range[3] or 1
      for i = first, last, step do
        set_one(m, i, idx)
      end
    else
      set_one(m, nil, idx)
    end
  end
end

function _G.later(fn)
  -- TODO: i should use async here?
  -- vim.async.run(fn)
  vim.schedule(fn)
end

-- ---@param package string|table
-- function _G.packadd(package)
--   if type(package) == "table" then
--     for _, v in pairs(package) do
--       vim.cmd.packadd(v)
--     end
--     return
--   end
--   vim.cmd.packadd(package)
-- end

---@param package string
function _G.packadd(package)
  vim.cmd.packadd(package)
end
