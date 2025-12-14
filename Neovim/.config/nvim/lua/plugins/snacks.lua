return {
  "folke/snacks.nvim",
  opts = {
    -- indent = { enabled = false },
    -- scope = { enabled = false },
    lazygit = {
      config = {
        -- https://github.com/folke/snacks.nvim/discussions/87 
        os = {
          edit = '[ -z ""$NVIM"" ] && (nvim -- {{filename}}) || (nvim --server ""$NVIM"" --remote-send ""q"" && nvim --server ""$NVIM"" --remote {{filename}})',
        },
      },
    },
    explorer = {
      replace_netrw = false,
    },
    input = { enabled = false },
    picker = {
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
        explorer = { hidden = true, 
                     follow_file = true,
                     auto_close = true,
                     actions = {
                       explorer_up_and_collapse = function(picker)
                         picker:set_cwd(vim.fs.dirname(picker:cwd()))
                         picker:find()
                         require("snacks.explorer.tree"):close_all(picker:cwd())
                       end,
                       explorer_focus_or_confirm = function(picker, item, action)
                         if item.dir then
                           picker:set_cwd(item._path)
                           picker:find()
                         else
                           require("snacks.explorer.actions").actions.confirm(picker, item, action)
                         end
                       end,
                       explorer_collapse_and_close = function(picker)
                         require("snacks.explorer.tree"):close_all(picker:cwd())
                         picker:norm(function()
                             picker:close()
                         end)
                       end,
                     },
                     win = {
                       list = {
                         keys = {
                           --    ["h"] = "explorer_up_and_collapse",
                           ["<BS>"] = "explorer_up_and_collapse",
                           ["-"] = "explorer_up_and_collapse",
                           --   ["l"] = "explorer_focus_or_confirm",
                           ["<CR>"] = "explorer_focus_or_confirm",
                           --  ["q"] = "explorer_collapse_and_close",
                         },
                       },
                     },
        },
      },
      layout = {
        preview = false,
        layout = {
          box = "vertical",
          backdrop = false,
          row = -1,
          width = 0,
          height = 0.4,
          border = "top",
          title = " {title} {live} {flags}",
          title_pos = "left",
          { win = "input", height = 1, border = "none" },
          {
            box = "horizontal",
            { win = "list", border = "none" },
            { win = "preview", width = 0.6, border = "rounded" },
          },
        },
      },
    },
    animate = {
      duration = 10, -- ms per step
      easing = "linear",
      fps = 60, -- frames per second. Global setting for all animations
    },
    -- scope = {
    -- enabled = false,
    -- },
  },
  keys = {
    { "<leader>.", function() Snacks.picker.explorer() end,  desc = "Snacks Picker Files" },
    { "<leader>>", function() Snacks.scratch() end,  desc = "Snacks Picker Files" },
    { "<leader><space>", function() 
        Snacks.picker.smart({
            -- finder = "explorer",
            -- tree = true,
            hidden = true,
            matcher = {
              frequency = true,
            },
            win = {
              input = {
                keys = {
                  ["d"] = "bufdelete",
                  ["J"] = "preview_scroll_down",
                  ["K"] = "preview_scroll_up",
                  ["H"] = "preview_scroll_left",
                  ["L"] = "preview_scroll_right",
                  ["-"] = "explorer_up",
                  ["<Bs>"] = "explorer_up",
                  ["<"] = "explorer_up",
                  [">"] = "explorer_cd",     -- CHANGE DIR into selected folder
                  -- ["<CR>"] = "explorer_cd",  -- Enter also enters dir
                  ["h"] = "explorer_close", -- close directory
                  ["a"] = "explorer_add",
                  ["D"] = "explorer_del",
                  ["r"] = "explorer_rename",
                  ["c"] = "explorer_copy",
                  ["m"] = "explorer_move",
                  ["o"] = "explorer_open", -- open with system application
                  ["P"] = "toggle_preview",
                  ["y"] = { "explorer_yank", mode = { "n", "x" } },
                  ["p"] = "explorer_paste",
                  ["u"] = "explorer_update",
                  --TODO: add this to explorer
                  ["z"] = "cd",
                  ["Z"] = "tcd",
                  ["<leader>/"] = "picker_grep",
                  ["t"] = "terminal",
                  ["."] = "explorer_focus",
                  ["I"] = "toggle_ignored",
                  ["."] = "toggle_hidden",
                  ["M"] = "explorer_close_all",
                  ["]g"] = "explorer_git_next",
                  ["[g"] = "explorer_git_prev",
                  ["]d"] = "explorer_diagnostic_next",
                  ["[d"] = "explorer_diagnostic_prev",
                  ["]w"] = "explorer_warn_next",
                  ["[w"] = "explorer_warn_prev",
                  ["]e"] = "explorer_error_next",
                  ["[e"] = "explorer_error_prev",
                  --FIXME: dont work
                  ["e"] = function(prompt)
                    local item = prompt.item
                    if not item or not item.path then
                      return
                    end
                    local path = item.path
                    local stat = vim.loop.fs_stat(path)
                    if stat and stat.type == "file" then
                      path = vim.fn.fnamemodify(path, ":h")
                    end
                    Snacks.picker.explorer({
                        cwd = path,
                        hidden = zen
                    })
                  end,
                },
              },
              list = {
                keys = {
                  ["d"] = "bufdelete",
                  ["J"] = "preview_scroll_down",
                  ["K"] = "preview_scroll_up",
                  ["H"] = "preview_scroll_left",
                  ["L"] = "preview_scroll_right",
                },
              },
            },
        })
    end,  desc = "Snacks Smart Picker" },
    { "<S-Esc>", function() 
        Snacks.explorer({ hidden = true, })
    end, 
      desc = "Toggle File Tree" 
    },
    { "<leader>fa", function() 
        Snacks.picker()
    end, 
      desc = "All Snacks Pickers" 
    },
    {
      "<leader>z", function()
        Snacks.picker.zoxide()
      end,
      desc = "Zoxide Picker"
    },
    {
      "<leader>sP", function()
        Snacks.picker.grep({
            hidden = true,
            cwd = vim.fn.stdpath("config"),
        })
      end,
      desc = "Zoxide Picker"
    },
    {
      "<leader>,", function()
        Snacks.picker.buffers({
            -- I always want my buffers picker to start in normal mode
            -- on_show = function()
            --   vim.cmd.stopinsert()
            -- end,
            finder = "buffers",
            format = "buffer",
            hidden = false,
            unloaded = true,
            current = true,
            sort_lastused = true,
            win = {
              input = {
                keys = {
                  ["d"] = "bufdelete",
                },
              },
              list = { keys = { ["d"] = "bufdelete" } },
            },
            -- In case you want to override the layout for this keymap
            -- layout = "ivy",
        })
      end,
      desc = "Snacks Buffers Picker"
    },
    { "<leader>ow", function()
        Snacks.picker.grep({
            hidden = true,
            on_show = function()
              vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<C-r><C-a>", true, false, true),
                "i",
                true
              )
            end,
        })
    end,
      desc = "Grep cWord (root)"
    },
    { "<leader>oW", function()
        Snacks.picker.grep({
            hidden = true,
            cwd = ".",
            on_show = function()
              vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<C-r><C-a>", true, false, true),
                "i",
                true
              )
            end,
        })
    end, desc = "Grep cWord (cwd)" },
    { "<leader>lg", function()
      Snacks.lazygit({ cwd = LazyVim.root.git() })
      vim.keymap.set("t", "<Esc><Esc>", "<Esc><Esc>", { buffer = 0 })
      vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = 0 })
    end, desc = "Lazygit (cwd)" },
    { "<A-p>g", function()
      Snacks.lazygit({ cwd = LazyVim.root.git() })
      vim.keymap.set("t", "<Esc><Esc>", "<Esc><Esc>", { buffer = 0 })
      vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = 0 })
    end, desc = "Lazygit (cwd)" },
    { "<leader>gG", function()
      Snacks.lazygit({ cwd = LazyVim.root.git() })
      vim.keymap.set("t", "<Esc><Esc>", "<Esc><Esc>", { buffer = 0 })
      vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = 0 })
    end, desc = "Lazygit (cwd)" },
  }
}



