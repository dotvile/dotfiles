# SQL / TSQL

## What changed

- `sqls` is enabled for `sql` files.
- Tree-sitter now parses `sql`.
- The language server reads `nvim/sqls/config.yml`.
- `vim-dadbod` provides query execution in Neovim, with `DBUI` for saved connections.
- `usql` is the terminal client for interactive database work.

## What you need to do

- Add at least one PostgreSQL or MSSQL connection in `nvim/sqls/config.yml`.
- Keep the file out of secrets management if you use real credentials.
- Prefer a local/dev DB or a read-only connection for day-to-day editing.
- Use `:DBUI` in Neovim and `usql` from the shell.

## Practical note

- This helps with completion, hover, signature help and code actions.
- The backend is chosen by the connection driver, so PostgreSQL gets PostgreSQL-aware completion/introspection.
- For very database-specific tooling, Neovim will still not feel identical to DataGrip/SSMS/Visual Studio.
