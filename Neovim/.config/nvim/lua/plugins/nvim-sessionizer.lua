return {
  -- "offGustavo/nvim-sessionizer",
  dir = "~/Projects/nvim-sessionizer/",
  config = function()
    require("nvim-sessionizer").setup({
      no_zoxide = false,
      search_dirs = { "~/Projects" },
      max_depth = 3,
      ui = {
        keymap = {
          quit = "q",
          attach = "<CR>",
          delete = "<S-d>",
          move_up = "<C-k>",
          move_down = "<C-j>",
        },
        win = {
          width = 0.6,
          height = 0.4,
          winbar = {
            hl_left = "Title", -- highlight group para a parte esquerda
            hl_right = "Comment", -- highlight group para a parte direita
            hl_separator = "Comment", -- highlight group para a parte direita
            sep_left = "/", -- separador entre ações
            sep_mid = "%=", -- separador para alinhar
            sep_right = "│",
            format = function(config) -- agora recebe o config
              return {
                left = {
                  " " .. config.ui.keymap.quit .. " close",
                  config.ui.keymap.delete .. " delete session",
                },
                right = {
                  config.ui.keymap.attach .. " attach session",
                  config.ui.keymap.move_up .. "/" .. config.ui.keymap.move_down .. " move session ",
                },
              }
            end,
          },
        },
        current = {
          mark = ">",
          hl = "MatchParen",
        },
      },
    })
    vim.keymap.set({ "n", "v", "i", "t" }, "<A-o>", function()
      require("nvim-sessionizer").sessionizer()
    -- end, { silent = true, desc = "Create an new session wiht zoxide" })
    -- vim.keymap.set({ "n", "v", "i", "t" }, "<A-S-W>", function()
    --   require("nvim-sessionizer").new_session()
    end, { silent = true, desc = "Create an new session in the current dir" })
    vim.keymap.set({ "n", "v", "i", "t" }, "<A-u>", function()
      require("nvim-sessionizer").attach_session()
    end, { silent = true, desc = "Attach to and sessins with vim.ui.select" })
    vim.keymap.set({ "n", "v", "i", "t" }, "<A-S-0>", function()
      require("nvim-sessionizer").attach_session("+1")
    end, { silent = true, desc = "Go to next session" })
    vim.keymap.set({ "n", "v", "i", "t" }, "<A-S-9>", function()
      require("nvim-sessionizer").attach_session("-1")
    end, { silent = true, desc = "Go to previous session" })
    vim.keymap.set({ "n", "v", "i", "t" }, "<A-q>", function()
      require("nvim-sessionizer").remove_session()
    end, { silent = true })
    vim.keymap.set({ "n", "v", "i", "t" }, "<A-s>", function()
      require("nvim-sessionizer").manage_sessions()
    end, { silent = true, desc = "List sessions" })
    vim.keymap.set({ "n", "v", "i", "t" }, "<A-d>", ":detach<CR>", { silent = true, desc = "Detach current session" })
    for i = 1, 9, 1 do
      vim.keymap.set({ "n", "v", "i", "t" }, "<C-" .. i .. ">", function()
        require("nvim-sessionizer").attach_session(i)
      end, { silent = true, desc = "Go to " .. i .. "session" })
    end
  end,
}
