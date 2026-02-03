local function get_pylint_cmd()
  local venv_pylint = vim.fn.getcwd() .. "/.venv/bin/pylint"
  if vim.fn.executable(venv_pylint) == 1 then
    return venv_pylint
  end
  return "pylint"
end

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      html = { "eslint_d" },
      css = { "eslint_d" },
      typescript = { "eslint_d" },
      javascript = { "eslint_d" },
      json = { "jsonlint" },
      go = { "golangcilint" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      python = { "pylint" },
    }

    lint.linters.pylint.cmd = get_pylint_cmd()

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("lint", { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
  keys = {
    {
      "<leader>l<leader>",
      function()
        require("lint").try_lint()
      end,
      desc = "Trigger linting",
    },
  },
}
