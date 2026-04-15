-- if vim.fn.executable("colorscript") == 0 then
--   return {
--     "snacks.nvim",
--     opts = {
--       dashboard = {
--         enabled = false,
--       },
--     },
--   }
-- else
  return {
    "snacks.nvim",
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          pick = function(cmd, opts)
            return LazyVim.pick(cmd, opts)()
          end,
          header = [[
 ███     █████                       ███  ████ 
░███    ░░███                       ░░░  ░░███ 
░███  ███████   ██████  █████ █████ ████  ░███ 
░███ ███░░███  ███░░███░░███ ░░███ ░░███  ░███ 
░███░███ ░███ ░███████  ░███  ░███  ░███  ░███ 
░░░ ░███ ░███ ░███░░░   ░░███ ███   ░███  ░███ 
 ███░░████████░░██████   ░░█████    █████ █████
░░░  ░░░░░░░░  ░░░░░░     ░░░░░    ░░░░░ ░░░░░ 
            ]],
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            -- { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            -- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            -- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            -- { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            -- { icon = " ", key = "z", desc = "Change Directory", action = ":lua Snacks.dashboard.pick('zoxide')" },
            -- { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            -- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            -- { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            -- { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            -- { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          {
            -- pane = 2,
            section = "startup",
            padding = { 1, 0 },
          },
          -- {
          --   pane = 2,
          --   section = "terminal",
          --   -- cmd = "pokeget --hide-name bulbasaur",
          --   cmd = "colorscript -e square",
          --   -- cmd = "colorscript -e pacman",
          --   -- cmd = "chafa ~/Pictures/Wallpapers/my/gengara.jpg --format symbols --symbols vhalf --size 60x11 --stretch",
          --   -- cmd = "fzf",
          --   height = 7,
          --   padding = { 2, 0 },
          --   -- indent = 10,
          -- },
          -- {
          --   pane = 2,
          --   icon = " ",
          --   desc = "Browse Repo",
          --   padding = 1,
          --   key = "b",
          --   action = function()
          --     Snacks.gitbrowse()
          --   end,
          -- },
          -- { section = "keys", gap = 1, padding = 1 },
          -- { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          -- { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          -- {
          --   pane = 2,
          --   icon = " ",
          --   title = "Git Status",
          --   section = "terminal",
          --   enabled = function()
          --     return Snacks.git.get_root() ~= nil
          --   end,
          --   cmd = "git status --short --branch --renames",
          --   height = 5,
          --   padding = 1,
          --   ttl = 5 * 60,
          --   indent = 3,
          -- },
        },
      },
    },
  }
-- end
