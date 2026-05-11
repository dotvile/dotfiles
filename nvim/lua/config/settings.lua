vim.g.mapleader = " "
vim.api.nvim_set_option("clipboard", "unnamed")

vim.filetype.add({
  extension = {
    psql = "sql",
  },
})

local options = vim.o
options.number = true
options.relativenumber = true
options.conceallevel = 2
options.wrap = true
options.linebreak = true
options.breakindent = true
options.colorcolumn = "80"
