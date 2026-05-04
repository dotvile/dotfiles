# Workflow de Obsidian

## Vision general

Esta configuracion anade un pequeno CLI llamado `ob` para gestionar un second brain minimalista en Obsidian.

Carpetas principales del vault:

- `inbox/`
- `notes/`
- `maps/`
- `daily/`
- `templates/`

## Filosofia del flujo

Este sistema separa el trabajo en 5 tipos de nota:

- `daily`: registro diario de vida personal.
- `study-session`: nota temporal para una sesion concreta de estudio.
- `concept-note`: nota reutilizable sobre una idea importante.
- `source-note`: nota sobre una fuente concreta.
- `moc`: mapa de contenido para navegar un tema.

La idea general es esta:

1. Capturas rapido.
2. Estudias en una nota de sesion.
3. Destilas las ideas valiosas en notas conceptuales.
4. Indexas solo lo importante en MOCs.
5. Mantienes un registro diario de tu vida en `daily/`.

## Cuando usar cada tipo de nota

### `daily`

Usa una nota `daily` para registrar tu dia.

Aqui van cosas como:

- medidas corporales
- entrenamiento
- alimentacion
- descanso
- habitos y disciplina diaria
- actividades del dia
- agradecimientos
- oracion
- plan para manana

Una `daily` no sustituye notas tecnicas. Sirve como bitacora de vida.

### `study-session`

Usa una `study-session` cuando vayas a pasar un bloque real de tiempo estudiando algo.

Ejemplos:

- una tarde estudiando Go
- una sesion sobre Neovim
- una lectura tecnica de una documentacion o curso

Aqui escribes:

- apuntes en bruto
- dudas
- snippets
- ejemplos
- conclusiones provisionales

No hace falta que quede perfecta.

### `concept-note`

Usa una `concept-note` cuando una idea merezca vivir por si sola.

Crea una nota conceptual si la idea:

- la vas a reutilizar
- la quieres enlazar desde varios sitios
- tiene entidad propia
- puede crecer con ejemplos o matices

Ejemplos:

- `Go - Goroutines`
- `Go - Channels`
- `Zsh - PATH`
- `Neovim - LSP nativo`

### `source-note`

Usa una `source-note` para una fuente concreta:

- libro
- curso
- video
- articulo
- documentacion

Ejemplos:

- `Source - Tour of Go`
- `Source - Effective Go`

### `moc`

Un `moc` es un mapa de contenido.

No es una enciclopedia ni un archivo gigante.
Es una nota indice que agrupa enlaces importantes de un tema.

Ejemplo:

- `Go`
- `Neovim`
- `Zsh`

## Templates

Los templates viven en:

- `~/Development/dotfiles/_templates/obsidian/`

Y se sincronizan al vault con:

```bash
initobs
```

Templates disponibles:

- `default`
- `study-session`
- `concept-note`
- `source-note`
- `daily`

## Referencia de comandos

### `ob new`

Crea una nota a partir de un template y la abre en tu editor.

```bash
ob new default "Captura rapida"
ob new study-session "Go concurrencia" --topic go,concurrency --source "Tour of Go"
ob new concept-note "Go - Goroutines" --topic go,concurrency --mocs go
ob new source-note "Source - Tour of Go" --topic go --source "https://go.dev/tour/"
```

Opciones:

- `--topic go,concurrency`: rellena la propiedad `topic`
- `--source "..."`: rellena la propiedad `source`
- `--mocs go,concurrency`: rellena la propiedad `mocs`
- `--no-open`: crea la nota sin abrirla
- `--print-path`: imprime la ruta creada
- `--sync-mocs`: reconstruye los MOCs despues de crear la nota

### `ob today`

Abre o crea la nota diaria de hoy.

```bash
ob today
ob today --print-path
```

Las notas diarias se guardan en `daily/` y usan el template `daily`.

### `ob touch-updated`

Actualiza el campo `updated` del frontmatter.

```bash
ob touch-updated path/to/note.md
```

Normalmente no necesitas lanzarlo a mano porque Neovim ya actualiza `updated` al guardar notas Markdown dentro del vault.

### `ob classify`

Mueve una nota a la carpeta correcta segun su `type`.

```bash
ob classify path/to/note.md
ob classify path/to/note.md --sync-mocs
```

Reglas actuales:

- `daily` -> `daily/`
- `concept` -> `notes/`
- `source` -> `notes/`
- `study-session` -> `notes/`
- `moc` -> `maps/`
- cualquier otro tipo -> `inbox/`

### `ob sync-mocs`

Reconstruye todos los MOCs a partir de las notas que tengan `mocs`.

