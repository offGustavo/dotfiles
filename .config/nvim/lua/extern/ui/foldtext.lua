return {
  "OXY2DEV/foldtext.nvim",
  event = "VeryLazy",
  enabled = false,
  opts = {
    -- Ignore buffers with these buftypes.
    ignore_buftypes = {},
    -- Ignore buffers with these filetypes.
    ignore_filetypes = {},
    -- Ignore buffers/windows if the result
    -- is false.
    condition = function()
      return true
    end,
    styles = {
      default = {
        { kind = "bufline" },
      },
      custom_a = {
        -- Only on these filetypes.
        filetypes = {},
        -- Only on these buftypes.
        buftypes = {},

        -- Only if this condition is
        -- true.
        condition = function(win)
          return vim.wo[win].foldmethod == "manual"
        end,

        -- Parts to create the foldtext.
        parts = {
          { kind = "fold_size" },
        },
      },
      custom_b = {
        -- Only on these filetypes.
        filetypes = {},
        -- Only on these buftypes.
        buftypes = {},

        -- Only if this condition is
        -- true.
        condition = function(win)
          return vim.wo[win].foldmethod == "indent"
        end,

        -- Parts to create the foldtext.
        parts = {

          kind = "indent",
          -- Optional condition for this
          -- part.
          condition = function()
            return true
          end,

          hl = "Comment",
        },
      },
      --       custom_c = {
      --     kind = "description",
      --     -- Optional condition for this
      --     -- part.
      --     condition = function ()
      --         return true;
      --     end,
      --
      --     -- Pattern to detect the foldtext from the start line.
      --     -- Here I am using, "feat: Keymaps" & "fix, Something's not right here"
      --     pattern = '[\'"](.+)[\'"]',
      --     styles = {
      --         default = {
      --             hl = "@comment",
      --             icon = "💭 ",
      --             icon_hl = nil
      --         },
      --
      --         -- Style for `doc`(case-insensitive).
      --         -- Options are merged with `default`
      --         -- before being used.
      --         doc = {
      --             -- hl, icon_hl are inherited from
      --             -- `default`.
      --             icon = "📚 ",
      --         }
      --     }
      -- },
    },
  },
}
