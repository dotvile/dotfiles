# .NET en Neovim

## Comandos nuevos

### Proyecto

- `:DotnetRoot` muestra el root .NET detectado.
- `:DotnetRestore` ejecuta `dotnet restore` en la solución o proyecto más cercano.
- `:DotnetBuild` ejecuta `dotnet build`.
- `:DotnetClean` ejecuta `dotnet clean`.

### Tests

- `:DotnetTestNearest` ejecuta el test más cercano.
- `:DotnetTestFile` ejecuta los tests del archivo actual.
- `:DotnetTestDebugNearest` depura el test más cercano.
- `:DotnetTestSummary` abre o cierra el panel de resumen.
- `:DotnetTestOutput` abre o cierra el panel de salida.

### Roslyn

- `:Roslyn target` cambia de solución si hay varias.
- `:Roslyn restart` reinicia el servidor.

### Runsettings

- `:NeotestSelectRunsettingsFile` selecciona un `.runsettings`.
- `:NeotestClearRunsettings` lo limpia.

## Atajos

- `<leader>mr` restore
- `<leader>mb` build
- `<leader>mc` clean
- `<leader>tn` run nearest test
- `<leader>tf` run file tests
- `<leader>td` debug nearest test
- `<leader>ts` toggle test summary
- `<leader>to` toggle test output

## Flujo nuevo

- Abre Neovim desde el root del repo o dentro de la solución.
- Usa `asdf` o `global.json` para fijar el SDK por proyecto.
- `roslyn.nvim` da inlay hints, code lens y mejor completion para C#.
- `csharpier` sigue formateando al guardar.
- `netcoredbg` es el debugger para .NET.
- `neotest-dotnet` se encarga de descubrir y ejecutar tests.
- Tree-sitter ahora incluye `sql` para mejorar TSQL/SQL.
