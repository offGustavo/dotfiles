return {
  "https://github.com/wurli/servery.nvim",
  config = function()
  -- The following are the defaults - you don't need to change them
  -- but you probably should at least set `dirs` and `ui.provider`.
    require("servery").setup({
      -- Either supply the directories as an array of strings, or a function
      -- which returns an array. Shorthands like `~` are expanded.
      dirs = { "~" }, ---@type string[] | fun(): string[]
      session_dir = vim.fs.joinpath(cache_dir, "servery.nvim"),
      ui = {
        -- Options: "builtin" | "snacks" | "fzf" | "telescope" | "mini_pick"
        provider = "fzf", ---@type servery.ui_provider
        prompt = "Switch Nvim Session",
        icons = {
          current = "",
          active = "",
          inactive = "",
        },
        actions = {
          ["<enter>"] = "switch",
          ["<c-g>"] = "switch_and_detach",
          ["<c-x>"] = "detach",
          ["<c-s>"] = "spawn",
        },
        -- fzf-lua uses fzf's keymap notation, so it gets its own actions table
        fzf_actions = {
          ["enter"] = "switch",
          ["ctrl-g"] = "switch_and_detach",
          ["ctrl-x"] = "detach",
          ["ctrl-s"] = "spawn",
        },
      },
    })
  end,
}
