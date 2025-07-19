return {
  dir = "~/Projects/TabTerm.nvim/",
  -- 'offGustavo/TabTerm.nvim',
  opts = {},
  keys = function()

    local keys = {

      {
        mode ={ 'i', 'n', 't'},
        "<A-m>c",
        function ()
          require('TabTerm').new()
        end,
        desc = "Create Terminal"
      },

      {
        mode ={ 'i', 'n', 't'},
        "<A-m>x",
        function ()
          require('TabTerm').close()
        end,
        desc = "Close Terminal"
      },

      {
        mode ={ 'i', 'n', 't'},
        "<A-m>d",
        function ()
          require('TabTerm').toggle()
        end,
        desc = "Toggle Terminal"
      },

      {
        mode ={ 'i', 'n', 't'},
        "<A-m>,",
        function ()
          require('TabTerm').rename()
        end,
        desc = "Rename Terminal"
      },


      {
        mode ={ 'i', 'n', 't'},
        "<A-n>",
        function ()
          require('TabTerm').new()
        end,
        desc = "Create Terminal"
      },

      {
        mode ={ 'i', 'n', 't'},
        "<A-x>",
        function ()
          require('TabTerm').close()
        end,
        desc = "Close Terminal"
      },

      {
        mode ={ 'i',
          'n',
          't'},
        "<A-/>",
        function ()
          require('TabTerm').toggle()
        end,
        desc = "Toggle Terminal"
      },

      {
        mode ={ 'i', 'n', 't'},
        "<A-,>",
        function ()
          require('TabTerm').rename()
        end,
        desc = "Rename Terminal"
      },


    }

    for i = 1, 9 do
      table.insert(keys, {
        mode ={ 'i', 'n', 't'},
        "<A-m>" .. i,
        function()
          require('TabTerm').goto(i)
        end,
        desc = "Goto to Terminal [" .. i .. "]",
      })

    end
    return keys

  end,
}
