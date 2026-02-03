local function picker_launcher()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values
  local builtin = require("telescope.builtin")
  local extensions = require("telescope").extensions

  local options = {
    { name = "File Browser", picker = extensions.file_browser },
    { name = "Find Files", picker = builtin.find_files },
    { name = "Live Grep", picker = builtin.live_grep },
    { name = "Buffers", picker = builtin.buffers },
    { name = "Treesitter Symbols", picker = builtin.treesitter },
    { name = "LSP References", picker = builtin.lsp_references },
    { name = "LSP Symbols", picker = builtin.lsp_document_symbols },
    { name = "Git Commits", picker = builtin.git_commits },
    { name = "Git Status", picker = builtin.git_status },
  }

  pickers
    .new({}, {
      prompt_title = "Telescope Picker Launcher",
      finder = finders.new_table({
        results = options,
        entry_maker = function(entry)
          return {
            value = entry.picker,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          selection.value()
        end)
        return true
      end,
    })
    :find()
end

local function file_browser_here()
  require("telescope").extensions.file_browser.file_browser({
    path = vim.fn.expand("%:p:h"),
    select_buffer = true,
    hidden = true,
  })
end

local function file_browser_cwd()
  require("telescope").extensions.file_browser.file_browser({
    path = vim.loop.cwd(),
    select_buffer = false,
    hidden = true,
  })
end

local function dropdown_no_preview(picker)
  return function()
    picker(require("telescope.themes").get_dropdown({
      previewer = false,
      winblend = 10,
    }))
  end
end

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "jonarrien/telescope-cmdline.nvim",
    "xiyaowong/telescope-emoji.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          preview_width = 0.5,
          width = 0.95,
          height = 0.95,
        },
      },
      mappings = {
        i = {
          ["<Down>"] = "move_selection_next",
          ["<Up>"] = "move_selection_previous",
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
        },
        n = {
          ["<Down>"] = "move_selection_next",
          ["<Up>"] = "move_selection_previous",
        },
      },
    },
    pickers = {
      find_files = {
        hidden = true,
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        case_mode = "smart_case",
      },
      file_browser = {
        hijack_netrw = true,
        mappings = {
          i = {
            ["<Down>"] = "move_selection_next",
            ["<Up>"] = "move_selection_previous",
          },
          n = {
            ["<Down>"] = "move_selection_next",
            ["<Up>"] = "move_selection_previous",
          },
        },
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("file_browser")
    telescope.load_extension("luasnip")
  end,
  keys = {
    {
      "<leader>tt",
      dropdown_no_preview(function(o)
        require("telescope.builtin").find_files(o)
      end),
      desc = "Find files",
    },
    {
      "<leader>tg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Live grep",
    },
    {
      "<leader>tb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>t?",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Help tags",
    },
    { "<leader>tp", picker_launcher, desc = "Picker launcher" },
    { "<leader>th", file_browser_here, desc = "File browser (here)" },
    { "<leader>tH", file_browser_cwd, desc = "File browser (cwd)" },
    {
      "<leader>gc",
      function()
        require("telescope.builtin").git_commits()
      end,
      desc = "Git commits",
    },
    {
      "<leader>gC",
      function()
        require("telescope.builtin").git_bcommits()
      end,
      desc = "Git buffer commits",
    },
    {
      "<leader>gs",
      function()
        require("telescope.builtin").git_status()
      end,
      desc = "Git status",
    },
    {
      "gr",
      function()
        require("telescope.builtin").lsp_references()
      end,
      desc = "LSP references",
    },
    {
      "gd",
      function()
        require("telescope.builtin").lsp_definitions()
      end,
      desc = "LSP definitions",
    },
    {
      "gi",
      function()
        require("telescope.builtin").lsp_implementations()
      end,
      desc = "LSP implementations",
    },
    {
      "<leader>ts",
      function()
        require("telescope.builtin").treesitter()
      end,
      desc = "Treesitter symbols",
    },
    {
      "<leader>*",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "Grep word under cursor",
    },
  },
}
