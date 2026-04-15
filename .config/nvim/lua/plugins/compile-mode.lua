return {
  -- {},
  {
    "ej-shafran/compile-mode.nvim",
    version = "^5.0.0",
    enable = false,
    -- you can just use the latest version:
    -- branch = "latest",
    -- or the most up-to-date updates:
    -- branch = "nightly",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- if you want to enable coloring of ANSI escape codes in
      -- compilation output, add:
      -- { "m00qek/baleia.nvim", tag = "v1.3.0" },
    },
    config = function()
      ---@type CompileModeOpts
      vim.g.compile_mode = {
        -- if you use something like `nvim-cmp` or `blink.cmp` for completion,
        -- set this to fix tab completion in command mode:
        input_word_completion = true,

        -- to add ANSI escape code support, add:
        -- baleia_setup = true,

        -- to make `:Compile` replace special characters (e.g. `%`) in
        -- the command (and behave more like `:!`), add:
        bang_expansion = true,
      }
      vim.keymap.set("n", "<leader>cc", function()
        require("compile-mode").compile({})
      end, { desc = "Compile" })

      vim.keymap.set("n", "<A-c>", function()
        require("compile-mode").compile({})
      end, { desc = "Compile" })

      vim.keymap.set("n", "<A-S-c>", function()
        require("compile-mode").recompile({})
      end, { desc = "Compile" })
    vim.keymap.set("n", "<leader>s?", ":Compile rg --hidden --vimgrep ", { desc = "Grep with compile mode" })
      vim.keymap.set("n", "<leader>cC", function()
        require("compile-mode").recompile({})
      end, { desc = "Recompile" })
      vim.keymap.set("n", "<leader>cn", function()
        require("compile-mode").next_error_follow()
      end, { desc = "Compile go to next error" })
      vim.keymap.set("n", "<leader>cp", function()
        require("compile-mode").prev_error_follow()
      end, { desc = "Compile go to previous error" })
      vim.keymap.set("n", "<A-g>n", function()
        require("compile-mode").next_error_follow()
      end, { desc = "Compile go to next error" })
      vim.keymap.set("n", "<A-g>p", function()
        require("compile-mode").prev_error_follow()
      end, { desc = "Compile go to previous error" })
      vim.keymap.set("n", "<A-g><A-n>", function()
        require("compile-mode").next_error_follow()
      end, { desc = "Compile go to next error" })
      vim.keymap.set("n", "<A-g><A-p>", function()
        require("compile-mode").prev_error_follow()
      end, { desc = "Compile go to previous error" })
    end,
  },
}
