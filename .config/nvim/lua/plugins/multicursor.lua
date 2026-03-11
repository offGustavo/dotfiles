-- vim.cmd([[
-- let g:mc = "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>"
--
-- nnoremap cn *``cgn
-- nnoremap cN *``cgN
--
-- vnoremap <expr> cn g:mc . "``cgn"
-- vnoremap <expr> cN g:mc . "``cgN"
--
-- function! SetupCR()
--   nnoremap <Enter> :nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z
-- endfunction
--
-- nnoremap cq :call SetupCR()<CR>*``qz
-- nnoremap cQ :call SetupCR()<CR>#``qz
--
-- vnoremap <expr> cq ":\<C-u>call SetupCR()\<CR>" . "gv" . g:mc . "``qz"
-- vnoremap <expr> cQ ":\<C-u>call SetupCR()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz"
-- ]])
return {
	"brenton-leighton/multiple-cursors.nvim",
	version = "*", -- Use the latest tagged version
  lazy = true,
  enabled = true,
	opts = {
		pre_hook = function()
			vim.g.minipairs_disable = true
		end,
		post_hook = function()
			vim.g.minipairs_disable = false
		end,
	}, -- This causes the plugin setup function to be called
	keys = {
		{
			"<C-m>",
			"<Cmd>MultipleCursorsLock<CR>",
			mode = { "n", "x" },
			desc = "Lock virtual cursors",
		},
		{
			"<C-S-k>",
			"<Cmd>MultipleCursorsAddUp<CR>",
			mode = { "n", "i", "x" },
			desc = "Add cursor and move up",
		},
		{
			"<C-S-j>",
			"<Cmd>MultipleCursorsAddDown<CR>",
			mode = { "n", "i", "x" },
			desc = "Add cursor and move down",
		},
		{
			"<C-S-m>",
			"<Cmd>MultipleCursorsMouseAddDelete<CR>",
			mode = { "n", "i" },
			desc = "Add or remove cursor",
		},
		{
			"<C-LeftMouse>",
			"<Cmd>MultipleCursorsMouseAddDelete<CR>",
			mode = { "n", "i" },
			desc = "Add or remove cursor",
		},
		{
			"<C-;>",
			"<Cmd>MultipleCursorsAddVisualArea<CR>",
			mode = { "x" },
			desc = "Add cursors to the lines of the visual area",
		},
		{
			"<C-;>",
			"<Cmd>MultipleCursorsAddMatchesV<CR>",
			mode = { "n" },
			desc = "Add cursors to cword in previous area",
		},
		{ "<C-S-d>", "<Cmd>MultipleCursorsAddMatches<CR>", mode = { "n", "x" }, desc = "Add cursors to cword" },
		{
			"<C-.>",
			"<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
			mode = { "n", "x" },
			desc = "Add cursor and jump to next cword",
		},
		{ "<C-n>", "<Cmd>MultipleCursorsJumpNextMatch<CR>", mode = { "n", "x" }, desc = "Jump to previous cword" },
		{
			"<C-,>",
			"<Cmd>MultipleCursorsAddJumpPrevMatch<CR>",
			mode = { "n", "x" },
			desc = "Add cursor and jump to next cword",
		},

		{ "<C-p>", "<Cmd>MultipleCursorsJumpPrevMatch<CR>", mode = { "n", "x" }, desc = "Jump to previous cword" },
	},
}
