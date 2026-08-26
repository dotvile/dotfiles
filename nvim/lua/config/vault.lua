-- Resolución de la ruta del vault de Obsidian.
--
-- Estos dotfiles se comparten entre máquinas (macOS con el vault en iCloud, y
-- el servidor Linux sin vault), así que la ruta no puede estar fijada en el
-- código: se resuelve al arrancar y puede no existir. Todo lo que dependa del
-- vault debe consultar `root()` y degradar limpiamente si devuelve nil.
--
-- Prioridad: $OBSIDIAN_VAULT (defínelo en _zsh/local.zsh) > rutas conocidas.

local M = {}

-- Expande solo un `~` inicial. No usamos vim.fn.expand() porque la ruta de
-- iCloud contiene `~` intercalados (iCloud~md~obsidian) que se corromperían.
local function expand_home(path)
  if path:sub(1, 1) == "~" then
    return (vim.env.HOME or "") .. path:sub(2)
  end
  return path
end

local candidates = {
  "/Users/victor/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vile",
  "~/Obsidian/Vile",
  "~/obsidian",
  "~/vault",
}

local resolved
local resolved_done = false

local function resolve()
  local paths = { vim.env.OBSIDIAN_VAULT }
  for _, candidate in ipairs(candidates) do
    table.insert(paths, candidate)
  end

  for _, path in ipairs(paths) do
    if type(path) == "string" and path ~= "" then
      local dir = expand_home(path):gsub("/+$", "")
      if vim.fn.isdirectory(dir) == 1 then
        return dir
      end
    end
  end
end

--- Ruta del vault, o nil si esta máquina no tiene ninguno.
function M.root()
  if not resolved_done then
    resolved = resolve()
    resolved_done = true
  end
  return resolved
end

--- Igual que root(), pero avisa al usuario cuando no hay vault.
--- Pensado para keymaps: devuelve nil y el llamante aborta.
function M.require_root()
  local root = M.root()
  if not root then
    vim.notify("No hay vault de Obsidian en esta máquina (define $OBSIDIAN_VAULT)", vim.log.levels.WARN)
  end
  return root
end

--- ¿El fichero dado está dentro del vault?
function M.contains(path)
  local root = M.root()
  if not root or path == "" then
    return false
  end
  return path:sub(1, #root + 1) == root .. "/"
end

return M
