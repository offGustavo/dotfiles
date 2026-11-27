local function get_visual_selection()
  local save_reg = vim.fn.getreg('"')
  local save_type = vim.fn.getregtype('"')
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg("v")
  vim.fn.setreg('"', save_reg, save_type)
  return text:gsub("\n", " ")
end

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  version = false, -- telescope did only one release, so use HEAD for now
  dependencies = {
    "nvim-telescope/telescope-ui-select.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      enabled = not is_windows(),
      lazy = true,
      event = "VeryLazy",
    },
  },
  keys = function()
    local builtin = require("telescope.builtin")

    return {
      { "<M-o>", builtin.find_files, desc = "telescope find files" },
      { "<M-s>", builtin.live_grep, desc = "Telescope live grep" },
      { "<M-b>", builtin.buffers, desc = "Telescope buffers" },
      { "<leader>fa", builtin.builtin, desc = "Telescope" },
      { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
      { "<leader>/", builtin.live_grep, desc = "Grep (Root Dir)" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader><space>", builtin.find_files, desc = "Find Files (Root Dir)" },
      -- find
      {
        "<leader>fb",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
        desc = "Buffers",
      },
      { "<leader>fB", "<cmd>Telescope buffers<cr>", desc = "Buffers (all)" },
      {
        "<leader>fc",
        function()
          builtin.find_files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Config File",
      },
      { "<leader>ff", builtin.find_files, desc = "Find Files (Root Dir)" },
      {
        "<leader>fF",
        function()
          builtin.find_files({ cwd = vim.fn.expand("%:h", true, false) })
        end,
        desc = "Find Files (cwd)",
      },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      {
        "<leader>fR",
        function()
          builtin.oldfiles({ cwd = vim.uv.cwd() })
        end,
        desc = "Recent (cwd)",
      },
      -- git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
      { "<leader>gl", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
      { "<leader>gS", "<cmd>Telescope git_stash<cr>", desc = "Git Stash" },
      -- search
      { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>s/", "<cmd>Telescope search_history<cr>", desc = "Search History" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer Lines" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Buffer Diagnostics" },
      { "<leader>sg", builtin.live_grep, desc = "Grep (Root Dir)" },
      {
        "<leader>sG",
        function()
          builtin.live_grep { cwd = vim.fn.expand("%:h", true, false) }
        end,
        desc = "Grep (cwd)",
      },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
      { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
      {
        "<leader>sw",
        function()
          builtin.grep_string({ search = vim.fn.expand("<cword>", false, false) })
        end,
        desc = "Word (Root Dir)",
      },
      {
        "<leader>sW",
        function()
          builtin.grep_string({
            search = vim.fn.expand("<cword>", false, false),
            cwd = vim.fn.expand("%:h", true, false),
          })
        end,
        desc = "Word (cwd)",
      },
      {
        "<leader>sw",
        function()
          builtin.grep_string({ search = get_visual_selection() })
        end,
        mode = "x",
        desc = "Selection (Root Dir)",
      },
      {
        "<leader>sW",
        function()
          builtin.grep_string({
            search = get_visual_selection(),
            cwd = vim.fn.expand("%:h", true, false),
          })
        end,
        mode = "x",
        desc = "Selection (cwd)",
      },

      { "<leader>uC", "<Cmd>Telescope colorscheme<Cr>", desc = "Colorscheme" },
      {
        "<leader>ss",
        function()
          require("telescope.builtin").lsp_document_symbols()
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols({})
        end,
        desc = "Goto Symbol (Workspace)",
      },
    }
  end,
  config = function()
    require "telescope".setup {
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {
            -- even more opts
          },
        },
      },
    }
    require("telescope").load_extension("ui-select")
  end,
}
