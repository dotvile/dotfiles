return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = function()
    local parsers = {
      "rust",
      "lua",
      "c_sharp",
      "luadoc",
      "javascript",
      "typescript",
      "python",
      "go",
      "markdown",
      "markdown_inline",
      "html",
      "css",
      "json",
      "yaml",
      "bash",
    }
    require("nvim-treesitter").install(parsers)
  end,
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Enable treesitter highlighting for all filetypes with parsers
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    -- Enable treesitter folding
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt.foldenable = false -- Start with folds open
  end,
}
