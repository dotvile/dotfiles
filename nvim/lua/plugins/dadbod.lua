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
      vim.g.db_ui_win_position = "right"
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
      vim.fn.mkdir(vim.g.db_ui_save_location, "p")

      local function env(name)
        local value = vim.env[name]
        if type(value) == "string" and value ~= "" then
          return value
        end
      end

      local dbs = {}

      local postgres = env("POSTGRES_URL") or env("POSTGRESQL_URL") or env("DATABASE_URL_POSTGRES")
      if postgres then
        table.insert(dbs, { name = "postgres", url = postgres })
      end

      local sqlserver = env("SQLSERVER_URL") or env("MSSQL_URL") or env("DATABASE_URL_SQLSERVER")
      if sqlserver then
        table.insert(dbs, { name = "sqlserver", url = sqlserver })
      end

      if #dbs > 0 then
        vim.g.dbs = dbs
      end
    end,
    keys = {
      { "<leader>db", "<cmd>DBUI<cr>", desc = "Open Dadbod UI" },
    },
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql", "tsql" },
    dependencies = { "tpope/vim-dadbod" },
  },
}
