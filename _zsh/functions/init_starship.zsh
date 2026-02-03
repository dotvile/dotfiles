init_starship() {
  if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
    export STARSHIP_CONFIG=~/.config/starship/starship.toml
  else
    echo "Starship is not installed"
  fi
}
