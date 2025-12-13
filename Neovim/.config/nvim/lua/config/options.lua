-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.cmd([[
  let maplocalleader = "\<BS>"
]])

vim.g.snacks_animate = false

-- vim.opt.scrolloff = 999
vim.opt.scrolloff = 0

vim.o.wrap = false

vim.o.list = false

vim.o.swapfile = false

vim.opt.spelllang = { "pt_br", "en_us", "es" }

vim.cmd([[
  " let g:netrw_banner = 0
  set path+=**
  set wildignore+=**/node_modules/**
]])

-- vim.g.lazyvim_picker = "snacks"
-- vim.g.lazyvim_picker = "telescope"
-- vim.g.lazyvim_picker = "fzf-lua"

-- Disable autoformat
vim.g.autoformat = false -- globally

-- local function Winbar()
--   local normal_color = "%#Normal#"
--   local mode = "%-5{%v:lua.string.upper(v:lua.vim.fn.mode())%}"
--   local file_name = "%-.16t"
--   local buf_nr = "[%n]"
--   local modified = "%#MiniIconsRed% %-M"
--   local file_type = " %y"
--   local right_align = "%="
--   local line_no = "%10([%l/%L%)]"
--   local pct_thru_file = "%5p%%"
--   return string.format("%s%s%s", normal_color, file_name, modified)
-- end
-- vim.opt.winbar = Winbar()

----------------------
-- NEOVIDE          --
----------------------

if vim.g.neovide then
  vim.g.neovide_padding_top = 8
  vim.g.neovide_padding_bottom = 8
  vim.g.neovide_padding_right = 8
  vim.g.neovide_padding_left = 8
end

if vim.uv.os_uname().sysname == "Windows_NT" then
  vim.opt.shell = "pwsh.exe"
  vim.opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
end

vim.o.makeprg = "make"

if vim.fn.has("nvim-0.12") == 1 then
  if not vim.g.vscode then
    vim.o.cmdheight = 1
    -- Experimental
    require("vim._extui").enable({
        enable = true, -- Whether to enable or disable the UI.
        msg = { -- Options related to the message module.
          ---@type 'cmd'|'msg' Where to place regular messages, either in the
          ---cmdline or in a separate ephemeral message window.
          target = "cmd",
          timeout = 2000, -- Time a message is visible in the message window.
        },
                                })
  end
end

-- Better Grep and Find with ripgrep
if vim.fn.executable("rg") then
  vim.o.grepprg = "rg --vimgrep -. --smart-case -g '!.git' -g '!node_modules/'"
  function _G.RgFindFiles(cmdarg, _cmdcomplete)
    local fnames = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git" --glob="!node_modules/"')
    if #cmdarg == 0 then
      return fnames
    else
      return vim.fn.matchfuzzy(fnames, cmdarg)
    end
  end

  vim.o.findfunc = "v:lua.RgFindFiles"
end

-- -- Better Cd with Zoxide
-- if vim.fn.executable("zoxide") == 1 then
--   vim.api.nvim_create_user_command("Cd", function(opts)
--     local target = opts.args
--     if target == "" then
--       vim.cmd("cd ~")
--       return
--     end
--     local handle = io.popen("zoxide query " .. vim.fn.shellescape(target))
--     if handle then
--       local result = handle:read("*l")
--       handle:close()
--       if result and #result > 0 then
--         vim.cmd("cd " .. vim.fn.fnameescape(result))
--         print("Changed directory to: " .. result)
--       else
--         print("zoxide: no match for '" .. target .. "'")
--       end
--     else
--       print("Failed to run zoxide")
--     end
--   end, { nargs = "?" })
-- end

-- vim.o.winborder = "rounded"
