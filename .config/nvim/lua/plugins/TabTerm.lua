return {
  'offGustavo/TabTerm.nvim',
  lazy = true,
  opts = {
    center = true,
    separator_first = "",
    separator_right = "",
    separator_left = "",
    -- separator_right = "",
    -- separator_left = "",
    -- separator_first = "",
    -- separator_first = "",
    -- separator_first = "",
    -- separator_first = " ",
    -- separator_right = "",
    -- separator_left = "",
    -- separator_first = "",
    tab_highlight = "%#lualine_a_normal#",
    default_highlight = "%#lualine_c_normal#",
  },
  keys = function()
    local keys = {
      {
        mode = { "i", "n", "t" },
        "<A-m>c",
        function()
          require("TabTerm").new()
        end,
        desc = "Create Terminal",
      },
      {
        mode = { "i", "n", "t" },
        "<A-m>x",
        function()
          require("TabTerm").close()
        end,
        desc = "Close Terminal",
      },
      {
        mode = { "i", "n", "t" },
        "<A-m>d",
        function()
          require("TabTerm").toggle()
        end,
        desc = "Toggle Terminal",
      },
      {
        mode = { "i", "n", "t" },
        "<A-m>,",
        function()
          require("TabTerm").rename()
        end,
        desc = "Rename Terminal",
      },
      {
        mode = { "i", "n", "t" },
        "<A-n>",
        function()
          require("TabTerm").new()
        end,
        desc = "Create Terminal",
      },
      {
        mode = { "i", "n", "t" },
        "<A-x>",
        function()
          require("TabTerm").close()
        end,
        desc = "Close Terminal",
      },
      {
        mode = { "i", "n", "t" },
        "<A-/>",
        function()
          require("TabTerm").toggle()
        end,
        desc = "Toggle Terminal",
      },
      {
        mode = { "i", "n", "t" },
        "<A-,>",
        function()
          require("TabTerm").rename()
        end,
        desc = "Rename Terminal",
      },
      {
        mode = { "i", "n", "t" },
        "<A-m>!",
        function()
          print("Test Legal Apenas")
        end,
        desc = "which_key_ignore",
      },
      {
        mode = { "i", "n", "t" },
        "<A-m>%",
        function()
          print("Test Legal Apenas")
        end,
        desc = "which_key_ignore",
      },
      {
        mode = { "i", "n", "t" },
        '<A-m>"',
        function()
          print("Test Legal Apenas")
        end,
        desc = "which_key_ignore",
      },
    }
    for i = 1, 9 do
      table.insert(keys, {
        mode = { "i", "n", "t" },
        "<A-m>" .. i,
        function()
          require("TabTerm").go(i)
        end,
        desc = "which_key_ignore",
      })
      table.insert(keys, {
        mode = { "i", "n", "t" },
        "<A-" .. i .. ">",
        function()
          require("TabTerm").go(i)
        end,
        desc = "which_key_ignore",
      })
    end
    return keys
  end,
}
