return {
  {
    "https://github.com/xheisenbugx/org.nvim",
    lazy = false,
    opts = {
      org_directory = "~/Notes",
      agenda_files = { "~/Notes/**/*.org" },
      default_notes_file = "~/Notes/refile.org",
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        per_filetype = { org = { inherit_defaults = true, "org" } },
        providers = { org = { name = "Org", module = "org.completion.blink" } },
      },
    },
  },
}
