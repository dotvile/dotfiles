return {
  "jiaoshijie/undotree",
  dependencies = "nvim-lua/plenary.nvim",
  opts = {
    float_diff = true, -- using float window previews diff, set this `true` will disable layout option
    layout = "left_bottom", -- "left_bottom", "left_left_bottom"
    position = "left", -- "right", "bottom"
    ignore_filetype = { "undotree", "undotreeDiff", "qf", "TelescopePrompt", "spectre_panel", "tsplayground" },
    window = {
      winblend = 30,
    },
    keymaps = {
      ["t"] = "move_next",
      ["n"] = "move_prev",
      ["gt"] = "move2parent",
      ["T"] = "move_change_next",
      ["N"] = "move_change_prev",
      ["<cr>"] = "action_enter",
      ["p"] = "enter_diffbuf",
      ["q"] = "quit",
    },
  },
  keys = { -- load the plugin only when using it's keybinding:
    { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
  },
}
