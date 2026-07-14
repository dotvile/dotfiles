local function setup_adapters(dap)
  local mason_path = vim.fn.stdpath("data") .. "/mason"

  -- Python
  local mason_python = mason_path .. "/packages/debugpy/venv/bin/python"
  dap.adapters.python = {
    type = "executable",
    command = vim.fn.executable(mason_python) == 1 and mason_python or "python",
    args = { "-m", "debugpy.adapter" },
  }

  -- Go (Delve)
  local mason_dlv = mason_path .. "/bin/dlv"
  local dlv_cmd = vim.fn.executable(mason_dlv) == 1 and mason_dlv or "dlv"
  dap.adapters.go = {
    type = "server",
    port = "${port}",
    executable = {
      command = dlv_cmd,
      args = { "dap", "-l", "127.0.0.1:${port}" },
    },
  }

  -- JavaScript/TypeScript
  local js_debug_path = mason_path .. "/packages/js-debug-adapter"
  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
    },
  }
end

local function setup_configurations(dap)
  -- Python
  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Launch current file",
      program = "${file}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      justMyCode = true,
    },
    {
      type = "python",
      request = "attach",
      name = "Attach to process",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
  }

  -- Go
  dap.configurations.go = {
    {
      type = "go",
      name = "Debug file",
      request = "launch",
      program = "${file}",
    },
    {
      type = "go",
      name = "Debug package",
      request = "launch",
      program = "${fileDirname}",
    },
    {
      type = "go",
      name = "Attach to process",
      request = "attach",
      processId = require("dap.utils").pick_process,
      mode = "local",
    },
  }

  -- JavaScript/TypeScript
  dap.configurations.javascript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch current file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
  }
  dap.configurations.typescript = dap.configurations.javascript
end

local function setup_ui(dap)
  local has_ui, dapui = pcall(require, "dapui")
  if not has_ui then
    return
  end

  dapui.setup()

  dap.listeners.after.event_initialized["dapui_auto_open"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_auto_close"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_auto_close"] = function()
    dapui.close()
  end

  vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP UI Toggle" })
end

local function setup_signs()
  vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticWarn", numhl = "" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint", numhl = "" })
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      setup_adapters(dap)
      setup_configurations(dap)
      setup_ui(dap)
      setup_signs()
    end,
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "DAP Continue/Start" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP Step Out" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "DAP REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "DAP Run Last" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "DAP Terminate" },
      { "<leader>dP", function() require("dap").pause() end, desc = "DAP Pause" },
      { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
      { "<leader>B", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "DAP Conditional Breakpoint" },
      { "<leader>db", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point: ")) end, desc = "DAP Log Point" },
      { "<leader>dC", function() require("dap").clear_breakpoints() end, desc = "DAP Clear Breakpoints" },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = { "js-debug-adapter", "debugpy", "delve" },
    },
  },
}
