init_starship() {
  if command -v starship &> /dev/null; then
    export STARSHIP_CONFIG=~/.config/starship/starship.toml
    eval "$(starship init zsh)"
  else
    echo "Starship is not installed"
  fi
}
