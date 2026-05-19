ensure_yq() {
  command -v yq > /dev/null 2>&1 || {
    echo "❌ yq is required (install go-yq on Arch)" >&2
    exit 1
  }
}

_yaml_all_for_pm() {
  local apps_file="$DOTFILES_DIR/_setup/apps.yaml"
  yq -r '.apps[] | select(. != null)' "$apps_file"
}

install_from_yaml() {
  local apps_file="$DOTFILES_DIR/_setup/apps.yaml"
  [[ -f $apps_file ]] || {
    echo "ℹ️  No apps.yaml at $apps_file (skipping)"
    return 0
  }
  ensure_yq

  _yaml_all_for_pm | grep -vE '^\s*$' | awk '!seen[$0]++' \
    | while IFS= read -r pkg; do
      install_if_missing "$pkg"
    done
}
