return {
  "folke/flash.nvim",
  event = "VeryLazy",
  vscode = true,
  lazy = true,
  ---@type Flash.Config
  opts = {
    -- labels = "abcdefghijklmnopqrstuvwxyz",
    labels = "asdfghjklqwertyuiopzxcvbnm",
    search = {
      -- search/jump in all windows
      multi_window = true,
      -- search direction
      forward = true,
      -- when `false`, find only matches in the given direction
      wrap = true,
      ---@type Flash.Pattern.Mode
      -- Each mode will take ignorecase and smartcase into account.
      -- * exact: exact match
      -- * search: regular search
      -- * fuzzy: fuzzy search
      -- * fun(str): custom function that returns a pattern
      --   For example, to only match at the beginning of a word:
      --   mode = function(str)
      --     return "\\<" .. str
      --   end,
      mode = "fuzzy",
      -- behave like `incsearch`
      incremental = false,
      -- Excluded filetypes and custom window filters
      ---@type (string|fun(win:window))[]
      exclude = {
        "notify",
        "cmp_menu",
        "noice",
        "flash_prompt",
        function(win)
          -- exclude non-focusable windows
          return not vim.api.nvim_win_get_config(win).focusable
        end,
      },
      -- Optional trigger character that needs to be typed before
      -- a jump label can be used. It's NOT recommended to set this,
      -- unless you know what you're doing
      trigger = "",
      -- max pattern length. If the pattern length is equal to this
      -- labels will no longer be skipped. When it exceeds this length
      -- it will either end in a jump or terminate the search
      max_length = false, ---@type number|false
    },
    jump = {
      -- save location in the jumplist
      jumplist = true,
      -- jump position
      pos = "start", ---@type "start" | "end" | "range"
      -- add pattern to search history
      history = false,
      -- add pattern to search register
      register = false,
      -- clear highlight after jump
      nohlsearch = false,
      -- automatically jump when there is only one match
      autojump = true,
      -- You can force inclusive/exclusive jumps by setting the
      -- `inclusive` option. By default it will be automatically
      -- set based on the mode.
      inclusive = nil, ---@type boolean?
      -- jump position offset. Not used for range jumps.
      -- 0: default
      -- 1: when pos == "end" and pos < current position
      offset = nil, ---@type number
    },
    label = {
      -- allow uppercase labels
      uppercase = true,
      -- add any labels with the correct case here, that you want to exclude
      exclude = "",
      -- add a label for the first match in the current window.
      -- you can always jump to the first match with `<CR>`
      current = true,
      -- show the label after the match
      after = true, ---@type boolean|number[]
      -- show the label before the match
      before = false, ---@type boolean|number[]
      -- position of the label extmark
      style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
      -- flash tries to re-use labels that were already assigned to a position,
      -- when typing more characters. By default only lower-case labels are re-used.
      reuse = "lowercase", ---@type "lowercase" | "all" | "none"
      -- for the current window, label targets closer to the cursor first
      distance = true,
      -- minimum pattern length to show labels
      -- Ignored for custom labelers.
      min_pattern_length = 0,
      -- Enable this to use rainbow colors to highlight labels
      -- Can be useful for visualizing Treesitter ranges.
      rainbow = {
        enabled = false,
        -- number between 1 and 9
        shade = 5,
      },
      -- With `format`, you can change how the label is rendered.
      -- Should return a list of `[text, highlight]` tuples.
      ---@class Flash.Format
      ---@field state Flash.State
      ---@field match Flash.Match
      ---@field hl_group string
      ---@field after boolean
      ---@type fun(opts:Flash.Format): string[][]
      format = function(opts)
        return { { opts.match.label, opts.hl_group } }
      end,
    },
    highlight = {
      -- show a backdrop with hl FlashBackdrop
      backdrop = true,
      -- Highlight the search matches
      matches = true,
      -- extmark priority
      priority = 5000,
      groups = {
        match = "FlashMatch",
        current = "FlashCurrent",
        backdrop = "FlashBackdrop",
        label = "FlashLabel",
      },
    },
    -- action to perform when picking a label.
    -- defaults to the jumping logic depending on the mode.
    ---@type fun(match:Flash.Match, state:Flash.State)|nil
    action = nil,
    -- initial pattern to use when opening flash
    pattern = "",
    -- When `true`, flash will try to continue the last search
    continue = false,
    -- Set config to a function to dynamically change the config
    config = nil, ---@type fun(opts:Flash.Config)|nil
    -- You can override the default options for a specific mode.
    -- Use it with `require("flash").jump({mode = "forward"})`
    ---@type table<string, Flash.Config>
    modes = {
      -- options used when flash is activated through
      -- a regular search with `/` or `?`
      search = {
        -- when `true`, flash will be activated during regular search by default.
        -- You can always toggle when searching with `require("flash").toggle()`
        enabled = false,
        highlight = { backdrop = false },
        jump = { history = true, register = true, nohlsearch = true },
        search = {
          -- `forward` will be automatically set to the search direction
          -- `mode` is always set to `search`
          -- `incremental` is set to `true` when `incsearch` is enabled
        },
      },
      -- options used when flash is activated through
      -- `f`, `F`, `t`, `T`, `;` and `,` motions
      char = {
        enabled = true,
        -- dynamic configuration for ftFT motions
        config = function(opts)
          -- autohide flash when in operator-pending mode
          opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")

          -- disable jump labels when not enabled, when using a count,
          -- or when recording/executing registers
          opts.jump_labels = opts.jump_labels
            and vim.v.count == 0
            and vim.fn.reg_executing() == ""
            and vim.fn.reg_recording() == ""

          -- Show jump labels only in operator-pending mode
          -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
        end,
        -- hide after jump when not using jump labels
        autohide = false,
        -- show jump labels
        jump_labels = false,
        -- set to `false` to use the current line only
        multi_line = true,
        -- When using jump labels, don't use these keys
        -- This allows using those keys directly after the motion
        label = { exclude = "hjkliardc" },
        -- by default all keymaps are enabled, but you can disable some of them,
        -- by removing them from the list.
        -- If you rather use another key, you can map them
        -- to something else, e.g., { [";"] = "L", [","] = H }
        keys = { "f", "F", "t", "T", ";", "," },
        ---@alias Flash.CharActions table<string, "next" | "prev" | "right" | "left">
        -- The direction for `prev` and `next` is determined by the motion.
        -- `left` and `right` are always left and right.
        char_actions = function(motion)
          return {
            [";"] = "next", -- set to `right` to always go right
            [","] = "prev", -- set to `left` to always go left
            -- clever-f style
            [motion:lower()] = "next",
            [motion:upper()] = "prev",
            -- jump2d style: same case goes next, opposite case goes prev
            -- [motion] = "next",
            -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
          }
        end,
        search = { wrap = false },
        highlight = { backdrop = true },
        jump = {
          register = false,
          -- when using jump labels, set to 'true' to automatically jump
          -- or execute a motion when there is only one match
          autojump = false,
        },
      },
      -- options used for treesitter selections
      -- `require("flash").treesitter()`
      treesitter = {
        labels = "abcdefghijklmnopqrstuvwxyz",
        jump = { pos = "range", autojump = true },
        search = { incremental = false },
        label = { before = true, after = true, style = "inline" },
        highlight = {
          backdrop = false,
          matches = false,
        },
      },
      treesitter_search = {
        jump = { pos = "range" },
        search = { multi_window = true, wrap = true, incremental = false },
        remote_op = { restore = true },
        label = { before = true, after = true, style = "inline" },
      },
      -- options used for remote flash
      remote = {
        remote_op = { restore = true, motion = true },
      },
    },
    -- options for the floating window that shows the prompt,
    -- for regular jumps
    -- `require("flash").prompt()` is always available to get the prompt text
    prompt = {
      enabled = true,
      prefix = { { "⚡", "FlashPromptIcon" } },
      win_config = {
        relative = "editor",
        width = 1, -- when <=1 it's a percentage of the editor width
        height = 1,
        row = -1, -- when negative it's an offset from the bottom
        col = 0, -- when negative it's an offset from the right
        zindex = 1000,
      },
    },
    -- options for remote operator pending mode
    remote_op = {
      -- restore window views and cursor position
      -- after doing a remote operation
      restore = false,
      -- For `jump.pos = "range"`, this setting is ignored.
      -- `true`: always enter a new motion when doing a remote operation
      -- `false`: use the window's cursor position and jump target
      -- `nil`: act as `true` for remote windows, `false` for the current window
      motion = false,
    },
  },
  -- stylua: ignore
  --NOTE:
  -- Remove default keymap for flash in lazyvim
  config = function ()
    vim.keymap.del({"n", "x", "o"} , "s")
    vim.keymap.del({"n", "x", "o"} , "S")
  end,
  keys = {
    {
      "ss",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "st",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Treesitter Search",
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
}
