# --- editor
export EDITOR='nvim'

export PATH="$HOME/.bin:$PATH"
# rust
export PATH="$HOME/.cargo/bin:$PATH"
# opencode
export PATH="$HOME/.zshrc:$PATH"
#local
export PATH="$HOME/.local/bin:$PATH"

# --- Homebrew 
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# asdf 
if [[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]]; then
  . /opt/homebrew/opt/asdf/libexec/asdf.sh
fi


# De-dup and helper PATH
typeset -U path
path_prepend() {
  local i; for (( i=$#; i>=1; i-- )); do
    [[ -d "${@:$i:1}" ]] && path=("${@:$i:1}" $path)
  done
}

# Force shims/bin from asdf first
ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"
path_prepend "$ASDF_DIR/shims" "$ASDF_DIR/bin"

# JAVA_HOME from asdf
if command -v asdf >/dev/null 2>&1; then
  asdf_java_dir="$(asdf where java 2>/dev/null || true)"
  [[ -n "$asdf_java_dir" ]] && export JAVA_HOME="$asdf_java_dir"
fi

# PNPM (NO Corepack)
# export PNPM_HOME="$HOME/Library/pnpm"; path_prepend "$PNPM_HOME"
# Go tools (go install ...@latest)
# export GOPATH="${GOPATH:-$HOME/go}"
# .NET by cask
#[[ -x /usr/local/share/dotnet/dotnet ]] && path_prepend "/usr/local/share/dotnet" "/usr/local/bin"
