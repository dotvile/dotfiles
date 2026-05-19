detect_package_manager() {
  if command -v pacman > /dev/null 2>&1; then
    echo "pacman"
  else
    echo "❌ This branch only supports pacman-based systems." >&2
    exit 1
  fi
}

install_package() {
  local app="$1"
  if [[ $PACKAGE_MANAGER != "pacman" ]]; then
    echo "❌ Unsupported PM: $PACKAGE_MANAGER" >&2
    return 1
  fi
  sudo pacman -Sy --noconfirm "$app"
}

install_if_missing() {
  local app="$1"
  if command -v "$app" > /dev/null 2>&1; then
    echo "$app already installed."
    return 0
  fi
  echo "Installing $app..."
  install_package "$app"
}
