map {
  { "n", "<localleader>ie", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>" },
  { "n", "<localleader>ia", 'oassert.NoError(err, "")<Esc>F";a' },
  { "n", "<localleader>if", 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj' },
  { "n", "<localleader>il", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i' },
}
