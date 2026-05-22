function Fish.is_windows()
  local value = vim.fn.has("win64")
  if value == 1 then
    return true
  end
  return false
end
