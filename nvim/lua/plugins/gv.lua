return {
  "junegunn/gv.vim",
  dependencies = { "tpope/vim-fugitive" }, -- se asegura de que fugitive esté disponible
  cmd = { "GV" },
  keys = {
    { "<leader>gg", "<cmd>GV<CR>", desc = "Ver gráfico de commits" },
  },
}
