-- Track installation state globally
vim.g.mason_installing = false

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    priority = 100,
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "astro",
        "pyright",
        "rust_analyzer",
        "lua_ls",
        "yamlls",
        "gopls",
        "ts_ls",
      },
      automatic_installation = true,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        -- Formatters
        "prettier",
        "stylua",
        "isort",
        "black",
        "shfmt",
        "goimports",
        "csharpier",

        -- Linters
        "eslint_d",
        "jsonlint",
        "golangci-lint",
        "pylint",

        -- DAP
        "debugpy",
        "delve",
        "js-debug-adapter",
        "netcoredbg",
      },
      auto_update = false,
      run_on_start = true,
    },
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsStartingInstall",
        callback = function()
          vim.g.mason_installing = true
          vim.notify("Mason: Installing tools... Do not exit Neovim.", vim.log.levels.WARN)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsUpdateCompleted",
        callback = function()
          vim.g.mason_installing = false
          vim.notify("Mason: All tools installed!", vim.log.levels.INFO)
        end,
      })

      -- Confirm before exit while installing
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          if vim.g.mason_installing then
            local choice = vim.fn.confirm("Mason is still installing tools. Exit anyway?", "&Wait\n&Exit", 1)
            if choice == 1 then
              -- User chose to wait, abort exit
              error("Installation in progress")
            end
          end
        end,
      })
    end,
  },
}
