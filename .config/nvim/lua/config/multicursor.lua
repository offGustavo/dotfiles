map {
  { { "n", "x" }, "<M-q>", "Q" },
  { "<C-D>", ":g/<cword>/normal! Q<Cr>" },
  { "<C-m>", "q=" },
  { "<C-K>", ":norm! Qk<Cr>" },
  { "<C-J>", ":norm! Qj<Cr>" },
  -- TODO: fix this
  { "<C-p>", "#" },
  { "<C-n>", "*" },
  -- { "<C-;>", function ()
  { "<C-,>", ":normal! Q#<Cr>" },
  { "<C-.>", ":normal! Q*<Cr>" },
  --   print"oi"
  -- end, mode = "x" },
  -- { "<C-;>", "<Cmd>MultipleCursorsAddMatchesV<Cr>" },
}
