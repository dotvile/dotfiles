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
    disable_frontmatter = false,
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      template = "daily",
    },
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
  config = function(_, opts)
    require("obsidian").setup(opts)

    local vault_root = "/Users/victor/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vile"
    local group = vim.api.nvim_create_augroup("obsidian_second_brain", { clear = true })

    local function update_updated_field(bufnr)
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      if lines[1] ~= "---" then
        return
      end

      for i = 2, #lines do
        if lines[i] == "---" then
          break
        end
        if lines[i]:match("^updated:%s*") then
          lines[i] = "updated: " .. os.date("%Y-%m-%d")
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
          return
        end
      end
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = group,
      pattern = "*.md",
      callback = function(args)
        local path = vim.api.nvim_buf_get_name(args.buf)
        if path:sub(1, #vault_root) ~= vault_root then
          return
        end

        update_updated_field(args.buf)
      end,
    })
  end,
}
