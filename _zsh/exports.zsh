# --- editor
export EDITOR='nvim'
export VISUAL='nvim'

export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/Development/dotfiles/_bin:$PATH"
# rust
export PATH="$HOME/.cargo/bin:$PATH"
#local
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"

export DOTFILES_OS="$(uname -s)"
export OBSIDIAN_VAULT_DIR="${OBSIDIAN_VAULT_DIR:-$HOME/Documents/Obsidian/Vile}"

export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"

# Local, non-versioned environment overrides.
# Copy `_zsh/local.zsh.example` to `_zsh/local.zsh` and fill in your values.
if [[ -f "$HOME/Development/dotfiles/_zsh/local.zsh" ]]; then
  source "$HOME/Development/dotfiles/_zsh/local.zsh"
fi


# De-dup and helper PATH
typeset -U path
path_prepend() {
  local i; for (( i=$#; i>=1; i-- )); do
    [[ -d "${@:$i:1}" ]] && path=("${@:$i:1}" $path)
  done
}

# Force shims first for asdf >= 0.16 binary install.
path_prepend "$ASDF_DATA_DIR/shims"

# JAVA_HOME from asdf
if command -v asdf >/dev/null 2>&1; then
  asdf_java_dir="$(asdf where java 2>/dev/null || true)"
  [[ -n "$asdf_java_dir" ]] && export JAVA_HOME="$asdf_java_dir"
fi

# PNPM (NO Corepack)
# export PNPM_HOME="$HOME/.local/share/pnpm"; path_prepend "$PNPM_HOME"
# Go tools (go install ...@latest)
# export GOPATH="${GOPATH:-$HOME/go}"
