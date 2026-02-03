local function find_launcher_jar(jdtls_path)
  local launchers = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true, true)
  if #launchers > 0 then
    table.sort(launchers)
    return launchers[#launchers]
  end
  return nil
end

return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  config = function()
    local jdtls = require("jdtls")
    local home = os.getenv("HOME")
    local jdtls_path = home .. "/.cache/jdtls"
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_folder = home .. "/.cache/jdtls/workspace/" .. project_name

    local launcher_jar = find_launcher_jar(jdtls_path)
    if not launcher_jar then
      vim.notify("JDTLS launcher jar not found", vim.log.levels.ERROR)
      return
    end

    local config = {
      cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        launcher_jar,
        "-configuration",
        jdtls_path .. "/config_mac_arm",
        "-data",
        workspace_folder,
      },
      root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
      settings = {
        java = {
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
        },
      },
      init_options = {
        bundles = {},
      },
    }

    jdtls.start_or_attach(config)
  end,
}
