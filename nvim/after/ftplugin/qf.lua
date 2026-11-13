set_local {
  nu = true,
  rnu = false,
  cursorline = true,
}

-- cmd([[set statusline=%t%{exists('w:quickfix_title')? ' '.w:quickfix_title : ''} %=%-15(%l,%c%V%) %P]])
-- -- TODO: add a build_quickfix_statusline
-- wo.statusline = '%{%(nvim_get_current_win()==#g:actual_curwin || &laststatus==3) ? v:lua.Fish.build_statusline() : v:lua.Fish.build_statusline_inactive()%}'

-- Add the cfilter plugin.
packadd "cfilter"

map {
  { "n", "<C-j>", "<Cmd>cnext<Cr><Cmd>cope<Cr>", buffer = 0 },
  { "n", "<C-k>", "<Cmd>cprev<Cr><Cmd>cope<Cr>", buffer = 0 },
}
