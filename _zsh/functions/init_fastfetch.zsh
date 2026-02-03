init_fastfetch() {
  if command -v fastfetch &> /dev/null; then
    fastfetch
  else
    echo "Fastfetch is not installed"
  fi
}
