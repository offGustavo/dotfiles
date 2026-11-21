---@brief Emacs Dired (with wdired) for Neovim — pure Lua, zero dependencies.
---
--- Install: put this file at  ~/.config/nvim/lua/dired.lua  (needs Neovim >= 0.10)
---
---   require("dired").setup()                      -- defaults
---   vim.keymap.set("n", "-", "<cmd>DiredJump<cr>") -- like dired-jump (C-x C-j)
---
--- Commands:  :Dired [dir]   :DiredJump
---
--- TASK(20261116-220017): Make this be autogen and updated with the current keybinds
--- Default keys inside a Dired buffer (evil-collection flavoured, all remappable):
---   <CR> f  visit file / enter dir      o   visit in other window
---   ^ -     parent directory            gr  revert (refresh)
---   s       toggle sort name <-> mtime  gh  toggle dotfiles
---   m u     mark / unmark (+ move down) U   unmark all        t  toggle marks
---   d x     flag for deletion / execute %m  mark by regex     %d flag by regex
---   D       delete (marked or current)  R   rename/move       C  copy
---   +       make directory              N   new empty file
---   M       chmod (octal)               !   shell command ({} = files, else appended)
---   X       open with system app        yy  yank name         Y  yank full path
---   <C-x><C-q> / gW   wdired: edit names like text, :w or <C-c><C-c> applies,
---                     <C-c><C-k> aborts. Names may contain "/" to move files.
---   q       quit
--- Marks/flags apply to the visual selection too. R/C/D act on '*' marks if any,
--- otherwise on the file under the cursor (or the visual range).

local api, fn, fs = vim.api, vim.fn, vim.fs
local uv = vim.uv or vim.loop
local bit = require("bit")
local band, bor, bnot = bit.band, bit.bor, bit.bnot

local M = {}

M.config = {
	show_hidden = true,
	group_dirs = true,
	sort = "name", -- "name" | "time"
	hijack_netrw = true, -- `nvim some/dir` and `:e some/dir` open Dired
	keys = {
		["<CR>"] = "visit",
		f = "visit",
		o = "visit_other",
		["^"] = "up",
		["-"] = "up",
		gr = "revert",
		s = "sort",
		gh = "hidden",
		m = "mark",
		u = "unmark",
		U = "unmark_all",
		t = "toggle_marks",
		d = "flag",
		x = "execute",
		["%m"] = "mark_regex",
		["%d"] = "flag_regex",
		D = "delete",
		R = "move",
		C = "copy",
		["+"] = "mkdir",
		N = "touch",
		['='] = "chmod",
		-- M = "chmod",
		["!"] = "shell",
		X = "open_external",
		yy = "yank_name",
		Y = "yank_path",
		q = "quit",
		["<C-x><C-q>"] = "wdired",
		gW = "wdired",
		i = "wdired",
	},
}

-- Actions that also work on a visual selection.
local RANGE = { mark = 1, unmark = 1, flag = 1, delete = 1, move = 1, copy = 1, shell = 1, chmod = 1 }

local ns = api.nvim_create_namespace("dired")
local states = {} -- [bufnr] = { dir, entries, marks, sort, hidden, wdired, mapped }
local is_win = fn.has("win32") == 1
local case_insensitive = is_win or fn.has("mac") == 1
local ERROR = vim.log.levels.ERROR

-- Fixed-width column block in front of every name: "m perms      size date  "
-- This is what makes wdired trivial: the name always starts at byte PREFIX.
local FMT = "%s %s %8s %s "
local PREFIX = 1 + 1 + 10 + 1 + 8 + 1 + 16 + 1

---------------------------------------------------------------------------
-- helpers
---------------------------------------------------------------------------

local function notify(msg, level)
	-- TASK(20261116-220104): change this to [INFO] Dired: <msg>
	-- vim.notify("dired: " .. msg, level or vim.log.levels.INFO)
	return
end

local function join(a, b)
	return fs.normalize(fs.joinpath(a, b))
end

local function is_abs(p)
	return p:match("^/") ~= nil or p:match("^%a:[/\\]") ~= nil
end

local function human(n)
	if n < 1024 then
		return tostring(n)
	end
	local units, i, v = { "K", "M", "G", "T" }, 0, n
	while v >= 1024 and i < #units do
		v, i = v / 1024, i + 1
	end
	return string.format(v < 10 and "%.1f%s" or "%.0f%s", v, units[i])
