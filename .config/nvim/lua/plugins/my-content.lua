if vim.uv.os_uname().sysname == "Windows_NT" then
  return {}
end

return {
  dir = "~/Projects/MyContent.nvim/",
  opts = {},
  config = function()
    vim.keymap.set("n", "<leader>omd", function()
      require("MyContent").open()
    end, { desc = "MyContent" })

    vim.g.archivist = {
      dir = "~/Notes/Tracker",
      -- view = "cards",
      -- view = "table",
    }
  end,
}
