local vault = require("config.vault")

return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  -- Sin vault en esta máquina el plugin ni se carga: su setup() aborta al no
  -- poder resolver el workspace, y eso rompía la apertura de cualquier .md.
  cond = function()
    return vault.root() ~= nil
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = function()
    return {
      workspaces = {
        {
          name = "vileonbuild",
          path = vault.root(),
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
    }
  end,
  config = function(_, opts)
    require("obsidian").setup(opts)

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
        if not vault.contains(vim.api.nvim_buf_get_name(args.buf)) then
          return
        end

        update_updated_field(args.buf)
      end,
    })
  end,
}
