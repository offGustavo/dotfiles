return {
  "https://github.com/zenarvus/md-agenda.nvim",
  ft = "markdown",
  keys = {
    { "<leader>aa",      "<Cmd>AgendaView<CR>",      desc = "Md Agenda" },
    { "<localleader>td", "<Cmd>CheckTask<CR>",       silent = true,     ft = "markdown",  desc = "Check Tesk" },
    { "<localleader>tc", "<Cmd>CancelTask<CR>",      silent = true,     ft = "markdown",  desc = "Cancel Tesk" },
    { "<localleader>h",  "<Cmd>HabitView<CR>",       silent = true,     ft = "markdown",  desc = "Habits" },
    { "<localleader>d",  "<Cmd>AgendaDashboard<CR>", silent = true,     ft = "markdown",  desc = "Check Tesk" },
    { "<localleader>is", "<Cmd>TaskScheduled<CR>",   silent = true,     ft = "markdown",  desc = "Check Tesk" },
    { "<localleader>id", "<Cmd>TaskDeadline<CR>",    silent = true,     ft = "markdown",  desc = "Check Tesk" }
  },
  opts = {
    --- REQUIRED ---
    agendaFiles = {
      -- "~/notes/agenda.md", "~/notes/habits.md", -- Single Files
      "~/Notes/", -- Folders
    },
    habit = {
      "~/Notes/habits/",
      "~/Notes/habits/habits.md",
    },

    --- OPTIONAL ---
    -- Number of days to display on one agenda view page. Default: 10
    agendaViewPageItems = 10,
    -- Number of days before the deadline to show a reminder for the task in the agenda view. Default: 30
    remindDeadlineInDays = 30,
    -- Number of days before the scheduled time to show a reminder for the task in the agenda view. Default: 10
    remindScheduledInDays = 10,

    -- Number of past days to show in the habit view. Default: 24
    habitViewPastItems = 24,
    -- Number of future days to show in the habit view. Default: 3
    habitViewFutureItems = 3,

    -- For folding logbook entries. Default: {{{,}}}
    foldmarker = "{{{,}}}",

    -- Custom types that you can use instead of TODO. Default: {}
    -- The plugin will give an error if you use RGB colors (e.g. #ffffff)
    customTodoTypes = { SOMEDAY = "magenta" }, -- A map of custom item type and its color

    -- "vertical" or "horizontal"
    -- Default: "horizontal"
    dashboardSplitOrientation = "vertical",

    dashboard = {
      {
        "All TODO Items", -- Group name
        {
          -- Item types, e.g., {"TODO", "INFO"}. Gets the items that match one of the given types. Ignored if empty.
          type = { "TODO" },

          -- List of tags to filter. Use AND/OR conditions, e.g., {AND = {"tag1", "tag2"}, OR = {"tag1", "tag2"}}. Ignored if empty.
          tags = {},

          -- Both, deadline and scheduled filters can take the same parameters.
          -- "none", "today", "past", "nearFuture", "before-yyyy-mm-dd", "after-yyyy-mm-dd".
          -- Ignored if empty.
          deadline = "today",
          scheduled = "",
        },
        --{...}, Additional filter maps can be added in the same group.
      },
      --{"Other Group", {...}, ...}
      {
        "Aniversários",
        { type = "NIVER" },
        tags = {},
        deadline = "today",
        scheduled = "",
      },
      --...
    },

    -- Optional: Change agenda colors.
    tagColor = "white",
    titleColor = "yellow",

    todoTypeColor = "cyan",
    habitTypeColor = "cyan",
    infoTypeColor = "lightgreen",
    dueTypeColor = "red",
    doneTypeColor = "green",
    cancelledTypeColor = "red",

    completionColor = "lightgreen",
    scheduledTimeColor = "cyan",
    deadlineTimeColor = "red",

    habitScheduledColor = "yellow",
    habitDoneColor = "green",
    habitProgressColor = "lightgreen",
    habitPastScheduledColor = "darkyellow",
    habitFreeTimeColor = "blue",
    habitNotDoneColor = "red",
    habitDeadlineColor = "gray",
  }
}
