return {
  "https://github.com/ibhagwan/fzf-lua",
  lazy = true,
  enabled = executable("fzf"),
  cmd = "FzfLua",
  event = "VeryLazy",
  opts = {
    {
      -- "ivy",
      -- "fzf-native",
      "telescope",
      -- "hide",
    },
    -- Window options for Ivy layout
    winopts = {
      -- -- Ivy style: no floating window borders
      -- border = "none",
      -- -- Height relative to screen (use full height)
      -- height = 1.0,
      -- -- Width relative to screen
      -- width = 1.0,
      -- -- Row position: 1.0 pushes it to bottom
      -- row = 1.0,
      -- -- Column position
      -- col = 0.5,
      -- -- Preview options
      -- preview = {
      --   hidden = false,
      --   -- Preview window position (ivy style: preview above results)
      --   vertical = "up:70%",
      --   -- Preview border
      --   border = "none",
      --   -- Preview layout
      --   layout = "vertical",
      -- },
      -- Disable Treesitter in the picker window for performance
      treesitter = Fish.highlight_state,
    },
    ui_select = {
      winopts = {
        height = 0.3,
      },
    },
    colorschemes = {
      winopts = { height = 0.30, width = 0.70, col = 1.0, row = 1.0, backdrop = false },
    },
    fzf_opts = {
      ["--sort"] = true,
      ["--tiebreak"] = "chunk,length",
    },
    fzf_colors = {
      true, -- inherit fzf colors that aren't specified below from
    },
  },
  keys = {
    { "<M-o>", "<Cmd>FzfLua files<Cr>", desc = "Find" },
    { "<M-s>", "<Cmd>FzfLua live_grep<Cr>", desc = "Grep" },
    { "<M-b>", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
    -- Builtin
    { "<leader>fa", "<Cmd>FzfLua<Cr>", desc = "Builtin" },
    -- Find
    { "<leader>f.", "<Cmd>FzfLua global<Cr>", desc = "Global" },
    {
      "<leader>,",
      "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
      desc = "Switch Buffer",
    },
    { "<leader>/", "<cmd>FzfLua live_grep<Cr>", desc = "Grep (Root Dir)" },
    { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<leader><space>", "<cmd>FzfLua files<Cr>", desc = "Find Files (Root Dir)" },
    -- find
    { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
    { "<leader>fB", "<cmd>FzfLua buffers<cr>", desc = "Buffers (all)" },
    {
      "<leader>fc",
      function()
        require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Find Config File",
    },
    { "<leader>ff", "<cmd>FzfLua files<Cr>", desc = "Find Files (Root Dir)" },
    -- { "<leader>fF", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
    {
      "<leader>fR",
      function()
        require("fzf-lua").oldfiles({ cwd = vim.uv.cwd() })
      end,
      desc = "Recent (cwd)",
    },
    -- git
    { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
    { "<leader>gd", "<cmd>FzfLua git_diff<cr>", desc = "Git Diff (files)" },
    { "<leader>gl", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
    { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
    { "<leader>gS", "<cmd>FzfLua git_stash<cr>", desc = "Git Stash" },
    -- search
    { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
    { "<leader>s/", "<cmd>FzfLua search_history<cr>", desc = "Search History" },
    { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
    { "<leader>sb", "<cmd>FzfLua lines<cr>", desc = "Buffer Lines" },
    { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
    { "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics" },
    { "<leader>sD", "<cmd>FzfLua diagnostics_document<cr>", desc = "Buffer Diagnostics" },
    {
      "<leader>sg",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "Grep (Root Dir)",
    },
    {
      "<leader>sG",
      function()
        require("fzf-lua").live_grep({ cwd = vim.fn.expand("%:h") })
      end,
      desc = "Grep (Root Dir)",
    },
    { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
    { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
    { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
    { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
    { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
    { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
    { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
    { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
    { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
    {
      "<leader>sw",
      function()
        require("fzf-lua").grep_cword()
      end,
      desc = "Grep <cword>",
    },
    {
      "<leader>sw",
      function()
        require("fzf-lua").live_grep({
          regex = require("fzf-lua").utils.get_visual_selection(),
        })
      end,
      mode = "x",
    },

    {
      "<leader>sW",
      function()
        require("fzf-lua").grep_cword({
          cwd = vim.fn.expand("%:h"),
        })
      end,
      desc = "Grep <cword> (cwd)",
    },
    {
      "<leader>sW",
      function()
        require("fzf-lua").live_grep({
          cwd = vim.fn.expand("%:h"),
          regex = require("fzf-lua").utils.get_visual_selection(),
        })
      end,
      mode = "x",
      desc = "Grep <cword> (cwd)",
    },
    {
      "<leader>uC",
      function()
        require("fzf-lua").colorschemes()
      end,
      desc = "Colorscheme with Preview",
    },
    {
      "<leader>ss",
      function()
        require("fzf-lua").lsp_document_symbols()
      end,
      desc = "Goto Symbol",
    },
    {
      "<leader>sS",
      function()
        require("fzf-lua").lsp_live_workspace_symbols()
      end,
      desc = "Goto Symbol (Workspace)",
    },
  },
}


-- LazyVim Config
--
  -- opts = function(_, opts)
  --   local fzf = require("fzf-lua")
  --   local config = fzf.config
  --   local actions = fzf.actions
  --
  --   -- Quickfix
  --   config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
  --   config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
  --   config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
  --   config.defaults.keymap.fzf["ctrl-x"] = "jump"
  --   config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
  --   config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
  --   config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
  --   config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"
  --
  --   -- Trouble
  --   if LazyVim.has("trouble.nvim") then
  --     config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open
  --   end
  --
  --   -- Toggle root dir / cwd
  --   config.defaults.actions.files["ctrl-r"] = function(_, ctx)
  --     local o = vim.deepcopy(ctx.__call_opts)
  --     o.root = o.root == false
  --     o.cwd = nil
  --     o.buf = ctx.__CTX.bufnr
  --     LazyVim.pick.open(ctx.__INFO.cmd, o)
  --   end
  --   config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]
  --   config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")
  --
  --   local img_previewer ---@type string[]?
  --   for _, v in ipairs({
  --     { cmd = "ueberzug", args = {} },
  --     { cmd = "chafa", args = { "{file}", "--format=symbols" } },
  --     { cmd = "viu", args = { "-b" } },
  --   }) do
  --     if vim.fn.executable(v.cmd) == 1 then
  --       img_previewer = vim.list_extend({ v.cmd }, v.args)
  --       break
  --     end
  --   end
  --
  --   return {
  --     "default-title",
  --     fzf_colors = true,
  --     fzf_opts = {
  --       ["--no-scrollbar"] = true,
  --     },
  --     defaults = {
  --       -- formatter = "path.filename_first",
  --       formatter = "path.dirname_first",
  --     },
  --     previewers = {
  --       builtin = {
  --         extensions = {
  --           ["png"] = img_previewer,
  --           ["jpg"] = img_previewer,
  --           ["jpeg"] = img_previewer,
  --           ["gif"] = img_previewer,
  --           ["webp"] = img_previewer,
  --         },
  --         ueberzug_scaler = "fit_contain",
  --       },
  --     },
  --     -- Custom LazyVim option to configure vim.ui.select
  --     ui_select = function(fzf_opts, items)
  --       return vim.tbl_deep_extend("force", fzf_opts, {
  --         prompt = " ",
  --         winopts = {
  --           title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
  --           title_pos = "center",
  --         },
  --       }, fzf_opts.kind == "codeaction" and {
  --         winopts = {
  --           layout = "vertical",
  --           -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
  --           height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 4) + 0.5) + 16,
  --           width = 0.5,
  --           preview = not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
  --             layout = "vertical",
  --             vertical = "down:15,border-top",
  --             hidden = "hidden",
  --           } or {
  --             layout = "vertical",
  --             vertical = "down:15,border-top",
  --           },
  --         },
  --       } or {
  --         winopts = {
  --           width = 0.5,
  --           -- height is number of items, with a max of 80% screen height
  --           height = math.floor(math.min(vim.o.lines * 0.8, #items + 4) + 0.5),
  --         },
  --       })
  --     end,
  --     winopts = {
  --       width = 0.8,
  --       height = 0.8,
  --       row = 0.5,
  --       col = 0.5,
  --       preview = {
  --         scrollchars = { "┃", "" },
  --       },
  --     },
  --     files = {
  --       cwd_prompt = false,
  --       actions = {
  --         ["alt-i"] = { actions.toggle_ignore },
  --         ["alt-h"] = { actions.toggle_hidden },
  --       },
  --     },
  --     grep = {
  --       actions = {
  --         ["alt-i"] = { actions.toggle_ignore },
  --         ["alt-h"] = { actions.toggle_hidden },
  --       },
  --     },
  --     lsp = {
  --       symbols = {
  --         symbol_hl = function(s)
  --           return "TroubleIcon" .. s
  --         end,
  --         symbol_fmt = function(s)
  --           return s:lower() .. "\t"
  --         end,
  --         child_prefix = false,
  --       },
  --       code_actions = {
  --         previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
  --       },
  --     },
  --   }
  -- end,
  -- config = function(_, opts)
  --   if opts[1] == "default-title" then
  --     -- use the same prompt for all pickers for profile `default-title` and
  --     -- profiles that use `default-title` as base profile
  --     local function fix(t)
  --       t.prompt = t.prompt ~= nil and " " or nil
  --       for _, v in pairs(t) do
  --         if type(v) == "table" then
  --           fix(v)
  --         end
  --       end
  --       return t
  --     end
  --     opts = vim.tbl_deep_extend("force", fix(require("fzf-lua.profiles.default-title")), opts)
  --     opts[1] = nil
  --   end
  --   require("fzf-lua").setup(opts)
  -- end,
  -- init = function()
  --   LazyVim.on_very_lazy(function()
  --     vim.ui.select = function(...)
  --       require("lazy").load({ plugins = { "fzf-lua" } })
  --       local opts = LazyVim.opts("fzf-lua") or {}
  --       require("fzf-lua").register_ui_select(opts.ui_select or nil)
  --       return vim.ui.select(...)
  --     end
  --   end)
  -- end,
