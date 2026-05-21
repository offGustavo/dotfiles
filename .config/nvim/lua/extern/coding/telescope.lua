return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  enabled = Fish.is_windows(),
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- optional but recommended
    -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  keys = function()
    local builtin = require("telescope.builtin")
    return {
      { "<leader>ff", builtin.find_files, desc = "Telescope find files" },
      { "<leader>ss", builtin.live_grep, desc = "Telescope live grep" },
      { "<leader>bb", builtin.buffers, desc = "Telescope buffers" },
      { "<leader>vh", builtin.help_tags, desc = "Telescope help tags" },
      { "<leader>fa", builtin.builtin, desc = "Telescope" },
    }
  end,
}
