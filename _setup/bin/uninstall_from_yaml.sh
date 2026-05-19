#!/usr/bin/env bash

# Simulate
#   ./_setup/bin/uninstall_from_yaml.sh
# Execute
#   CONFIRM=1 ./_setup/bin/uninstall_from_yaml.sh

set -Eeuo pipefail

APPS_FILE="${1:-_setup/apps.yaml}"
CONFIRM="${CONFIRM:-0}" # 1 = ejecuta; 0 = dry-run

command -v yq > /dev/null 2>&1 || {
  echo "❌ yq v4 requerido"
  exit 1
}
command -v pacman > /dev/null 2>&1 || {
  echo "❌ pacman requerido"
  exit 1
}
[ -f "$APPS_FILE" ] || {
  echo "❌ No existe $APPS_FILE"
  exit 1
}

echo "=== Desinstalación (pacman) desde $APPS_FILE ==="

while IFS= read -r token; do
  [ -z "$token" ] && continue
  if pacman -Qi "$token" > /dev/null 2>&1; then
    if [ "$CONFIRM" = "1" ]; then
      echo "⛔ sudo pacman -Rns --noconfirm $token"
      sudo pacman -Rns --noconfirm "$token" || true
    else
      echo "DRY-RUN: sudo pacman -Rns --noconfirm $token"
    fi
  else
    echo "ℹ️  $token no está instalado por pacman."
  fi
done < <(yq -r '.apps[] | select(. != null)' "$APPS_FILE" | awk '!seen[$0]++')