end

local function modestr(e)
	local t = e.type == "directory" and "d" or e.type == "link" and "l" or "-"
	local rwx, out = "rwxrwxrwx", { t }
	for i = 1, 9 do
		out[#out + 1] = bit.band(e.mode, bit.lshift(1, 9 - i)) ~= 0 and rwx:sub(i, i) or "-"
	end
	return table.concat(out)
end

local function read_dir(st)
	local h, err = uv.fs_scandir(st.dir)
	if not h then
		return nil, err
	end
	local out = {}
	while true do
		local name = uv.fs_scandir_next(h)
		if not name then
			break
		end
		if st.hidden or name:sub(1, 1) ~= "." then
			local path = join(st.dir, name)
			local l = uv.fs_lstat(path) or {}
			local s = (l.type == "link") and uv.fs_stat(path) or l
			out[#out + 1] = {
				name = name,
				type = l.type or "file",
				is_dir = s.type == "directory",
				size = l.size or 0,
				mtime = l.mtime and l.mtime.sec or 0,
				mode = l.mode or 0,
			}
		end
	end
	table.sort(out, function(a, b)
		if M.config.group_dirs and a.is_dir ~= b.is_dir then
			return a.is_dir
		end
		if st.sort == "time" and a.mtime ~= b.mtime then
			return a.mtime > b.mtime
		end
		local an, bn = a.name:lower(), b.name:lower()
		if an ~= bn then
			return an < bn
		end
		return a.name < b.name
	end)
	return out
end

--- Recursive copy (files, dirs, symlinks).
-- @return ok todo, err todo
local function copy_rec(src, dst)
	local s = uv.fs_lstat(src)
	if not s then
		return false, "missing: " .. src
	end
	if s.type == "directory" then
		fn.mkdir(dst, "p")
		local h = uv.fs_scandir(src)
		while h do
			local n = uv.fs_scandir_next(h)
			if not n then
				break
			end
			local ok, err = copy_rec(join(src, n), join(dst, n))
			if not ok then
				return false, err
			end
		end
		return true
	elseif s.type == "link" then
		local ok, err = uv.fs_symlink(uv.fs_readlink(src), dst)
		return ok and true or false, err
	end
	local ok, err = uv.fs_copyfile(src, dst)
	return ok and true or false, err
end

-- Keep open buffers pointing at renamed files (best effort).
local function retarget(old, new)
	for _, b in ipairs(api.nvim_list_bufs()) do
		if api.nvim_buf_is_loaded(b) and vim.bo[b].buftype == "" then
			local name = fs.normalize(api.nvim_buf_get_name(b))
			if name == old or vim.startswith(name, old .. "/") then
				pcall(api.nvim_buf_set_name, b, new .. name:sub(#old + 1))
			end
		end
	end
end

local function move(src, dst)
	fn.mkdir(fs.dirname(dst), "p")
	local ok, err = uv.fs_rename(src, dst)
	if ok then
		return true
	end
	if err and err:find("EXDEV") then -- across filesystems: copy + delete
		local cok, cerr = copy_rec(src, dst)
		if not cok then
			return false, cerr
		end
		if fn.delete(src, "rf") ~= 0 then
			return false, "copied, but could not remove " .. src
		end
		return true
	end
	return false, err
end

---------------------------------------------------------------------------
-- rendering
---------------------------------------------------------------------------

local function define_hl()
	local links = {
		DiredHeader = "Title",
		DiredDir = "Directory",
		DiredSymlink = "Keyword",
		DiredMeta = "Comment",
		DiredMark = "WarningMsg",
		DiredFlagged = "ErrorMsg",
	}
	for name, target in pairs(links) do
		api.nvim_set_hl(0, name, { link = target, default = true })
	end
end

local function draw(buf)
	local st = states[buf]
	local lines = { "  " .. st.dir .. ":" }
	for _, e in ipairs(st.entries) do
		local date = os.date("%Y-%m-%d %H:%M", e.mtime) or string.rep(" ", 16)
		local size = e.is_dir and "-" or human(e.size)
		lines[#lines + 1] = FMT:format(st.marks[e.name] or " ", modestr(e), size, date) .. e.name
	end

	local win = fn.bufwinid(buf)
	local cur = win ~= -1 and api.nvim_win_get_cursor(win) or nil
	vim.bo[buf].modifiable = true
	api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].modified = false
	if cur then
		pcall(api.nvim_win_set_cursor, win, { math.min(cur[1], #lines), cur[2] })
	end

	api.nvim_buf_clear_namespace(buf, ns, 0, -1)
	api.nvim_buf_set_extmark(buf, ns, 0, 0, { end_col = #lines[1], hl_group = "DiredHeader" })
	for i, e in ipairs(st.entries) do
		local m, line = st.marks[e.name], lines[i + 1]
		api.nvim_buf_set_extmark(buf, ns, i, 2, { end_col = PREFIX, hl_group = "DiredMeta" })
		if m then
			api.nvim_buf_set_extmark(buf, ns, i, 0, {
				end_col = 1,
				hl_group = m == "D" and "DiredFlagged" or "DiredMark",
			})
		end
		local hl = (m == "D" and "DiredFlagged")
			or (e.type == "link" and "DiredSymlink")
			or (e.is_dir and "DiredDir")
			or nil
		if hl then
			api.nvim_buf_set_extmark(buf, ns, i, PREFIX, { end_col = #line, hl_group = hl })
		end
	end
end

local function render(buf)
	local st = states[buf]
	if not st then
		return
	end
	local entries, err = read_dir(st)
	if not entries then
		notify("cannot read " .. st.dir .. ": " .. tostring(err), ERROR)
		entries = {}
	end

	local win, keep = fn.bufwinid(buf), nil
	if win ~= -1 then
		local e = st.entries[api.nvim_win_get_cursor(win)[1] - 1]
		keep = e and e.name
	end

	st.entries = entries
	local present = {}
	for _, e in ipairs(entries) do
		present[e.name] = true
	end
	for n in pairs(st.marks) do
		if not present[n] then
			st.marks[n] = nil
		end
	end

	draw(buf)

	if keep and win ~= -1 then -- follow the file we were on if it moved
		for i, e in ipairs(entries) do
			if e.name == keep then
				pcall(api.nvim_win_set_cursor, win, { i + 1, api.nvim_win_get_cursor(win)[2] })
				break
			end
		end
	end
end

local function refresh_all()
	for b in pairs(states) do
		if api.nvim_buf_is_valid(b) then
			render(b)
		end
	end
end

local function goto_name(buf, name)
	local win = fn.bufwinid(buf)
	if win == -1 then
		return
	end
	for i, e in ipairs(states[buf].entries) do
		if e.name == name then
			api.nvim_win_set_cursor(win, { i + 1, PREFIX })
			return
		end
	end
end

---------------------------------------------------------------------------
-- selection helpers
---------------------------------------------------------------------------

--- Line range of the current command: the visual selection, or the cursor line.
local function range()
	local mode = fn.mode()
	if mode == "v" or mode == "V" or mode == "\22" then
		local a, b = fn.line("v"), fn.line(".")
		if a > b then
			a, b = b, a
		end
		vim.cmd("normal! \27")
		return a, b, true
	end
	local l = fn.line(".")
	return l, l, false
end

--- '*'-marked entries if any, otherwise entries in range().
local function targets(buf)
	local st, list = states[buf], {}
	for _, e in ipairs(st.entries) do
		if st.marks[e.name] == "*" then
			list[#list + 1] = e
		end
	end
	if #list > 0 then
		return list
	end
	local a, b = range()
	for l = a, b do
		local e = st.entries[l - 1]
		if e then
			list[#list + 1] = e
		end
	end
	return list
end

local function default_dest(buf)
	for _, w in ipairs(api.nvim_tabpage_list_wins(0)) do -- like dired-dwim-target
		local b = api.nvim_win_get_buf(w)
		if b ~= buf and states[b] then
			return states[b].dir .. "/"
		end
	end
	return states[buf].dir .. "/"
end

---------------------------------------------------------------------------
-- actions
---------------------------------------------------------------------------

local A = {}

local function visit(buf, how)
	local st = states[buf]
	local e = st.entries[fn.line(".") - 1]
	if not e then
		return
	end
	local path = join(st.dir, e.name)
	if how == "other" then
		if #api.nvim_tabpage_list_wins(0) == 1 then
			vim.cmd("vsplit")
		else
			vim.cmd("wincmd w")
		end
	end
	if e.is_dir then
		M.open(path)
	else
		vim.cmd("edit " .. fn.fnameescape(path))
	end
end

A.visit = function(buf)
	visit(buf)
end
A.visit_other = function(buf)
	visit(buf, "other")
end
A.up = function(buf)
	local dir = states[buf].dir
	M.open(fs.dirname(dir), fs.basename(dir))
end
A.revert = function(buf)
	render(buf)
end
A.sort = function(buf)
	local st = states[buf]
	st.sort = st.sort == "name" and "time" or "name"
	notify("sorted by " .. st.sort)
	render(buf)
end
A.hidden = function(buf)
	local st = states[buf]
	st.hidden = not st.hidden
	render(buf)
end

local function set_mark(buf, ch)
	local st = states[buf]
	local a, b, visual = range()
	for l = a, b do
		local e = st.entries[l - 1]
		if e then
			st.marks[e.name] = ch
		end
	end
	draw(buf)
	if not visual then
		api.nvim_win_set_cursor(0, { math.min(b + 1, #st.entries + 1), api.nvim_win_get_cursor(0)[2] })
	end
end

A.mark = function(buf)
	set_mark(buf, "*")
end
A.unmark = function(buf)
	set_mark(buf, nil)
end
A.flag = function(buf)
	set_mark(buf, "D")
end
A.unmark_all = function(buf)
	states[buf].marks = {}
	draw(buf)
end
A.toggle_marks = function(buf)
	local st = states[buf]
	for _, e in ipairs(st.entries) do
		if st.marks[e.name] == "*" then
			st.marks[e.name] = nil
		elseif not st.marks[e.name] then
			st.marks[e.name] = "*"
		end
	end
	draw(buf)
end

local function mark_by_regex(buf, ch)
	vim.ui.input({ prompt = (ch == "D" and "Flag" or "Mark") .. " files matching (regex): " }, function(re)
		if not re or re == "" then
			return
		end
		local ok, rx = pcall(vim.regex, re)
		if not ok then
			return notify("bad regex: " .. re, ERROR)
		end
		local st, n = states[buf], 0
		for _, e in ipairs(st.entries) do
			if rx:match_str(e.name) then
				st.marks[e.name] = ch
				n = n + 1
			end
		end
		draw(buf)
		notify(n .. " file(s) matched")
	end)
end
A.mark_regex = function(buf)
	mark_by_regex(buf, "*")
end
A.flag_regex = function(buf)
	mark_by_regex(buf, "D")
end

local function delete_entries(buf, list)
	if #list == 0 then
		return
	end
	local st, names = states[buf], {}
	for i = 1, math.min(#list, 8) do
		names[i] = list[i].name
	end
	local more = #list > 8 and ("\n… and %d more"):format(#list - 8) or ""
	local msg = ("Delete %d item(s)?\n%s%s"):format(#list, table.concat(names, "\n"), more)
	if fn.confirm(msg, "&Yes\n&No", 2) ~= 1 then
		return
	end
	local failed = 0
	for _, e in ipairs(list) do
		if fn.delete(join(st.dir, e.name), "rf") ~= 0 then
			failed = failed + 1
		end
	end
	if failed > 0 then
		notify(failed .. " item(s) could not be deleted", ERROR)
	end
	st.marks = {}
	refresh_all()
end
A.delete = function(buf)
	delete_entries(buf, targets(buf))
end
A.execute = function(buf)
	local st, list = states[buf], {}
	for _, e in ipairs(st.entries) do
		if st.marks[e.name] == "D" then
			list[#list + 1] = e
		end
	end
	if #list == 0 then
		return notify("no files flagged for deletion")
	end
	delete_entries(buf, list)
end

local function transfer(buf, list, verb, op, is_move)
	if #list == 0 then
		return
	end
	local st = states[buf]
	vim.ui.input({
		prompt = ("%s %d item(s) to: "):format(verb, #list),
		default = default_dest(buf),
		completion = "file",
	}, function(dest)
		if not dest or dest == "" then
			return
		end
		dest = fs.normalize(dest)
		if not is_abs(dest) then
			dest = join(st.dir, dest)
		end
		local into_dir = fn.isdirectory(dest) == 1
		if #list > 1 and not into_dir then
			fn.mkdir(dest, "p")
			into_dir = true
		end

		local errs = {}
		for _, e in ipairs(list) do
			local src = join(st.dir, e.name)
			local dst = into_dir and join(dest, e.name) or dest
			if uv.fs_lstat(dst) and dst ~= src then
				errs[#errs + 1] = e.name .. ": target exists, skipped"
			elseif dst == src or vim.startswith(dst, src .. "/") then
				errs[#errs + 1] = e.name .. ": cannot " .. verb:lower() .. " onto/into itself"
			else
				local ok, err = op(src, dst)
				if ok then
					if is_move then
						retarget(src, dst)
					end
				else
					errs[#errs + 1] = e.name .. ": " .. tostring(err)
				end
			end
		end
		st.marks = {}
		refresh_all()
		if #errs > 0 then
			notify(table.concat(errs, "\n"), ERROR)
		end
	end)
end
A.move = function(buf)
	transfer(buf, targets(buf), "Move", move, true)
end
A.copy = function(buf)
	transfer(buf, targets(buf), "Copy", copy_rec, false)
end

A.mkdir = function(buf)
	local st = states[buf]
	vim.ui.input({ prompt = "Create directory: " }, function(name)
		if not name or name == "" then
			return
		end
		fn.mkdir(join(st.dir, name), "p")
		refresh_all()
		goto_name(buf, name:match("^[^/\\]+"))
	end)
end

A.touch = function(buf)
	local st = states[buf]
	vim.ui.input({ prompt = "Create file: " }, function(name)
		if not name or name == "" then
			return
		end
		local path = join(st.dir, name)
		fn.mkdir(fs.dirname(path), "p")
		local fd, err = uv.fs_open(path, "wx", 420) -- 0644, fail if it exists
		if not fd then
			return notify(tostring(err), ERROR)
		end
		uv.fs_close(fd)
		refresh_all()
		goto_name(buf, name:match("^[^/\\]+"))
	end)
end


-- permission bits per class
local CLASS = {
  u = { r = 256, w = 128, x = 64, special = 2048, all = 448 }, -- setuid
  g = { r = 32,  w = 16,  x = 8,  special = 1024, all = 56  }, -- setgid
  o = { r = 4,   w = 2,   x = 1,  special = 512,  all = 7   }, -- sticky
}

-- Parse an octal ("755") or symbolic ("+x", "u+x,g-w", "a=rx") mode.
-- `cur` is the current permission bits, `is_dir` is used for the "X" flag.
local function parse_mode(s, cur, is_dir)
  s = vim.trim(s or "")
  if s == "" then return nil end
  if s:match("^[0-7]+$") then return tonumber(s, 8) end

  local mode = cur
  for clause in s:gmatch("[^,]+") do
    local who, op, perms = clause:match("^([ugoa]*)([-+=])([rwxXst]*)$")
    if not op then return nil end
    if who == "" or who:find("a") then who = "ugo" end

    local had_exec = band(cur, 73) ~= 0 -- any x bit set (64+8+1)
    local bits, clear = 0, 0
    for c in who:gmatch(".") do
      local cl = CLASS[c]
      clear = bor(clear, cl.all, cl.special)
      for p in perms:gmatch(".") do
        if p == "r" or p == "w" then
          bits = bor(bits, cl[p])
        elseif p == "x" then
          bits = bor(bits, cl.x)
        elseif p == "X" and (is_dir or had_exec) then
          bits = bor(bits, cl.x)
        elseif p == "s" and c ~= "o" then
          bits = bor(bits, cl.special)
        elseif p == "t" and c == "o" then
          bits = bor(bits, cl.special)
        end
      end
    end

    if op == "+" then
      mode = bor(mode, bits)
    elseif op == "-" then
      mode = band(mode, bnot(bits))
    else -- "="
      mode = bor(band(mode, bnot(clear)), bits)
    end
  end
  return mode
end

A.chmod = function(buf)
  local st, list = states[buf], targets(buf)
  if #list == 0 then return end
  if #list > 1 then
    notify("chmod: select a single file", vim.log.levels.WARN)
    return
  end

  local entry = list[1]
  local path = join(st.dir, entry.name)
  local stat = uv.fs_stat(path)
  if not stat then
    notify(entry.name .. ": cannot stat", ERROR)
    return
  end
  local cur = band(stat.mode, 4095) -- 0o7777

  vim.ui.input({
    prompt = string.format("Change mode of %s (%o) to: ", entry.name, cur),
  }, function(s)
    if not s then return end
    local mode = parse_mode(s, cur, stat.type == "directory")
    if not mode then
      notify("chmod: invalid mode '" .. s .. "'", ERROR)
      return
    end
    local ok, err = uv.fs_chmod(path, mode)
    if not ok then notify(entry.name .. ": " .. tostring(err), ERROR) end
    render(buf)
  end)
end

A.shell = function(buf)
	local st, list = states[buf], targets(buf)
	if #list == 0 then
		return
	end
	local files = {}
	for _, e in ipairs(list) do
		files[#files + 1] = fn.shellescape(e.name)
	end
	local joined = table.concat(files, " ")
	vim.ui.input({ prompt = "! (" .. #list .. " file(s), {} = files): " }, function(cmd)
		if not cmd or cmd == "" then
			return
		end
		local line = cmd:find("{}", 1, true) and (cmd:gsub("{}", function()
			return joined
		end)) or (cmd .. " " .. joined)
		local argv = { vim.o.shell }
		vim.list_extend(argv, vim.split(vim.o.shellcmdflag, "%s+", { trimempty = true }))
		argv[#argv + 1] = line
		local res = vim.system(argv, { cwd = st.dir, text = true }):wait(30000)
		local out = vim.trim((res.stdout or "") .. (res.stderr or ""))
		if out ~= "" then
			notify(out, res.code ~= 0 and ERROR or nil)
		end
		render(buf)
	end)
end

A.open_external = function(buf)
	local st = states[buf]
	local e = st.entries[fn.line(".") - 1]
	if e then
		vim.ui.open(join(st.dir, e.name))
	end
end

local function yank(buf, full)
	local st = states[buf]
	local e = st.entries[fn.line(".") - 1]
	if not e then
		return
	end
	local text = full and join(st.dir, e.name) or e.name
	fn.setreg('"', text)
	pcall(fn.setreg, "+", text)
	notify(text)
end
A.yank_name = function(buf)
	yank(buf, false)
end
A.yank_path = function(buf)
	yank(buf, true)
end

A.quit = function(buf)
	if #api.nvim_tabpage_list_wins(0) > 1 then
		api.nvim_win_close(0, false)
	else
		local alt = fn.bufnr("#")
		if alt > 0 and alt ~= buf and api.nvim_buf_is_valid(alt) then
			api.nvim_set_current_buf(alt)
		else
			vim.cmd("enew")
		end
	end
	if api.nvim_buf_is_valid(buf) and fn.bufwinid(buf) == -1 then
		pcall(api.nvim_buf_delete, buf, { force = true })
	end
end

---------------------------------------------------------------------------
-- keymaps
---------------------------------------------------------------------------

local function map(buf, mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true })
	table.insert(states[buf].mapped, { mode, lhs })
end

local function unmap_all(buf)
	for _, m in ipairs(states[buf].mapped) do
		pcall(vim.keymap.del, m[1], m[2], { buffer = buf })
	end
	states[buf].mapped = {}
end

local function map_normal(buf)
	for lhs, name in pairs(M.config.keys) do
		if name and A[name] then
			map(buf, RANGE[name] and { "n", "x" } or "n", lhs, function()
				A[name](buf)
			end)
		end
	end
end

---------------------------------------------------------------------------
-- wdired: edit the buffer, apply as renames
---------------------------------------------------------------------------

local wdired_commit

local function stop_wdired(buf)
	local st = states[buf]
	st.wdired = false
	vim.bo[buf].modifiable = false
	unmap_all(buf)
	map_normal(buf)
	render(buf)
end

A.wdired = function(buf)
	local st = states[buf]
	if st.wdired then
		return
	end
	st.wdired = true
	unmap_all(buf)
	vim.bo[buf].modifiable = true
	vim.bo[buf].modified = false
	map(buf, "n", "<C-c><C-c>", function()
		wdired_commit(buf)
	end)
	map(buf, "n", "<C-c><C-k>", function()
		stop_wdired(buf)
	end)
	map(buf, "n", "ZZ", function()
		wdired_commit(buf)
	end)
	map(buf, "n", "ZQ", function()
		stop_wdired(buf)
	end)
	notify("wdired — edit names, :w / <C-c><C-c> applies, <C-c><C-k> aborts (don't add/remove lines)")
end

wdired_commit = function(buf)
	local st = states[buf]
	local lines = api.nvim_buf_get_lines(buf, 1, -1, false)
	if #lines ~= #st.entries then
		return notify(
			("line count changed (%d → %d); fix it or abort with <C-c><C-k>"):format(#st.entries, #lines),
			ERROR
		)
	end

	local plan, sources = {}, {}
	for i, e in ipairs(st.entries) do
		local new = lines[i]:sub(PREFIX + 1)
		if new ~= e.name then
			if new == "" then
				return notify("line " .. (i + 1) .. ": empty file name", ERROR)
			end
			local from = join(st.dir, e.name)
			plan[#plan + 1] = { from = from, to = is_abs(new) and fs.normalize(new) or join(st.dir, new) }
			sources[from] = true
		end
	end
	if #plan == 0 then
		stop_wdired(buf)
		return notify("no changes")
	end

	-- validate everything before touching the disk
	local seen = {}
	for _, p in ipairs(plan) do
		if seen[p.to] then
			return notify("duplicate target: " .. p.to, ERROR)
		end
		seen[p.to] = true
		local same = case_insensitive and p.to:lower() == p.from:lower()
		if uv.fs_lstat(p.to) and not sources[p.to] and not same then
			return notify("target exists: " .. p.to, ERROR)
		end
	end

	-- phase 1: move everything aside so swaps and cycles (a<->b) just work
	for i, p in ipairs(plan) do
		p.tmp = ("%s.dired-tmp-%d-%d"):format(p.from, uv.os_getpid(), i)
		local ok, err = uv.fs_rename(p.from, p.tmp)
		if not ok then
			for j = 1, i - 1 do
				uv.fs_rename(plan[j].tmp, plan[j].from)
			end
			return notify("rename failed (rolled back): " .. tostring(err), ERROR)
		end
	end
	-- phase 2: to final names (creating parent dirs if the name had a "/")
	local errs = {}
	for _, p in ipairs(plan) do
		local ok, err = move(p.tmp, p.to)
		if ok then
			retarget(p.from, p.to)
		else
			uv.fs_rename(p.tmp, p.from)
			errs[#errs + 1] = fs.basename(p.from) .. ": " .. tostring(err)
		end
	end

	st.marks = {}
	stop_wdired(buf)
	refresh_all()
	if #errs > 0 then
		notify(table.concat(errs, "\n"), ERROR)
	end
	return true
end

---------------------------------------------------------------------------
-- public API
---------------------------------------------------------------------------

local function find_buf(name)
	for _, b in ipairs(api.nvim_list_bufs()) do
		if api.nvim_buf_is_valid(b) and api.nvim_buf_get_name(b) == name then
			return b
		end
	end
end

local function new_buffer(dir, name)
	local buf = api.nvim_create_buf(false, false)
	api.nvim_buf_set_name(buf, name)
	states[buf] = {
		dir = dir,
		entries = {},
		marks = {},
		mapped = {},
		sort = M.config.sort,
		hidden = M.config.show_hidden,
		wdired = false,
	}
	local bo = vim.bo[buf]
	bo.buftype, bo.swapfile, bo.bufhidden, bo.filetype, bo.modifiable = "acwrite", false, "hide", "dired", false

	map_normal(buf)

	local g = api.nvim_create_augroup("dired_buf_" .. buf, { clear = true })
	api.nvim_create_autocmd("BufEnter", {
		group = g,
		buffer = buf,
		callback = function()
			if not states[buf].wdired then
				render(buf)
			end -- auto-revert when re-entering
			vim.wo.cursorline, vim.wo.wrap = true, false
		end,
	})
	api.nvim_create_autocmd("BufWriteCmd", {
		group = g,
		buffer = buf,
		callback = function()
			if states[buf].wdired then
				wdired_commit(buf)
			else
				notify("not in wdired mode (<C-x><C-q> to start)")
			end
		end,
	})
	api.nvim_create_autocmd("BufWipeout", {
		group = g,
		buffer = buf,
		callback = function()
			states[buf] = nil
			pcall(api.nvim_del_augroup_by_id, g)
		end,
	})
	return buf
end

--- Open Dired on `dir` (default: cwd) in the current window; optionally put the
--- cursor on `name`.
function M.open(dir, name)
	define_hl()
	dir = fs.normalize(fn.fnamemodify(fn.expand(dir or "."), ":p"))
	if fn.isdirectory(dir) == 0 then
		return notify("not a directory: " .. dir, ERROR)
	end

	local bname = "dired://" .. dir
	local buf = find_buf(bname) or new_buffer(dir, bname)
	local was_current = api.nvim_get_current_buf() == buf
	api.nvim_set_current_buf(buf) -- BufEnter renders
	if was_current then
		render(buf)
	end
	if name then
		goto_name(buf, name)
	end
end

--- dired-jump: open the directory of the current file with the cursor on it.
function M.jump()
	local st = states[api.nvim_get_current_buf()]
	if st then
		return M.open(fs.dirname(st.dir), fs.basename(st.dir))
	end
	local file = api.nvim_buf_get_name(0)
	if file == "" then
		return M.open(fn.getcwd())
	end
	M.open(fs.dirname(file), fs.basename(file))
end

local keys = {
    vi = {
		["<CR>"] = "visit",
		f = "visit",
		o = "visit_other",
		["^"] = "up",
		["-"] = "up",
		gr = "revert",
		s = "sort",
		gh = "hidden",
		m = "mark",
		u = "unmark",
		U = "unmark_all",
		t = "toggle_marks",
		d = "flag",
		x = "execute",
		["%m"] = "mark_regex",
		["%d"] = "flag_regex",
		D = "delete",
		R = "move",
		C = "copy",
		["+"] = "mkdir",
		N = "touch",
		['='] = "chmod",
			["!"] = "shell",
		X = "open_external",
		yy = "yank_name",
		Y = "yank_path",
		q = "quit",
		["<C-x><C-q>"] = "wdired",
		gW = "wdired",
		i = "wdired",
    },
    default = {
		["<CR>"] = "visit",
		f = "visit",
		o = "visit_other",
		["^"] = "up",
		["-"] = "up",
		gr = "revert",
		s = "sort",
		gh = "hidden",
		m = "mark",
		u = "unmark",
		U = "unmark_all",
		t = "toggle_marks",
		d = "flag",
		x = "execute",
		["%m"] = "mark_regex",
		["%d"] = "flag_regex",
		D = "delete",
		R = "move",
		C = "copy",
		["+"] = "mkdir",
		N = "touch",
		['='] = "chmod",
		M = "chmod",
		["!"] = "shell",
		X = "open_external",
		yy = "yank_name",
		Y = "yank_path",
		q = "quit",
		["<C-x><C-q>"] = "wdired",
    }
}


-- TASK(20261116-220152): Move this to plugin/
function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
	local g = api.nvim_create_augroup("dired", { clear = true })

	define_hl()
	api.nvim_create_autocmd("ColorScheme", { group = g, callback = define_hl })

	api.nvim_create_user_command("Dired", function(o)
		M.open(o.args ~= "" and o.args or nil)
	end, { nargs = "?", complete = "dir", desc = "Open Dired" })
	api.nvim_create_user_command("DiredJump", M.jump, { desc = "Dired at current file" })

	if M.config.hijack_netrw then
		vim.g.loaded_netrw, vim.g.loaded_netrwPlugin = 1, 1
		-- Change this to work with the new 'directory' filetype
		api.nvim_create_autocmd("BufEnter", {
			group = g,
			callback = function(a)
				local name = api.nvim_buf_get_name(a.buf)
				if name == "" or name:match("^dired://") or vim.bo[a.buf].buftype ~= "" then
					return
				end
				if fn.isdirectory(name) == 1 then
					vim.schedule(function()
						if not api.nvim_buf_is_valid(a.buf) then
							return
						end
						M.open(name)
						pcall(api.nvim_buf_delete, a.buf, { force = true })
					end)
				end
			end,
		})
	end
end

return M
