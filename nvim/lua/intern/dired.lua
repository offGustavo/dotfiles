if is_windows() then
  vim.cmd [[
  packadd netrw
  nmap <M-e> :Ex<CR>
  nmap - :Ex<CR>
  nmap <leader>fd :.<CR>
  ]]
  return {}
  -- }}}
end

vim.g.loaded_netrw = true
vim.g.loaded_nvim_dir_plugin = true

require("offGustavo.dired").setup()

map {
  { "<M-e>", ":DiredJump<Cr>" },
  { "-", ":DiredJump<Cr>" },
  { "<leader>fd", ":Dired<Cr>" },
}
