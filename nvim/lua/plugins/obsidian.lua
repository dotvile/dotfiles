return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "vileonbuild",
        path = "/Users/victor/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vile",
      },
    },
    notes_subdir = "inbox",
    new_notes_location = "notes_subdir",
    disable_frontmatter = true,
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    mappings = {
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    ui = {
      checkboxes = {},
      bullets = {},
    },
  },
}
