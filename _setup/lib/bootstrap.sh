ensure_command() {
  local name="$1"
  local pacman_pkg="${2:-$1}"
  if ! command -v "$name" > /dev/null 2>&1; then
    echo "⏬ Installing $pacman_pkg (needed for $name)…"
    install_package "$pacman_pkg"
  fi
}

bootstrap_prereqs() {
  ensure_command yq go-yq
  ensure_command git git
  ensure_command zsh zsh
  sudo pacman -Sy --noconfirm base-devel curl gpg tar unzip || true
}
