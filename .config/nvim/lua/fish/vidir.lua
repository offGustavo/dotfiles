-- vidir.lua – edit directories and filenames inside Neovim

local M = {}

local function ensure_dir(path)
    if path == '' then return true end
    local stat = vim.loop.fs_stat(path)
    if stat and stat.type == 'directory' then
        return true
    end
    local parent = vim.fn.fnamemodify(path, ':h')
    if parent ~= '' and parent ~= path then
        if not ensure_dir(parent) then return false end
    end
    local ok, err = vim.loop.fs_mkdir(path, 493) -- 0755
    if not ok then
        vim.notify(string.format("vidir: failed to create directory %s: %s", path, err), vim.log.levels.ERROR)
        return false
    end
    return true
end

local function generate_tmp(base)
    local tmp_base = base .. '~'
    local tmp = tmp_base
    local counter = 0
    while vim.loop.fs_stat(tmp) do
        counter = counter + 1
        tmp = tmp_base .. counter
    end
    return tmp
end

function M.open(user_args)
    local args = user_args or {}
    local items = {}
    local verbose = false

    -- Parse options
    local i = 1
    while i <= #args do
        local arg = args[i]
        if arg == '-v' or arg == '--verbose' then
            verbose = true
            table.remove(args, i)
        else
            i = i + 1
        end
    end

    if #args == 0 then
        table.insert(args, '.')
    end

    -- Collect items from arguments
    for _, arg in ipairs(args) do
        if arg == '-' then
            -- Read filenames from current buffer
            local buf = vim.api.nvim_get_current_buf()
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            for _, line in ipairs(lines) do
                if line ~= '' then
                    table.insert(items, line)
                end
            end
        else
            local stat = vim.loop.fs_stat(arg)
            if not stat then
                vim.notify(string.format("vidir: cannot access %s: No such file or directory", arg), vim.log.levels.ERROR)
                return
            end
            if stat.type == 'directory' then
                local dir_handle = vim.loop.fs_opendir(arg, nil, 100)
                if not dir_handle then
                    vim.notify(string.format("vidir: cannot read directory %s", arg), vim.log.levels.ERROR)
                    return
                end
                local entries = {}
                while true do
                    local entry = vim.loop.fs_readdir(dir_handle)
                    if not entry then break end
                    if entry.name ~= '.' and entry.name ~= '..' then
                        table.insert(entries, arg .. '/' .. entry.name)
                    end
                end
                vim.loop.fs_closedir(dir_handle)
                table.sort(entries)
                vim.list_extend(items, entries)
            else
                table.insert(items, arg)
            end
        end
    end

    -- Reject control characters
    for _, item in ipairs(items) do
        if item:find('[%c]') then
            vim.notify("vidir: control characters in filenames are not supported", vim.log.levels.ERROR)
            return
        end
    end

    -- Create scratch buffer
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'modifiable', true)
    vim.api.nvim_buf_set_option(buf, 'swapfile', false)
    vim.api.nvim_buf_set_name(buf, 'vidir-' .. os.time())

    -- Write numbered lines
    local lines = {}
    local max_digits = #tostring(#items)
    local original_map = {}
    for idx, path in ipairs(items) do
        local num_str = string.format('%0' .. max_digits .. 'd', idx)
        table.insert(lines, num_str .. '\t' .. path)
        original_map[idx] = path
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Store metadata
    vim.api.nvim_buf_set_var(buf, 'vidir_original', original_map)
    vim.api.nvim_buf_set_var(buf, 'vidir_verbose', verbose)

    -- Apply changes on :w
    local group = vim.api.nvim_create_augroup('VidirAuto', { clear = false })
    vim.api.nvim_clear_autocmds({ buffer = buf, group = group })
    vim.api.nvim_create_autocmd('BufWriteCmd', {
        buffer = buf,
        group = group,
        callback = function()
            M.apply_changes(buf)
        end,
    })

    -- Open buffer
    vim.api.nvim_set_current_buf(buf)

    -- Simple highlighting for numbers
    vim.api.nvim_buf_add_highlight(buf, -1, 'Number', 0, 0, max_digits)
end

