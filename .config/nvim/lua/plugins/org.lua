-- return {
--   'nvim-orgmode/orgmode',
--   event = 'VeryLazy',
--   enabled = false,
--   ft = { 'org' },
--   config = function()
--     require('orgmode').setup({
--       org_agenda_files = '~/org/**/*',
--       org_default_notes_file = '~/org/refile.org',
--     })
--   end,
-- }

return {
  "xheisenbugx/org.nvim",
  main = "org",
  lazy = false, -- startup cost is tiny: only :Org and a few global keymaps
  opts = {
    org_directory = "~/org",
    agenda_files = { "~/org/**/*.org" },
    default_notes_file = "~/org/refile.org",
  },
}
