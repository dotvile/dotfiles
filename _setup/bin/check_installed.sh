#!/usr/bin/env bash
set -Eeuo pipefail

APPS_FILE="${1:-_setup/apps.yaml}"

# Detecta PM
if command -v brew > /dev/null 2>&1; then
  PM="brew"
elif command -v apt > /dev/null 2>&1; then
  PM="apt"
elif command -v pacman > /dev/null 2>&1; then
  PM="pacman"
else
  echo "❌ No se detectó gestor (brew/apt/pacman)"
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

echo "=== Apps declaradas en YAML (PM=$PM) ==="

installed_formula=0
installed_cask=0
missing=0

while IFS= read -r pkg; do
  [ -z "$pkg" ] && continue
  case "$PM" in
    brew)
      tok="${pkg##*/}"
      if brew list --formula --versions -- "$tok" > /dev/null 2>&1; then
        printf '✓ %s [formula]\n' "$tok"
        installed_formula=$((installed_formula + 1))
      elif brew list --cask --versions -- "$tok" > /dev/null 2>&1; then
        printf '✓ %s [cask]\n' "$tok"
        installed_cask=$((installed_cask + 1))
      else
        printf '✗ %s (missing)\n' "$tok"
        missing=$((missing + 1))
      fi
      ;;
    apt)
      dpkg -s "$pkg" > /dev/null 2>&1 && printf '✓ %s\n' "$pkg" || printf '✗ %s (missing)\n' "$pkg"
      ;;
    pacman)
      pacman -Qi "$pkg" > /dev/null 2>&1 && printf '✓ %s\n' "$pkg" || printf '✗ %s (missing)\n' "$pkg"
      ;;
  esac
done < <(
  PM="$PM" yq -r '
    (.apps[] | select(tag=="!!str")),
    (.apps[] | select(tag=="!!map") | .[env(PM)] | select(. != null))
  ' "$APPS_FILE" | awk 'NF && !seen[$0]++'
)

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
check_bin python "python --version"
check_bin go "go version"
check_bin rustc "rustc --version"
check_bin cargo "cargo --version"

if command -v asdf > /dev/null 2>&1; then
  echo
  echo "=== asdf current (resumen) ==="
  asdf current || true
fi

echo
echo "Resumen YAML: brew formula: $installed_formula, brew cask: $installed_cask. $missing faltan."
# exit "$missing"  # <- descomenta si quieres modo estricto
