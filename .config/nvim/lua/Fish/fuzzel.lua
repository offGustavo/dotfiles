 -- File picker using fd + fuzzel
 local function fuzzel_pick_files()
   local fd_cmd = "fd --type f --hidden --exclude .git"
   local fuzzel_cmd = "fuzzel --dmenu --lines=15 --prompt='File: '"
   local full_cmd = fd_cmd .. " | " .. fuzzel_cmd

   local handle = io.popen(full_cmd)
   if not handle then
     vim.notify("Failed to run fuzzel or fd", vim.log.levels.ERROR)
     return
   end

   local result = handle:read("*a")
   handle:close()
   result = result:gsub("^%s*(.-)%s*$", "%1")

   if result == "" then
     vim.notify("No file selected", vim.log.levels.INFO)
     return
   end

   vim.cmd("edit " .. vim.fn.fnameescape(result))
 end

 -- Grep (search inside files) using rg (preferred) or grep, then pick with fuzzel
 local function fuzzel_grep()
   -- First ask for the search pattern
   vim.ui.input({ prompt = "Search pattern: " }, function(pattern)
     if not pattern or pattern == "" then
       vim.notify("No pattern given", vim.log.levels.INFO)
       return
     end

     -- Escape pattern for shell (simple version – for production consider vim.fn.shellescape)
     local escaped_pattern = pattern:gsub("'", "'\\''")

     -- Determine which grep tool to use
     local grep_cmd
     if vim.fn.executable("rg") == 1 then
       -- ripgrep: output file:line:column:match
       grep_cmd = string.format("rg --column --line-number --no-heading --color=never -- '%s'", escaped_pattern)
     elseif vim.fn.executable("grep") == 1 then
       -- fallback to GNU grep with similar format
       grep_cmd = string.format("grep -r -n -H -- '%s' .", escaped_pattern)
     else
       vim.notify("Neither ripgrep (rg) nor grep found", vim.log.levels.ERROR)
       return
     end

     -- Build full pipeline: grep -> fuzzel
     local fuzzel_cmd = "fuzzel --dmenu --lines=15 --prompt='Grep: '"
     local full_cmd = grep_cmd .. " 2>/dev/null | " .. fuzzel_cmd

     local handle = io.popen(full_cmd)
     if not handle then
       vim.notify("Failed to run grep or fuzzel", vim.log.levels.ERROR)
       return
     end

     local result = handle:read("*a")
     handle:close()
     result = result:gsub("^%s*(.-)%s*$", "%1")

     if result == "" then
       vim.notify("No match selected or no results", vim.log.levels.INFO)
       return
     end

     -- Parse the selected line to extract file and line number.
     -- Expected format (rg):   path/to/file:line:column:matched text
     -- Expected format (grep): path/to/file:line:matched text
     local file, line
     if vim.fn.executable("rg") == 1 then
       -- ripgrep format
       file, line = result:match("^([^:]+):(%d+):")
     else
       -- grep format
       file, line = result:match("^([^:]+):(%d+):")
     end

     if not file or not line then
       vim.notify("Could not parse grep result: " .. result, vim.log.levels.ERROR)
       return
     end

     -- Open the file and jump to the line
     vim.cmd(string.format("edit +%d %s", tonumber(line), vim.fn.fnameescape(file)))
   end)
 end

 -- Create user commands
 vim.api.nvim_create_user_command("FuzzelFiles", fuzzel_pick_files, {})
 vim.api.nvim_create_user_command("FuzzelGrep", fuzzel_grep, {})

 -- Optional keymaps
 vim.keymap.set("n", "<M-o>", fuzzel_pick_files, { desc = "Open file with fuzzel" })
 vim.keymap.set("n", "<M-g>", fuzzel_grep,      { desc = "Grep with fuzzel" })
