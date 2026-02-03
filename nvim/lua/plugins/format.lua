return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    formatters = {
      shfmt = {
        args = { "-i", "2", "-ci", "-bn", "-sr", "-s" },
      },
    },
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      svelte = { "prettier" },
      astro = { "prettier" },
      css = { "prettier" },
      cs = { "csharpier" },
      html = { "prettier" },
      markdown = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      graphql = { "prettier" },
      lua = { "stylua" },
      python = { "isort", "black" },
      sh = { "shfmt" },
      rust = { "rustfmt" },
      go = { "goimports" },
      bash = { "shfmt" },
    },
    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
    },
  },
  keys = {
    {
      "<leader>mp",
      function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        })
      end,
      mode = { "n", "v" },
      desc = "Format file or range",
    },
  },
}
