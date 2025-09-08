if vim.uv.os_uname().sysname == "Windows_NT" then
  return {}
end

return {
  dir = "~/Projects/MyContent.nvim/",
  opts = {},
}