```bash
ob sync-mocs
```

Ejemplo de metadata:

```yaml
---
type: concept
topic: [go, concurrency]
mocs: [go]
created: 2026-03-29
updated: 2026-03-29
---
```

Este comando genera o actualiza archivos en `maps/`.

### `ob recent`

Lista las 10 notas modificadas mas recientemente.

```bash
ob recent
```

## Aliases de shell

Aliases disponibles:

- `initobs`: sincroniza templates desde dotfiles al vault
- `obd`: abre la nota diaria de hoy
- `obs`: crea una `study-session`
- `obc`: crea una `concept-note`
- `obso`: crea una `source-note`
- `obm`: reconstruye los MOCs

## Keymaps de Neovim

Atajos disponibles:

- `<leader>oo`: ir a la raiz del vault
- `<leader>od`: abrir la nota diaria de hoy
- `<leader>oc`: crear una nota conceptual
- `<leader>os`: crear una sesion de estudio
- `<leader>of`: crear una nota de fuente
- `<leader>ox`: clasificar la nota actual y reabrirla en su nueva ruta
- `<leader>om`: reconstruir todos los MOCs

## Workflow recomendado

### Registro diario

Cada dia:

```bash
ob today
```

Rellena:

- medidas
- entrenamiento
- alimentacion
- descanso
- habitos
- resumen del dia
- agradecimientos
- oracion
- plan para manana

El template diario esta organizado en estos bloques:

- `Metrics`: peso, cintura, horas de sueno, energia y estado de animo
- `Training`: sesion, duracion, intensidad y notas
- `Nutrition`: comidas, agua y observaciones
- `Rest And Recovery`: horarios y recuperacion
- `Day Summary`: actividades, victorias, retos y aprendizajes
- `Study And Learning`: que estudiaste y que notas nacieron
- `Gratitude`, `Prayer`, `Tomorrow`

### Sesion de estudio

Si vas a estudiar Go, por ejemplo:

```bash
ob new study-session "Go concurrencia" --topic go,concurrency --source "Tour of Go"
```

Durante la sesion:

- escribe todo en bruto en esa nota
- no intentes organizarlo todo perfecto desde el inicio
- apunta dudas, ejemplos y relaciones

### Destilado de conceptos

Cuando una idea se vuelva importante, conviertela en nota propia:

```bash
ob new concept-note "Go - Goroutines" --topic go,concurrency --mocs go
ob new concept-note "Go - Channels" --topic go,concurrency --mocs go
ob new concept-note "Go - Context" --topic go,concurrency --mocs go
```

Esto permite enlazar ideas entre si y navegar mejor por el vault.

### Clasificacion al terminar

Cuando termines una sesion:

```bash
ob classify path/to/session.md --sync-mocs
```

Asi:

- la nota pasa a su carpeta correcta
- los MOCs se actualizan

## Ejemplo real con Go

Flujo recomendado:

1. Crear una sesion:

```bash
ob new study-session "Go concurrencia" --topic go,concurrency --source "Tour of Go"
```

2. Tomar notas en bruto en esa sesion:

- que es una goroutine
- que es un channel
- diferencia entre buffered y unbuffered
- cuando usar `context`

3. Extraer conceptos importantes:

```bash
ob new concept-note "Go - Goroutines" --topic go,concurrency --mocs go
ob new concept-note "Go - Channels" --topic go,concurrency --mocs go
ob new concept-note "Go - Context" --topic go,concurrency --mocs go
```

4. Reconstruir el MOC:

```bash
ob sync-mocs
```

## Convencion de metadata

Campos utiles casi siempre:

- `type`
- `topic`
- `created`
- `updated`

Campos opcionales:

- `mocs`
- `source`
- `tags`

Tags recomendados:

- `type/...`
- `status/...`

## Regla importante

No metas todo en un unico archivo gigante.

Usa esta separacion:

- `daily` para tu vida y seguimiento personal
- `study-session` para estudio en bruto
- `concept-note` para conocimiento reutilizable
- `source-note` para fuentes
- `moc` para navegacion

## Archivos importantes de esta configuracion

- `~/Development/dotfiles/_bin/ob`
- `~/Development/dotfiles/_bin/helpers/init_obsidian_templates.sh`
- `~/Development/dotfiles/_templates/obsidian/`
- `~/Development/dotfiles/nvim/lua/plugins/obsidian.lua`
- `~/Development/dotfiles/nvim/lua/config/keymaps.lua`
- `~/Development/dotfiles/_zsh/aliases.zsh`
- `~/Development/dotfiles/_zsh/exports.zsh`
