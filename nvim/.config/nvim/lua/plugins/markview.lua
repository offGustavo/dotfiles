-- return {
--   "OXY2DEV/markview.nvim",
--   lazy = false,
--   config = function()
--     require("markview").setup({
--       preview = {
--         modes = { "n", "no", "c" },
--         hybrid_modes = { "n", "v" },
--         linewise_hybrid_mode = true,
--       },
--     })
--   end,
-- }

return {
  "OXY2DEV/markview.nvim",
  lazy = false, -- Recommended
  -- ft = "markdown" -- If you decide to lazy-load anyway
  --

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.icons",
  },
  config = function()
    local checkboxes = require("markview.presets")
    local headings = require("markview.presets").headings
    local horizontal_rules = require("markview.presets").horizontal_rules

    require("markview").setup({
      --- "modes" is used for demonstration
      preview = {
        icon_provider = "mini", -- "mini" or "devicons"
        --- purposes. In most cases you wouldn't
        --- need to change this.
        modes = { "n", "v", "c", "nc" },
        hybrid_modes = { "n", "v" },
        checkboxes = checkboxes.checkboxes.nerd,
        headings = headings.glow,
        horizontal_rules = horizontal_rules.thin,
      },
      html = {
        enable = true,

        --- Tag renderer for tags that have an
        --- opening & closing tag.
        tags = {
          enable = true,

          --- Default configuration
          default = {
            --- When true, the tag is concealed.
            ---@type boolean
            conceal = false,

            --- Highlight group for the text inside
            --- of the tag
            ---@type string?
            hl = nil,
          },

          --- Configuration for specific tag(s).
          --- The key is the tag and the value is the
          --- used configuration.
          configs = {
            b = { conceal = true, hl = "Bold" },
            u = { conceal = true, hl = "Underlined" },
          },
        },

        --- HTML entity configuration
        html = {
          entities = {
            enable = true,

            --- Highlight group for the rendered entity.
            ---@type string?
            hl = nil,
          },
        },
      },
      markdown = {
        list_items = {
          enable = true,

          --- Amount of spaces that defines an indent
          --- level of the list item.
          ---@type integer
          indent_size = 2,

          --- Amount of spaces to add per indent level
          --- of the list item.
          ---@type integer
          shift_width = 2,

          marker_minus = {
            add_padding = true,

            text = "•",
            hl = "NormalNC",
          },
          marker_plus = {
            add_padding = true,

            text = "•",
            hl = "NormalNC",
          },
          marker_star = {
            add_padding = true,

            text = "•",
            hl = "NormalNC",
            -- text = "",
            -- hl = "MarkviewListItemStar",
          },

          --- These items do NOT have a text or
          --- a hl property!

          --- n. Items
          marker_dot = {
            add_padding = true,
          },

          --- n) Items
          marker_parenthesis = {
            add_padding = true,
          },
        },
      },
      latex = {
        enable = true,

        --- Bracket conceal configuration.
        --- Shows () in specific cases
        parenthesis = {
          enable = true,

          --- Highlight group for the ()
          ---@type string
          hl = "@punctuation.brackets",
        },

        --- LaTeX blocks renderer
        blocks = {
          enable = true,

          --- Highlight group for the block
          ---@type string
          hl = "Code",

          --- Virtual text to show on the bottom
          --- right.
          --- First value is the text and second value
          --- is the highlight group.
          ---@type string[]
          text = { " LaTeX ", "Special" },
        },

        --- Configuration for inline LaTeX maths
        inlines = {
          enable = true,
        },

        --- Configuration for operators(e.g. "\frac{1}{2}")
        commands = {
          enable = true,
          configs = {
            sin = {
              --- Configuration for the extmark added
              --- to the name of the operator(e.g. "\sin").
              ---
              --- see `nvim_buf_set_extmark()` for all the
              --- options.
              ---@type table
              operator = {
                conceal = "",
                virt_text = { { "𝚜𝚒𝚗", "Special" } },
              },

              --- Configuration for the arguments of this
              --- operator.
              --- Item index is used to apply the configuration
              --- to a specific argument
              ---@type table[]
              args = {
                {
                  --- Extmarks are only added
                  --- if a config for it exists.

                  --- Configuration for the extmark
                  --- added before this argument.
                  ---
                  --- see `nvim_buf_set_extmark` for more.
                  before = {},

                  --- Configuration for the extmark
                  --- added after this argument.
                  ---
                  --- see `nvim_buf_set_extmark` for more.
                  after = {},

                  --- Configuration for the extmark
                  --- added to the range of text of
                  --- this argument.
                  ---
                  --- see `nvim_buf_set_extmark` for more.
                  scope = {},
                },
              },
            },
          },
        },

        --- Configuration for LaTeX symbols.
        overwrite = {
          enable = true,

          --- Highlight group for the symbols.
          ---@type string?
          hl = "@operator.latex",

          --- Allows adding/modifying symbol definitions.
          overwrite = {
            --- Symbols can either be strings or functions.
            --- When the value is a function it receives the buffer
            --- id as the parameter.
            ---
            --- The resulting string is then used.
            ---@param buffer integer.
            today = function(buffer)
              return os.date("%d %B, %Y")
            end,
          },

          --- Create groups of symbols to only change their
          --- appearance.
          groups = {
            {
              --- Matcher for this group.
              ---
              --- Can be a list of symbols or a function
              --- that takes the symbol as the parameter
              --- and either returns true or false.
              ---
              ---@type string[] | fun(symbol: string): boolean
              match = { "lim", "today" },

              --- Highlight group for this group.
              ---@type string
              hl = "Special",
            },
          },
        },

        subscripts = {
          enable = true,

          hl = "MarkviewLatexSubscript",
        },

        superscripts = {
          enable = true,

          hl = "MarkviewLatexSuperscript",
        },
      },
    })
    require("markview.extras.editor").setup({
      --- The minimum & maximum window width
      --- If the value is smaller than 1 then
      --- it is used as a % value.
      ---@type [ number, number ]
      width = { 10, 0.75 },

      --- The minimum & maximum window height
      ---@type [ number, number ]
      height = { 3, 0.75 },

      --- Delay(in ms) for window resizing
      --- when typing.
      ---@type integer
      debounce = 50,

      --- Callback function to run on
      --- the floating window.
      ---@type fun(buf:integer, win:integer): nil
      callback = function(buf, win) end,
    })

    -- Markview
    require("which-key").add({
      { "<leader>m", group = "Markdown", mode = "n" },
    })
    vim.keymap.set(
      { "n", "v" },
      "<leader>mm",
      "<cmd>Markview toggleAll<CR>",
      { silent = true, desc = "Toggle Markview" }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>mh",
      "<cmd>Markview hybridToggle<CR>",
      { silent = true, desc = "Toggle Hybrid Mode" }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>mp",
      "<cmd>Markview splitToggle<CR>",
      { silent = true, desc = "Toggle Split View" }
    )
  end,
}
