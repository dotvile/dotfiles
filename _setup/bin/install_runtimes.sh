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
  for t in nodejs java python golang dotnet-core; do
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
      java)
        # ejemplo: temurin-21
        v="$(asdf list all java "$sel" 2> /dev/null | tail -n1 | tr -d '[:space:]' || true)"
        ;;
      python | nodejs | golang | dotnet-core)
        # filtra solo números x.y[.z] (+sufijo opcional para Java-like)
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

install_pnpm_binary() {
  # pnpm como binario standalone: las versiones recientes de Node ya NO traen
  # corepack, así que lo bajamos directo de las releases de pnpm. Idempotente.
  local arch asset home bin
  case "$(uname -m)" in
    x86_64) arch="x64" ;;
    aarch64 | arm64) arch="arm64" ;;
    *) warn "arch $(uname -m) no soportada para pnpm; lo salto"; return 0 ;;
  esac
  asset="pnpm-linux-${arch}"
  home="${PNPM_HOME:-$HOME/.local/share/pnpm}"
  bin="$home/pnpm"
  mkdir -p "$home"
  if curl -fsSL "https://github.com/pnpm/pnpm/releases/latest/download/${asset}" -o "$bin.tmp"; then
    chmod +x "$bin.tmp" && mv -f "$bin.tmp" "$bin"
    log "✅ pnpm $("$bin" --version 2>/dev/null || echo '(instalado)') en $bin"
  else
    warn "no pude descargar pnpm ($asset); lo salto"
    rm -f "$bin.tmp"
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

  log "==> Java (Temurin 21)"
  if plugin_add_or_update java https://github.com/halcyon/asdf-java.git; then
    ver="$(resolve_latest java 'temurin-21')"
    install_and_set_user java "$ver"
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

  log "==> .NET SDK"
  if plugin_add_or_update dotnet-core https://github.com/emersonsoares/asdf-dotnet-core.git; then
    ver="$(resolve_latest dotnet-core)"
    install_and_set_user dotnet-core "$ver"
  fi

  log "==> pnpm (binario standalone)"
  install_pnpm_binary
  export PATH="${PNPM_HOME:-$HOME/.local/share/pnpm}:$PATH"

  asdf reshim || true
  log ""
  log "✅ Runtimes instalados."
  asdf current || true
  log ""
  log "which -a node pnpm java python go dotnet:"
  which -a node || true
  which -a pnpm || true
  which -a java || true
  which -a python || true
  which -a go || true
  which -a dotnet || true
}

main "$@"
