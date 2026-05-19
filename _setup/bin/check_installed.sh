#!/usr/bin/env bash
set -Eeuo pipefail

APPS_FILE="${1:-_setup/apps.yaml}"

if ! command -v pacman > /dev/null 2>&1; then
  echo "❌ Este script espera un sistema con pacman"
  exit 1
fi

command -v yq > /dev/null 2>&1 || {
  echo "❌ yq v4 requerido"
  exit 1
}
[ -f "$APPS_FILE" ] || {
  echo "❌ No existe $APPS_FILE"
  exit 1
}

echo "=== Apps declaradas en YAML (PM=pacman) ==="

missing=0

while IFS= read -r pkg; do
  [ -z "$pkg" ] && continue
  if pacman -Qi "$pkg" > /dev/null 2>&1; then
    printf '✓ %s\n' "$pkg"
  else
    printf '✗ %s (missing)\n' "$pkg"
    missing=$((missing + 1))
  fi
done < <(yq -r '.apps[] | select(. != null)' "$APPS_FILE" | awk 'NF && !seen[$0]++')

echo
echo "=== Runtimes en PATH (asdf/Corepack) ==="

is_shim_first() {
  first="$(which -a "$1" 2> /dev/null | head -n1 || true)"
  case "$first" in
    "$HOME/.asdf/shims/"* | *"/.asdf/shims/"*) return 0 ;;
    *) return 1 ;;
  esac
}

check_bin() {
  name="$1"
  cmd="${2:-$1 --version}"
  filter="${3:-}"
  if command -v "$name" > /dev/null 2>&1; then
    out="$($cmd 2>&1 | head -n1 || true)"
    [ -n "$filter" ] && out="$(eval "$filter")"
    if is_shim_first "$name"; then
      printf '✓ %-8s -> %s\n' "$name" "$out"
    else
      where_all="$(which -a "$name" 2> /dev/null | tr '\n' ' ')"
      printf '⚠️  %-8s -> %s  (no es shim primero)  [%s]\n' "$name" "$out" "$where_all"
    fi
  else
    printf '✗ %-8s (no en PATH)\n' "$name"
  fi
}

check_bin node "node -v"
check_bin pnpm "pnpm -v"
check_bin java "java -version" 'out="$(printf %s "$out" | grep -Eo "[0-9]+(\.[0-9]+){1,3}(_[0-9]+)?" | head -n1)"'
check_bin python "python --version"
check_bin go "go version"
check_bin dotnet 'bash -lc '\''echo "SDK $(dotnet --version) | Runtime $(dotnet --list-runtimes | head -n1 | awk "{print \$2}")"'\'

if command -v asdf > /dev/null 2>&1; then
  echo
  echo "=== asdf current (resumen) ==="
  asdf current || true
fi

echo
echo "Resumen YAML: $missing faltan."
# exit "$missing"  # <- descomenta si quieres modo estricto
