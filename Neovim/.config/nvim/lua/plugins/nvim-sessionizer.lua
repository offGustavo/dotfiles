return {
  -- "offGustavo/nvim-sessionizer",
  dir = "~/Projects/nvim-sessionizer/",
  config = function()
require("nvim-sessionizer").setup({
    -- Disable Zoxide integration.
    -- Set this to true if:
    --   1. You don't have Zoxide installed, or
    --   2. You prefer not to use Zoxide for project selection.
    no_zoxide = false,

    -- A list of directories where Sessionizer will search for projects.
    -- Each entry should be an absolute path or use ~ for the home directory.
    -- Example:
    --   { "~/Projects", "~/Work" }
    search_dirs = { "~/Projects" },

    -- Maximum search depth for fd or find when listing projects.
    -- This controls how many directory levels are scanned.
    -- Example:
    --   max_depth = 3 means: search up to 3 subdirectory levels deep.
    max_depth = 1,
})
    vim.keymap.set("n", "<A-o>", function()
      require("nvim-sessionizer").sessionizer()
    end, { silent = true, desc = "Create an new session wiht zoxide" })
    vim.keymap.set("n", "<A-n>", function()
      require("nvim-sessionizer").new_session()
    end, { silent = true, desc = "Create an new session in the current dir" })
    vim.keymap.set("n", "<A-u>", function()
      require("nvim-sessionizer").attach_session()
    end, { silent = true, desc = "Attach to and sessins with vim.ui.select" })
    vim.keymap.set("n", "<A-S-0>", function()
      require("nvim-sessionizer").attach_session("+1")
    end, { silent = true, desc = "Go to next session" })
    vim.keymap.set("n", "<A-S-9>", function()
      require("nvim-sessionizer").attach_session("-1")
    end, { silent = true, desc = "Go to previous session" })
    vim.keymap.set("n", "<A-x>", function()
      require("nvim-sessionizer").remove_session()
    end, { silent = true })
    vim.keymap.set("n", "<A-s>", function()
      require("nvim-sessionizer").list_sessions()
    end, { silent = true, desc = "List sessions" })
    vim.keymap.set("n", "<A-d>", ":detach<CR>", { silent = true, desc = "Detach current session" })
    for i = 1, 9, 1 do
      vim.keymap.set("n", "<C-" .. i .. ">", function()
        require("nvim-sessionizer").attach_session(i)
      end, { silent = true, desc = "Go to " .. i .. "session" })
    end

  end,
}
