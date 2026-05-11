return {
  {
    "nvim-neotest/neotest",
    module = "neotest",
    cmd = {
      "NeotestSelectRunsettingsFile",
      "NeotestClearRunsettings",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "Issafalcon/neotest-dotnet",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-dotnet")({
            discovery_root = "solution",
            dap = {
              adapter_name = "netcoredbg",
            },
          }),
        },
      })
    end,
  },
}
