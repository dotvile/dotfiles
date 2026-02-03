return {
  "tpope/vim-fugitive",
  cmd = { "G", "Git" },
  keys = {
    { "<leader>gf<leader>", ":Git fetch --all -p<cr>", desc = "Git fetch" },
    { "<leader>g<leader>", ":Git <cr>", desc = "Open fugitive" },
    { "<leader>gl<leader>", ":Git pull<cr>", desc = "Git pull" },
    { "<leader>gaa<leader>", ":Git add --all<cr>", desc = "Git add" },
    { "<leader>gp<leader>", ":Git push<cr>", desc = "Git push" },
  },
}
