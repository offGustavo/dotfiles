return {
  "https://github.com/ibhagwan/fzf-lua",
  enabled = false,
  opts = {
    {
      "ivy",
      -- "fzf-native",
      "telescope",
      "hide",
    },
    -- Window options for Ivy layout
    winopts = {
      -- Ivy style: no floating window borders
      border = "none",
      -- Height relative to screen (use full height)
      height = 1.0,
      -- Width relative to screen
      width = 1.0,
      -- Row position: 1.0 pushes it to bottom
      row = 1.0,
      -- Column position
      col = 0.5,
      -- Preview options
      preview = {
        hidden = true,
        -- Preview window position (ivy style: preview above results)
        vertical = "up:70%",
        -- Preview border
        border = "none",
        -- Preview layout
        layout = "vertical",
      },
      -- Disable Treesitter in the picker window for performance
      treesitter = false,
    },
    ui_select = {
      winopts = {
        height = 0.3,
      },
    },
    colorschemes = {
      winopts = { height = 0.55, width = 0.50, col = 0.5, row = 0.0, backdrop = false },
    },
    fzf_opts = {
      ["--sort"] = false,
    },
    fzf_colors = {
      true, -- inherit fzf colors that aren't specified below from
    },
  },
  keys = {

    -- Custom Alt keymaps
    { "<M-o>", "<Cmd>FzfLua files<Cr>", desc = "Find" },
    { "<M-s>", "<Cmd>FzfLua live_grep<Cr>", desc = "Grep" },
    { "<M-b>", "<Cmd>FzfLua buffers<Cr>", desc = "Buffers" },
    { "<M-r>", "<Cmd>FzfLua oldfiles<Cr>", desc = "Oldfiles" },
    { "<M-p>", "<Cmd>FzfLua global<Cr>", desc = "Global" },

    -- Builtin
    { "<leader>fa", "<Cmd>FzfLua<Cr>", desc = "Builtin" },

    -- Find
    {
      "<leader>ff",
      function()
        require("fzf-lua").files()
      end,
      desc = "Find",
    },
    {
      "<leader>fo",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "Oldfiles",
    },
    {
      "<leader>fr",
      function() end,
      desc = "Recent",
    },

    -- Search
    {
      "<leader>ss",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>st",
      function()
        require("fzf-lua").live_grep({
          regex = "TODO:",
        })
      end,
      desc = "Grep 'TODO:'",
    },
    {
      "<leader>sw",
      function()
        require("fzf-lua").grep_cword()
      end,
      desc = "Grep <cword>",
    },
    {
      mode = "x",
      "<leader>sw",
      function()
        require("fzf-lua").live_grep({
          -- FIXME: this can have a better parser...
          regex = require("fzf-lua").utils.get_visual_selection(),
        })
      end,
      desc = "Grep <cword>",
    },
    {
      "<leader>sW",
      function()
        require("fzf-lua").grep_cWORD()
      end,
      desc = "Grep <cWORD>",
    },
    {
      "<leader>s=",
      "<Cmd>FzfLua spell_suggest<Cr>",
      desc = "Spell suggest",
    },

    -- Buffers
    {
      "<leader>bb",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>bs",
      function()
        require("fzf-lua").lines()
      end,
      desc = "Buffers",
    },
    {
      "<leader>bw",
      function()
        require("fzf-lua").grep_curbuf({
          regex = vim.fn.expand("<cWord>"),
        })
      end,
      desc = "Vimgrep TODO: mod after",
    },
    {
      "<leader>bW",
      function()
        require("fzf-lua").grep_curbuf({
          regex = vim.fn.expand("<cWORD>"),
        })
      end,
      desc = "Vimgrep TODO: mod after",
    },
    {
      mode = "x",
      "<leader>bw",
      function()
        require("fzf-lua").grep_curbuf({
          -- regex = vim.fn.expand("<cWORD>"),
          search = require("fzf-lua").utils.get_visual_selection(),
        })
      end,
      desc = "Vimgrep TODO: mod after",
    },
    -- TODO: use lgrep_curbuf or locxation

    -- Git
    {
      "<leader>gf",
      "<Cmd>FzfLua git_files<Cr>",
      desc = "Git files",
    },
    {
      "<leader>gb",
      "<Cmd>FzfLua git_branches<Cr>",
      desc = "Git Branches",
    },
    {
      "<leader>gl",
      false,
    },
    -- TODO: add more git things...

    -- Vim
    {
      "<leader>vf",
      function()
        require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Find in config files",
    },
    {
      "<leader>vs",
      function()
        require("fzf-lua").live_grep({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Grep in config files",
    },
    {
      "<leader>vh",
      "<Cmd>FzfLua helptags<Cr>",
      desc = "Helptags",
    },
    {
      "<leader>vH",
      "<Cmd>FzfLua highlights<Cr>",
      desc = "Highlights",
    },
    {
      "<leader>vt",
      function()
        require("fzf-lua").colorschemes()
      end,
      desc = "Colorschemes",
    },

    --- Agenda/Notes
    {
      "<leader>af",
      function()
        require("fzf-lua").files({ cwd = "~/Notes/" })
      end,
      desc = "Find in ~/Notes",
    },
    {
      "<leader>as",
      function()
        require("fzf-lua").live_grep({ cwd = "~/Notes/" })
      end,
      desc = "Grep in ~/Notes",
    },
    {
      "<leader>at",
      function()
        require("fzf-lua").live_grep({
          cwd = "~/Notes/",
          regex = "TODO:",
        })
      end,
      desc = "Search TODO's in ~/Notes",
    },
  },
}
