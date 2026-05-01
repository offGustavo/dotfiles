return {
  "https://github.com/monaqa/dial.nvim",
  enabled = false,
  keys = {
    { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end },
    { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end },
    { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end },
    { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end },
    { "<C-a>", function() require("dial.map").manipulate("increment", "visual") end, mode = "x" },
    { "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end, mode = "x" },
    { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = "x" },
    { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = "x" },
  }
}
