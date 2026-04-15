return {
  "zenarvus/md-agenda.nvim",
  -- dir = "~/Projects/md-agenda.nvim/",
  -- lazy = true,
  -- ft = { "markdown", "md" },
  config = function()
    require("md-agenda").setup({
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
    })

    vim.keymap.set("n", "<leader>a", "<Cmd>AgendaView<CR>", { silent = true, desc = "Md Agenda" })

    local notes_dir = vim.fn.expand("~/Notes")

    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      callback = function(args)
        local buf = args.buf
        local file = vim.api.nvim_buf_get_name(buf)

        -- Ensure the file is inside ~/Notes
        if not vim.startswith(file, notes_dir) then
          return
        end

        vim.keymap.set("n", "<Cr>", "<Cmd>CheckTask<CR>", { silent = true, buffer = buf, desc = "Check Tesk" })
        vim.keymap.set(
          "n",
          "<localleader>c",
          "<Cmd>CancelTask<CR>",
          { silent = true, buffer = buf, desc = "Cancel Tesk" }
        )
        vim.keymap.set("n", "<localleader>h", "<Cmd>HabitView<CR>", { silent = true, buffer = buf, desc = "Habits" })
        vim.keymap.set(
          "n",
          "<localleader>D",
          "<Cmd>AgendaDashboard<CR>",
          { silent = true, buffer = buf, desc = "Check Tesk" }
        )
        vim.keymap.set(
          "n",
          "<localleader>s",
          "<Cmd>TaskScheduled<CR>",
          { silent = true, buffer = buf, desc = "Check Tesk" }
        )
        vim.keymap.set(
          "n",
          "<localleader>d",
          "<Cmd>TaskDeadline<CR>",
          { silent = true, buffer = buf, desc = "Check Tesk" }
        )
      end,
    })

    -- -- Optional: Create a custom agenda view command to only show the tasks with specific tags
    -- vim.api.nvim_create_user_command("WorkAgenda", function()
    --   vim.cmd("AgendaViewWTF work companyA") -- Run the agenda view with tag filters
    -- end, {})
  end,
}
