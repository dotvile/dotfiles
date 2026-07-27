return {
  {
    "tpope/vim-dadbod",
    cmd = { "DB" },
    lazy = true,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = { "tpope/vim-dadbod" },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_help = 0
      vim.g.db_ui_winwidth = 42
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
      vim.fn.mkdir(vim.g.db_ui_save_location, "p")

      local connections_file = vim.g.db_ui_save_location .. "/connections.json"

      local function migrate_saved_connections()
        if vim.fn.filereadable(connections_file) == 0 then
          return
        end

        local ok_read, lines = pcall(vim.fn.readfile, connections_file)
        if not ok_read then
          return
        end

        local ok_decode, connections = pcall(vim.json.decode, table.concat(lines, "\n"))
        if not ok_decode or type(connections) ~= "table" then
          return
        end

        local changed = false
        for _, connection in ipairs(connections) do
          if type(connection) == "table" and type(connection.url) == "string" and connection.url:match("^jdbc:sqlserver://") then
            connection.url = connection.url:gsub("^jdbc:", "", 1)
            changed = true
          end
        end

        if changed then
          vim.fn.writefile({ vim.json.encode(connections) }, connections_file)
        end
      end

      migrate_saved_connections()

      local function env(name)
        local value = vim.env[name]
        if type(value) == "string" and value ~= "" then
          return value
        end
      end

      local function local_value(name)
        local path = vim.env.HOME .. "/Development/dotfiles/_zsh/local.zsh"
        local file = io.open(path, "r")
        if not file then
          return nil
        end

        for line in file:lines() do
          local value = line:match("^%s*export%s+" .. name .. "%s*=%s*['\"](.-)['\"]%s*$")
          if value then
            file:close()
            return value
          end
        end

        file:close()
        return nil
      end

      local function normalize_url(url)
        if type(url) ~= "string" then
          return nil
        end

        if url:match("^jdbc:sqlserver://") then
          return url:gsub("^jdbc:", "", 1)
        end

        return url
      end

      local dbs = {}

      local postgres = normalize_url(local_value("POSTGRES_URL") or env("POSTGRES_URL") or env("POSTGRESQL_URL") or env("DATABASE_URL_POSTGRES"))
      if postgres then
        table.insert(dbs, { name = "postgres", url = postgres })
      end

      local sqlserver = normalize_url(local_value("SQLSERVER_URL") or env("SQLSERVER_URL") or env("MSSQL_URL") or env("DATABASE_URL_SQLSERVER"))
      if sqlserver then
        table.insert(dbs, { name = "sqlserver", url = sqlserver })
      end

      if #dbs > 0 then
        vim.g.dbs = dbs
      end
    end,
    keys = {
      { "<leader>zb", "<cmd>DBUI<cr>", desc = "Open Dadbod UI" },
    },
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql", "tsql" },
    dependencies = { "tpope/vim-dadbod" },
  },
}
