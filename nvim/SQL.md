# SQL / TSQL

## What changed

- `sqls` is enabled for `sql` files.
- Tree-sitter now parses `sql`.
- The language server reads `nvim/sqls/config.yml`.

## What you need to do

- Add at least one PostgreSQL or MSSQL connection in `nvim/sqls/config.yml`.
- Keep the file out of secrets management if you use real credentials.
- Prefer a local/dev DB or a read-only connection for day-to-day editing.

## Practical note

- This helps with completion, hover, signature help and code actions.
- The backend is chosen by the connection driver, so PostgreSQL gets PostgreSQL-aware completion/introspection.
- For very database-specific tooling, Neovim will still not feel identical to DataGrip/SSMS/Visual Studio.
