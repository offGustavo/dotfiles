return {
  "nvim-mini/mini.move",
  version = "*",
  opts = {
    mappings = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      left = "<C-h>",
      right = "<C-l>",
      down = "<C-j>",
      up = "<C-k>",
    },
    -- Options which control moving behavior
    options = {
      -- Automatically reindent selection during linewise vertical move
      reindent_linewise = true,
    },
  },
}
