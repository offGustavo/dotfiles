return {
  "https://github.com/folke/snacks.nvim",
  lazy = false,
  enabled = true,
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
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
      },
      sections = {
        { section = "header" },
        {
          section = "startup",
          padding = { 1, 0 },
        },
      },
    },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = false },
    image = { enabled = true },
    notifier = {
      enabled = false,
      timeout = 3000,
    },
    picker = { enabled = false },
    layout = {
      ivy_split = {
        preview = "main",
        layout = {
          box = "vertical",
          backdrop = false,
          width = 0,
          height = 0.4,
          position = "bottom",
          border = "top",
          title = " {title} {live} {flags}",
          title_pos = "left",
          { win = "input", height = 1, border = "none" },
          {
            box = "horizontal",
            { win = "list", border = "none" },
            { win = "preview", title = "{preview}", width = 0.6, border = "left" },
          },
        },
      },
    },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = {
      enabled = false,
      left = { "mark", "sign" }, -- priority of signs on the left (high to low)
      right = { "fold", "git" }, -- priority of signs on the right (high to low)
      folds = {
        open = false, -- show open fold icons
        git_hl = true, -- use Git Signs hl for fold icons
      },
      git = {
        -- patterns to match Git signs
        patterns = { "GitSign", "MiniDiffSign" },
      },
      refresh = 50, -- refresh at most every 50ms
    },
    words = { enabled = false },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      },
    },
  },
  init = function()
    vim.g.snacks_animate = false

    local Snacks = require("snacks")

    -- Create some toggle mappings
    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
    Snacks.toggle.diagnostics():map("<leader>ud")
    Snacks.toggle.line_number():map("<leader>ul")
    Snacks.toggle
      .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
      :map("<leader>uc")
    Snacks.toggle.treesitter():map("<leader>uT")
    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
    Snacks.toggle.inlay_hints():map("<leader>uh")
    Snacks.toggle.indent():map("<leader>ug")
    Snacks.toggle.dim():map("<leader>uD")
    Snacks.toggle
      .new({
        id = "toggle_sing_and_line_column",
        name = "Relative Line Number and Sign Column",
        get = function()
          return vim.o.relativenumber
        end,
        set = function(state)
          if state then
            vim.o.signcolumn = "no"
            vim.opt.number = false
            vim.opt.relativenumber = false
          end
          vim.o.signcolumn = "yes"
          vim.opt.number = state
          vim.opt.relativenumber = state
        end,
      })
      :map("<leader>u<M-l>")

    Snacks.toggle.option("cursorline", { off = false, on = true }):map("<leader>u<C-l>")
  end,
  keys = {
    -- Zoom
    {
      "<leader>uz",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen Mode",
    },
    {
      "<leader>uZ",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Toggle Zoom",
    },

    -- Scratch Buffer
    {
      "<leader>fs",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>fS",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },
    {
      "<leader>uN",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>fR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },

    -- Git
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
      mode = { "n", "v" },
    },

    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },

    -- Terminal
    {
      "<c-/>",
      function()
        Snacks.terminal()
      end,
      mode = { "t", "x", "n", },
      desc = "Toggle Terminal",
    },
    {
      "<c-_>",
      function()
        Snacks.terminal()
      end,
      mode = { "t", "x", "n", },
      desc = "which_key_ignore",
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<M-\\>",
      function()
        Snacks.terminal("tmux")
      end,
      mode = { "i", "x", "n", "t" },
      desc = "Tmux",
    },

    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
      mode = { "n", "t" },
    },

    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
  },
}
