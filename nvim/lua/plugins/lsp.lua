-- LSP Keymaps (applied on LspAttach)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, silent = true }
    local map = vim.keymap.set
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    map("n", "gD", vim.lsp.buf.declaration, opts)
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "gi", vim.lsp.buf.implementation, opts)
    map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    map("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
    map("n", "<leader>e", vim.diagnostic.open_float, opts)
    map("n", "<leader>q", vim.diagnostic.setloclist, opts)

    if client and client.name == "roslyn" then
      pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })

      local group = vim.api.nvim_create_augroup("roslyn-codelens-" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = group,
        buffer = bufnr,
        callback = function()
          pcall(vim.lsp.codelens.refresh)
        end,
      })

      pcall(vim.lsp.codelens.refresh)
    end
  end,
})

-- LSP Server configurations using Neovim 0.11 native API
vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
    },
  },
})

vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "uv.lock", "setup.py", "requirements.txt", ".git" },
})

vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = true,
      check = { command = "clippy" },
    },
  },
})

vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
})

vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
    },
  },
})

vim.lsp.config("yamlls", {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose" },
  root_markers = { ".git" },
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
})

vim.lsp.config("astro", {
  cmd = { "astro-ls", "--stdio" },
  filetypes = { "astro" },
  root_markers = { "package.json", "tsconfig.json", ".git" },
})

vim.lsp.config("sqls", {
  cmd = { "sqls", "-config", vim.fn.stdpath("config") .. "/sqls/config.yml" },
  filetypes = { "sql" },
  root_markers = { ".git", "sqls.yml", "sqls.yaml" },
})

vim.lsp.config("roslyn", {
  capabilities = (function()
    local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
      return cmp_lsp.default_capabilities()
    end
    return vim.lsp.protocol.make_client_capabilities()
  end)(),
  settings = {
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostics_scope = "fullSolution",
      dotnet_compiler_diagnostics_scope = "fullSolution",
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
      dotnet_enable_tests_code_lens = true,
    },
    ["csharp|completion"] = {
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_show_name_completion_suggestions = true,
      dotnet_provide_regex_completions = true,
    },
    ["csharp|formatting"] = {
      dotnet_organize_imports_on_format = true,
    },
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
      csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      csharp_enable_inlay_hints_for_types = true,
      dotnet_enable_inlay_hints_for_indexer_parameters = true,
      dotnet_enable_inlay_hints_for_literal_parameters = true,
      dotnet_enable_inlay_hints_for_object_creation_parameters = true,
      dotnet_enable_inlay_hints_for_other_parameters = true,
      dotnet_enable_inlay_hints_for_parameters = true,
    },
    ["csharp|symbol_search"] = {
      dotnet_search_reference_assemblies = true,
    },
  },
})

-- Enable all configured LSP servers
vim.lsp.enable({
  "lua_ls",
  "pyright",
  "rust_analyzer",
  "ts_ls",
  "gopls",
  "yamlls",
  "astro",
  "roslyn",
  "sqls",
})

-- Plugin spec for dependencies only
return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = false,
  },
}
