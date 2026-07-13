#!/usr/bin/env bash
set -Eeuo pipefail
trap 'echo "❌ Exit $?: «$BASH_COMMAND» en ${BASH_SOURCE[0]}:${LINENO}"' ERR

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

source "$DOTFILES_DIR/_setup/lib/pkg.sh"
source "$DOTFILES_DIR/_setup/lib/shell.sh"
source "$DOTFILES_DIR/_setup/lib/fs.sh"
source "$DOTFILES_DIR/_setup/lib/bootstrap.sh"
source "$DOTFILES_DIR/_setup/lib/yaml_install.sh"

main() {
  PACKAGE_MANAGER="$(detect_package_manager)"

  bootstrap_prereqs

  install_from_yaml "$@"

  # Herramientas fuera de los repos (starship, neovim >= 0.10)
  install_extras

  link_zshrc
  link_config_folders

  if [[ -x "$DOTFILES_DIR/_setup/bin/install_runtimes.sh" ]]; then
    "$DOTFILES_DIR/_setup/bin/install_runtimes.sh" || true
  fi

  echo "✅ Setup complete! Restart your terminal."
}

main "$@"
