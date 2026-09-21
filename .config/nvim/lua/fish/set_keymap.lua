local M = {}

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
---@param m KeymapSpec
---@param i integer|nil current range value
local function set_one(m, i)
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

  local opts = vim.tbl_extend("force", { noremap = true, silent = true }, m.opts or {})

  if m.noremap ~= nil then
    opts.noremap = m.noremap
  elseif m.remap ~= nil then
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

  if type(lhs) == "table" then
    for _, l in ipairs(lhs) do
      vim.keymap.set(mode, l, rhs, opts)
    end
  else
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

function M.set(maps)
  for _, m in ipairs(maps) do
    if m.range then
      local first, last, step = m.range[1], m.range[2], m.range[3] or 1
      for i = first, last, step do
        set_one(m, i)
      end
    else
      set_one(m)
    end
  end
end

return M
