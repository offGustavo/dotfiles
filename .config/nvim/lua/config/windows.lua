function _G.Fish.is_windows() 
  if vim.fn.has('win64') or vim.fn.has('win32') then
    return true
  end
  return false
end
