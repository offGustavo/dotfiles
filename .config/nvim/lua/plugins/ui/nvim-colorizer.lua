return {
  "https://github.com/catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  enabled = true,
  opts = {
    filetypes = { "*" }, -- filetypes to highlight, "*" for all
    buftypes = {}, -- buftypes to highlight
    user_commands = true, -- enable user commands (ColorizerToggle, etc.)
    lazy_load = true, -- lazily schedule buffer highlighting
    options = {
      parsers = {
        css = false, -- preset: enables names, hex, rgb, hsl, oklch, css_var
        css_fn = false, -- preset: enables rgb, hsl, oklch
        names = {
          enable = false, -- enable named colors (e.g. "Blue")
          lowercase = true, -- match lowercase names
          camelcase = true, -- match CamelCase names (e.g. "LightBlue")
          uppercase = false, -- match UPPERCASE names
          strip_digits = false, -- ignore names with trailing digits (e.g. "blue3")
          custom = false, -- custom name-to-hex mappings; table|function|false
          extra_word_chars = "-", -- extra chars treated as part of color name
        },
        hex = {
          default = true, -- default value for unset format keys (see above)
          rgb = true, -- #RGB (3-digit)
          rgba = true, -- #RGBA (4-digit)
          rrggbb = true, -- #RRGGBB (6-digit)
          rrggbbaa = true, -- #RRGGBBAA (8-digit)
          hash_aarrggbb = false, -- #AARRGGBB (QML-style, alpha first)
          aarrggbb = true, -- 0xAARRGGBB
          no_hash = false, -- hex without '#' at word boundaries
        },
        rgb = { enable = true }, -- rgb()/rgba() functions
        hsl = { enable = true }, -- hsl()/hsla() functions
        oklch = { enable = true }, -- oklch() function
        hwb = { enable = true }, -- hwb() function (CSS Color Level 4)
        lab = { enable = true }, -- lab() function (CIE Lab)
        lch = { enable = true }, -- lch() function (CIE LCH)
        css_color = { enable = true }, -- color() function (srgb, display-p3, a98-rgb, etc.)
        tailwind = {
          enable = false, -- parse Tailwind color names
          update_names = false, -- feed LSP colors back into name parser (requires both enable + lsp.enable)
          lsp = { -- accepts boolean, true is shortcut for { enable = true, disable_document_color = true }
            enable = false, -- use Tailwind LSP documentColor
            disable_document_color = true, -- auto-disable vim.lsp.document_color on attach
          },
        },
        sass = {
          enable = false, -- parse Sass color variables
          parsers = { css = true }, -- parsers for resolving variable values
          variable_pattern = "^%$([%w_-]+)", -- Lua pattern for variable names
        },
        xterm = { enable = true }, -- xterm 256-color codes (#xNN, \e[38;5;NNNm)
        ls_colors = { enable = false }, -- LS_COLORS/SGR snippets (e.g. =38;5;196, =48;2;0;0;255)
        xcolor = { enable = false }, -- LaTeX xcolor expressions (e.g. red!30)
        hsluv = { enable = false }, -- hsluv()/hsluvu() functions
        css_var_rgb = { enable = false }, -- CSS vars with R,G,B (e.g. --color: 240,198,198)
        css_var = {
          enable = false, -- resolve var(--name) references to their defined color
          parsers = { css = true }, -- parsers for resolving variable values
        },
        custom = {}, -- list of custom parser definitions
      },
      display = {
        mode = "background", -- string or list: "background"|"foreground"|"underline"|"virtualtext"
        background = {
          bright_fg = "#000000", -- text color on bright backgrounds
          dark_fg = "#ffffff", -- text color on dark backgrounds
        },
        virtualtext = {
          char = "■", -- character used for virtualtext
          position = "eol", -- "eol"|"before"|"after"
          hl_mode = "foreground", -- "background"|"foreground"
        },
        priority = {
          default = 150, -- extmark priority for normal highlights
          lsp = 200, -- extmark priority for LSP/Tailwind highlights
        },
        disable_document_color = true, -- true (all LSPs) | false | { lsp_name = true, ... }
      },
      hooks = {
        should_highlight_line = false, -- function(line, bufnr, line_num) -> bool
        should_highlight_color = false, -- function(rgb_hex, parser_name, ctx) -> bool
        transform_color = false, -- function(rgb_hex, ctx) -> string
        on_attach = false, -- function(bufnr, opts)
        on_detach = false, -- function(bufnr)
      },
      always_update = false, -- update highlights even in unfocused buffers
      debounce_ms = 0, -- debounce highlight updates (ms); 0 = no debounce
    },
  },
}
