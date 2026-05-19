create_symlink() {
  local target="$1"
  local link="$2"
  local backup

  mkdir -p "$(dirname "$link")"
  if [ -L "$link" ]; then
    if [[ "$(readlink -f "$link")" == "$(readlink -f "$target")" ]]; then
      echo "Symlink already correct: $link -> $target"
      return 0
    fi
  fi

  if [ -L "$link" ] || [ -e "$link" ]; then
    backup="$link.bak.$(date +%Y%m%d%H%M%S)"
    mv "$link" "$backup"
    echo "Backed up existing path: $link -> $backup"
  fi

  ln -s "$target" "$link"
  echo "Symlink done: $link -> $target"
}

link_zshrc() {
  create_symlink "$DOTFILES_DIR/_zsh/init.zsh" "$HOME/.zshrc"
}

link_config_folders() {
  mkdir -p "$HOME/.config"
  for folder in "$DOTFILES_DIR"/*/; do
    local app
    app="$(basename "$folder")"
    [[ $app =~ ^_ ]] && continue
    [[ $app == "karabiner" ]] && continue
    [[ -z "$(ls -A "$folder")" ]] && continue
    create_symlink "$folder" "$HOME/.config/$app"
  done
}