function M.apply_changes(buf)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local original = vim.api.nvim_buf_get_var(buf, 'vidir_original')
    local verbose = vim.api.nvim_buf_get_var(buf, 'vidir_verbose')
    local error_flag = false

    -- Parse current lines
    local current = {}
    local seen_numbers = {}
    for i, line in ipairs(lines) do
        if line:match('^%s*$') then
            -- skip empty lines
        else
            local num_str, name = line:match('^(%d+)\t(.*)$')
            if not num_str then
                vim.notify(string.format("vidir: unable to parse line %d: %s", i, line), vim.log.levels.ERROR)
                error_flag = true
                goto continue
            end
            local num = tonumber(num_str)
            if seen_numbers[num] then
                vim.notify(string.format("vidir: duplicate number %d on line %d", num, i), vim.log.levels.ERROR)
                error_flag = true
                goto continue
            end
            seen_numbers[num] = true
            current[num] = name
            ::continue::
        end
    end

    if error_flag then
        vim.notify("vidir: errors in parsing, aborting", vim.log.levels.ERROR)
        return
    end

    -- Build rename list and deletion list
    local to_delete = {}
    local rename_list = {}
    local rename_by_src = {}
    for num, src in pairs(original) do
        if not current[num] then
            table.insert(to_delete, src)
        elseif current[num] ~= src then
            local r = { src = src, dst = current[num] }
            table.insert(rename_list, r)
            rename_by_src[src] = r
        end
    end

    -- Perform a single rename with conflict handling
    local function perform_rename(r)
        local src = r.src
        local dst = r.dst

        local src_stat = vim.loop.fs_stat(src)
        if not src_stat then
            vim.notify(string.format("vidir: source %s does not exist", src), vim.log.levels.ERROR)
            error_flag = true
            return false
        end

        local dst_stat = vim.loop.fs_stat(dst)
        if dst_stat then
            if rename_by_src[dst] then
                -- Destination is also a source (swap/chain) → move it aside
                local tmp = generate_tmp(dst)
                local ok, err = vim.loop.fs_rename(dst, tmp)
                if not ok then
                    vim.notify(string.format("vidir: failed to rename %s to %s: %s", dst, tmp, err), vim.log.levels.ERROR)
                    error_flag = true
                    return false
                end
                if verbose then
                    vim.notify(string.format("'%s' -> '%s'", dst, tmp), vim.log.levels.INFO)
                end
                -- Update the pending rename that had dst as source
                local other = rename_by_src[dst]
                rename_by_src[dst] = nil
                other.src = tmp
                rename_by_src[tmp] = other
            else
                -- Destination exists but is not tracked → move aside
                local tmp = generate_tmp(dst)
                local ok, err = vim.loop.fs_rename(dst, tmp)
                if not ok then
                    vim.notify(string.format("vidir: failed to rename %s to %s: %s", dst, tmp, err), vim.log.levels.ERROR)
                    error_flag = true
                    return false
                end
                if verbose then
                    vim.notify(string.format("'%s' -> '%s'", dst, tmp), vim.log.levels.INFO)
                end
            end
        end

        -- Ensure destination directory exists
        local dst_dir = vim.fn.fnamemodify(dst, ':h')
        if dst_dir ~= '' and not vim.loop.fs_stat(dst_dir) then
            if not ensure_dir(dst_dir) then
                error_flag = true
                return false
            end
        end

        -- Perform the rename
        local ok, err = vim.loop.fs_rename(src, dst)
        if not ok then
            vim.notify(string.format("vidir: failed to rename %s to %s: %s", src, dst, err), vim.log.levels.ERROR)
            error_flag = true
            return false
        end
        if verbose then
            vim.notify(string.format("'%s' => '%s'", src, dst), vim.log.levels.INFO)
        end

        -- If a directory was renamed, update pending paths that start with the old prefix
        if src_stat.type == 'directory' then
            for _, rr in ipairs(rename_list) do
                local function update_path(p)
                    if p == src then
                        return p   -- the directory itself is already moved
                    end
                    if p:sub(1, #src + 1) == src .. '/' then
                        return dst .. p:sub(#src + 1)
                    end
                    return p
                end
                rr.src = update_path(rr.src)
                rr.dst = update_path(rr.dst)
            end
            -- Also update rename_by_src keys
            local new_by_src = {}
            for k, v in pairs(rename_by_src) do
                local new_k = k
                if k:sub(1, #src + 1) == src .. '/' then
                    new_k = dst .. k:sub(#src + 1)
                end
                new_by_src[new_k] = v
            end
            rename_by_src = new_by_src
        end

        -- Mark this rename as done
        rename_by_src[src] = nil
        return true
    end

    -- Process all renames (iterate over a copy because the list may be updated)
    local rename_list_copy = vim.deepcopy(rename_list)
    for _, r in ipairs(rename_list_copy) do
        if rename_by_src[r.src] then
            if not perform_rename(r) then
                error_flag = true
            end
        end
    end

    -- Process deletions
    for _, file in ipairs(to_delete) do
        local stat = vim.loop.fs_stat(file)
        if stat then
            local ok, err
            if stat.type == 'directory' then
                ok, err = vim.loop.fs_rmdir(file)
            else
                ok, err = vim.loop.fs_unlink(file)
            end
            if not ok then
                vim.notify(string.format("vidir: failed to remove %s: %s", file, err), vim.log.levels.ERROR)
                error_flag = true
            elseif verbose then
                vim.notify(string.format("removed '%s'", file), vim.log.levels.INFO)
            end
        else
            vim.notify(string.format("vidir: %s does not exist, cannot delete", file), vim.log.levels.WARN)
        end
    end

    if not error_flag then
        vim.api.nvim_buf_delete(buf, { force = true })
    else
        vim.notify("vidir: some operations failed, check messages", vim.log.levels.ERROR)
    end
end

-- Register the user command
vim.api.nvim_create_user_command('Vidir', function(opts)
  local args = opts.fargs
  if #args == 0 then
    args = { vim.loop.cwd() }
  end
  M.open(args)
end, { nargs = '*', complete = 'file' })

return M
