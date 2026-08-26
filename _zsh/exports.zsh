# --- editor
export EDITOR='nvim'

# --- PATH base (Linux)
export PATH="$HOME/.bin:$PATH"
export PATH="$DOTFILES_DIR/_bin:$PATH"   # helpers del repo (initfmt, initlint)
export PATH="$HOME/.cargo/bin:$PATH"     # rust / cargo
export PATH="$HOME/.local/bin:$PATH"     # binarios de usuario (pipx, etc.)

# Overrides locales no versionados (secretos, URLs de BBDD...).
# Copia `_zsh/local.zsh.example` a `_zsh/local.zsh` y rellena los valores.
if [[ -f "$DOTFILES_DIR/_zsh/local.zsh" ]]; then
  source "$DOTFILES_DIR/_zsh/local.zsh"
fi

# De-dup y helper de PATH
typeset -U path
path_prepend() {
  local i; for (( i=$#; i>=1; i-- )); do
    [[ -d "${@:$i:1}" ]] && path=("${@:$i:1}" $path)
  done
}

# asdf: gestor de runtimes (Node, Python, Go...). Shims/bin primero en el PATH.
export ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"
export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
path_prepend "$ASDF_DATA_DIR/shims" "$ASDF_DIR/bin"

# Herramientas Go instaladas con `go install ...@latest` (GOPATH en ruta XDG, no en ~/go)
export GOPATH="${GOPATH:-$HOME/.local/share/go}"
path_prepend "$GOPATH/bin"

# pnpm. Dos layouts posibles según cómo se instalara:
#   - binario standalone (install_runtimes.sh) -> ejecutable en $PNPM_HOME
#   - script oficial de pnpm.io                -> ejecutables en $PNPM_HOME/bin
# path_prepend ignora las rutas que no existen, así que cubrimos ambos.
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
path_prepend "$PNPM_HOME" "$PNPM_HOME/bin"

# JAVA_HOME desde asdf (solo si java está instalado)
if command -v asdf >/dev/null 2>&1; then
  asdf_java_dir="$(asdf where java 2>/dev/null || true)"
  [[ -n "$asdf_java_dir" ]] && export JAVA_HOME="$asdf_java_dir"
fi
