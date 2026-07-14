#!/usr/bin/env bash

# Simulate
#    ./_setup/bin/uninstall_runtimes_asdf.sh
# Execute
#     CONFIRM=1 ./_setup/bin/uninstall_runtimes_asdf.sh

set -Eeuo pipefail
CONFIRM="${CONFIRM:-0}" # 1 = ejecutar; 0 = dry-run

ensure_asdf() {
  if ! command -v asdf > /dev/null 2>&1; then
    local asdf_sh="/opt/homebrew/opt/asdf/libexec/asdf.sh"
    [[ -f $asdf_sh ]] && . "$asdf_sh"
  fi
  command -v asdf > /dev/null 2>&1 || {
    echo "❌ asdf no disponible"
    exit 1
  }
}

list_installed_versions() {
  asdf list "$1" 2> /dev/null | sed 's/^[[:space:]]*//' | sed '/^$/d' || true
}

remove_all_versions() {
  local tool="$1"
  while IFS= read -r ver; do
    [[ -z $ver ]] && continue
    if [[ $CONFIRM == "1" ]]; then
      echo "⛔ asdf uninstall $tool $ver"
      asdf uninstall "$tool" "$ver" || true
    else
      echo "DRY-RUN: asdf uninstall $tool $ver"
    fi
  done < <(list_installed_versions "$tool")
}

remove_plugin() {
  local tool="$1"
  if asdf plugin list | grep -qxF "$tool"; then
    if [[ $CONFIRM == "1" ]]; then
      echo "⛔ asdf plugin remove $tool"
      asdf plugin remove "$tool" || true
    else
      echo "DRY-RUN: asdf plugin remove $tool"
    fi
  fi
}

main() {
  ensure_asdf
  local tools=(nodejs python golang)

  echo "=== Desinstalación runtimes (asdf) ==="
  for t in "${tools[@]}"; do
    echo "-- $t --"
    remove_all_versions "$t"
    remove_plugin "$t"
  done

  if [[ $CONFIRM == "1" ]]; then
    asdf reshim || true
  fi

  echo "=== pnpm (Corepack) ==="
  if command -v corepack > /dev/null 2>&1; then
    if [[ $CONFIRM == "1" ]]; then
      corepack disable || true
    else
      echo "DRY-RUN: corepack disable"
    fi
  fi
  # limpia shims/installs residuales (por si acaso)
  if [[ $CONFIRM == "1" ]]; then
    rm -rf "$HOME/.asdf/installs" "$HOME/.asdf/shims" 2> /dev/null || true
  fi
}

main "$@"
