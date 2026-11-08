return {
  {
    "https://github.com/nvim-orgmode/orgmode",
    lazy = true,
    event = "VeryLazy",
    opts = {
      org_agenda_files = "~/Notes/**/*",
      org_default_notes_file = "~/Notes/notes.org",
    },
  },
  {
    "https://github.com/kristijanhusak/org-lsp",
    lazy = true,
    ft = "org",
    build = ":OrgLspDownload",
    opts = {
      -- The server's options: Org's variables, named with `_`.
      settings = {
        org_agenda_files = { "~/Notes", "~/Notes/**/*.org" },
        org_todo_keywords = { "TODO(t)", "NEXT(n)", "WAIT(w@/!)", "|", "DONE(d!)", "CANCELLED(c@)" },
        org_log_done = "time",
        org_capture_templates = {
          {
            key = "t",
            description = "Task",
            target = { "file+headline", "~/org/inbox.org", "Tasks" },
            template = "* TODO %?\n  %U",
          },
        },
        org_agenda_custom_commands = {
          {
            key = "d",
            description = "Today, then what is waiting",
            blocks = {
              { type = "agenda", settings = { org_agenda_span = "day" } },
              { type = "todo", match = "WAIT", header = "Waiting for" },
            },
          },
        },
      },
      -- The plugin's own.
      win_split_mode = "vsplit",
      calendar_win_mode = "cursor",
    },
  },
}

-- "https://github.com/xheisenbugx/org.nvim",
-- "https://github.com/offGustavo/md-agenda.nvim",

-- Experimental LSP support
-- vim.lsp.enable("org")

-- require("org").setup({
--   org_directory = "~/notes",
--   agenda_files = { "~/notes/**/*.org" },
--   default_notes_file = "~/notes/home.org",
-- })

-- require("md-agenda").setup({
--   --- REQUIRED ---
--   agendaFiles = {
--     -- "~/notes/agenda.md", "~/notes/habits.md", -- Single Files
--     "~/Notes/", -- Folders
--   },
--   habit = {
--     "~/Notes/habits/",
--     "~/Notes/habits/habits.md",
--   },
--
--   --- OPTIONAL ---
--   -- Number of days to display on one agenda view page. Default: 10
--   agendaViewPageItems = 30,
--   -- Number of days before the deadline to show a reminder for the task in the agenda view. Default: 30
--   remindDeadlineInDays = 30,
--   -- Number of days before the scheduled time to show a reminder for the task in the agenda view. Default: 10
--   remindScheduledInDays = 10,
--
--   -- Number of past days to show in the habit view. Default: 24
--   habitViewPastItems = 24,
--   -- Number of future days to show in the habit view. Default: 3
--   habitViewFutureItems = 3,
--
--   -- For folding logbook entries. Default: {{{,}}}
--   foldmarker = "{{{,}}}",
--
--   -- Custom types that you can use instead of TODO. Default: {}
--   -- The plugin will give an error if you use RGB colors (e.g. #ffffff)
--   customTodoTypes = { SOMEDAY = "magenta" }, -- A map of custom item type and its color
--
--   -- "vertical" or "horizontal"
--   -- Default: "horizontal"
--   dashboardSplitOrientation = "vertical",
--
--   dashboard = {
--     {
--       "All TODO Items", -- Group name
--       {
--         -- Item types, e.g., {"TODO", "INFO"}. Gets the items that match one of the given types. Ignored if empty.
--         type = { "TODO" },
--
--         -- List of tags to filter. Use AND/OR conditions, e.g., {AND = {"tag1", "tag2"}, OR = {"tag1", "tag2"}}. Ignored if empty.
--         tags = {},
--
--         -- Both, deadline and scheduled filters can take the same parameters.
--         -- "none", "today", "past", "nearFuture", "before-yyyy-mm-dd", "after-yyyy-mm-dd".
--         -- Ignored if empty.
--         deadline = "today",
--         scheduled = "",
--       },
--       --{...}, Additional filter maps can be added in the same group.
--     },
--     --{"Other Group", {...}, ...}
--     {
--       "Aniversários",
--       { type = "NIVER" },
--       tags = {},
--       deadline = "today",
--       scheduled = "",
--     },
--     --...
--   },
--
--   -- Optional: Change agenda colors.
--   tagColor = "white",
--   titleColor = "yellow",
--
--   todoTypeColor = "cyan",
--   habitTypeColor = "cyan",
--   infoTypeColor = "lightgreen",
--   dueTypeColor = "red",
--   doneTypeColor = "green",
--   cancelledTypeColor = "red",
--
--   completionColor = "lightgreen",
--   scheduledTimeColor = "cyan",
--   deadlineTimeColor = "red",
--
--   habitScheduledColor = "yellow",
--   habitDoneColor = "green",
--   habitProgressColor = "lightgreen",
--   habitPastScheduledColor = "darkyellow",
--   habitFreeTimeColor = "blue",
--   habitNotDoneColor = "red",
--   habitDeadlineColor = "gray",
-- })

-- map {
--   { "<leader>aa", "<Cmd>AgendaView<CR>", desc = "Md Agenda" },
--   -- { "<localleader>td", "<Cmd>CheckTask<CR>", silent = true, ft = "markdown", desc = "Check Tesk" },
--   -- { "<localleader>tc", "<Cmd>CancelTask<CR>", silent = true, ft = "markdown", desc = "Cancel Tesk" },
--   -- { "<localleader>h", "<Cmd>HabitView<CR>", silent = true, ft = "markdown", desc = "Habits" },
--   -- { "<localleader>d", "<Cmd>AgendaDashboard<CR>", silent = true, ft = "markdown", desc = "Check Tesk" },
--   -- { "<localleader>is", "<Cmd>TaskScheduled<CR>", silent = true, ft = "markdown", desc = "Check Tesk" },
--   -- { "<localleader>id", "<Cmd>TaskDeadline<CR>", silent = true, ft = "markdown", desc = "Check Tesk" },
-- }
