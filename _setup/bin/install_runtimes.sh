#!/usr/bin/env bash
set -Eeuo pipefail

log() { printf '%b\n' "$*"; }
warn() { log "⚠️  $*"; }
err() { log "❌ $*"; }

ensure_asdf() {
  # asdf >= 0.16 es un binario (sin asdf.sh que "sourcear"). Basta con tenerlo en PATH.
  if ! command -v asdf > /dev/null 2>&1; then
    export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
    export PATH="$HOME/.asdf/bin:$ASDF_DATA_DIR/shims:$PATH"
  fi
  command -v asdf > /dev/null 2>&1 || {
    err "asdf no disponible (instálalo antes con bootstrap_prereqs)"
    exit 1
  }
}

cleanup_bogus_installs() {
  for t in nodejs python golang; do
    local d="$HOME/.asdf/installs/$t"
    [[ -d $d ]] || continue
    find "$d" -maxdepth 1 -type d -name 'No compatible versions*' -exec rm -rf {} + 2> /dev/null || true
  done
}

plugin_add_or_update() {
  local name="$1" repo="$2"
  if asdf plugin list | grep -qxF "$name"; then
    asdf plugin update "$name" || warn "plugin update $name falló"
  else
    asdf plugin add "$name" "$repo" 2> /dev/null \
      || asdf plugin add "$name" 2> /dev/null \
      || {
        warn "no pude añadir plugin $name"
        return 1
      }
  fi
}

# Resuelve una "última" versión estable incluso si `asdf latest` falla
resolve_latest() {
  # resolve_latest <tool> [selector]
  local tool="$1" sel="${2:-latest}" v=""
  v="$(asdf latest "$tool" "$sel" 2> /dev/null || true)"
  if [[ -z $v || $v == No\ compatible* ]]; then
    case "$tool" in
      python | nodejs | golang)
        # filtra solo números x.y[.z]
        v="$(asdf list all "$tool" 2> /dev/null \
          | grep -E '^[0-9]+(\.[0-9]+){1,2}([+].*)?$' \
          | tail -n1 | tr -d '[:space:]' || true)"
        ;;
      *)
        v="$(asdf list all "$tool" 2> /dev/null | tail -n1 | tr -d '[:space:]' || true)"
        ;;
    esac
  fi
  printf '%s' "$v"
}

install_and_set_user() {
  # install_and_set_user <tool> <version>
  local tool="$1" ver="$2"
  if [[ -z $ver ]]; then
    warn "no pude resolver versión para $tool; lo salto"
    return 0
  fi
  log "⏬ asdf install $tool $ver"
  if ! asdf install "$tool" "$ver"; then
    warn "asdf install $tool $ver falló; continúo"
    return 0
  fi
  # asdf >= 0.16: sustituto de `global`
  log "🏠 asdf set -u $tool $ver"
  asdf set -u "$tool" "$ver" || warn "asdf set -u $tool $ver falló; continúo"
  asdf reshim "$tool" "$ver" || true
}

install_rust() {
  # Rust vía rustup (nativo arm64/amd64, sin asdf). PATH real: ~/.cargo/bin
  log "==> Rust (rustup)"
  if command -v rustup > /dev/null 2>&1; then
    rustup update stable || warn "rustup update falló; continúo"
  elif command -v cargo > /dev/null 2>&1; then
    log "cargo ya presente (rust instalado sin rustup); no toco nada."
  else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
      | sh -s -- -y --default-toolchain stable --profile default \
      || { warn "instalación de rustup falló; continúo"; return 0; }
  fi
  # Disponible en esta sesión del instalador
  [[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env" || true
  # Componentes que usa Neovim (rust_analyzer LSP, clippy, rustfmt)
  if command -v rustup > /dev/null 2>&1; then
    rustup component add rust-analyzer clippy rustfmt 2> /dev/null || true
  fi
}

main() {
  ensure_asdf
  cleanup_bogus_installs

  # utilidades que algunos plugins usan
  for c in curl git gpg tar; do
    command -v "$c" > /dev/null 2>&1 || warn "falta $c en PATH"
  done

  log "==> Node.js"
  if plugin_add_or_update nodejs https://github.com/asdf-vm/asdf-nodejs.git; then
    if [[ -x "$HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring" ]]; then
      bash "$HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring" || true
    fi
    ver="$(resolve_latest nodejs)"
    install_and_set_user nodejs "$ver"
  fi

  log "==> Python"
  if plugin_add_or_update python https://github.com/danhper/asdf-python.git; then
    ver="$(resolve_latest python)"
    install_and_set_user python "$ver"
  fi

  log "==> Go"
  if plugin_add_or_update golang https://github.com/asdf-community/asdf-golang.git; then
    ver="$(resolve_latest golang)"
    install_and_set_user golang "$ver"
  fi

  install_rust

  log "==> pnpm via Corepack"
  if command -v corepack > /dev/null 2>&1; then
    corepack enable || true
    corepack prepare pnpm@latest --activate || true
    asdf reshim nodejs || true
  fi

  asdf reshim || true
  log ""
  log "✅ Runtimes instalados."
  asdf current || true
  log ""
  log "which -a node pnpm python go cargo rustc:"
  which -a node || true
  which -a pnpm || true
  which -a python || true
  which -a go || true
  which -a cargo || true
  which -a rustc || true
}

main "$@"
