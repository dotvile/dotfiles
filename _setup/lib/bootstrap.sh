# bootstrap.sh — prerequisitos del instalador (Linux-first: apt / pacman).
# Autoinstala lo necesario para que setup.sh funcione: yq, toolchain de build,
# asdf (runtimes), y las herramientas que no vienen en los repos (starship, neovim).

_arch_tag() {
  case "$(uname -m)" in
    x86_64) echo "amd64" ;;
    aarch64 | arm64) echo "arm64" ;;
    *) echo "" ;;
  esac
}

install_yq() {
  # mikefarah yq v4 (necesario para leer apps.yaml). El `yq` de apt puede ser otro.
  command -v yq > /dev/null 2>&1 && return 0
  local arch; arch="$(_arch_tag)"
  [[ -n $arch ]] || { echo "❌ Arquitectura no soportada para yq" >&2; return 1; }
  echo "⏬ Instalando yq (mikefarah v4)…"
  sudo curl -fsSL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${arch}" \
    -o /usr/local/bin/yq
  sudo chmod +x /usr/local/bin/yq
}

install_asdf() {
  # asdf >= 0.16 es un binario Go. Se instala en ~/.asdf/bin (datos en ~/.asdf).
  command -v asdf > /dev/null 2>&1 && return 0
  local arch tag url tmp
  arch="$(_arch_tag)"
  [[ -n $arch ]] || { echo "❌ Arquitectura no soportada para asdf" >&2; return 1; }
  tag="$(curl -fsSL https://api.github.com/repos/asdf-vm/asdf/releases/latest \
    | grep -oP '"tag_name":\s*"\K[^"]+')"
  [[ -n $tag ]] || { echo "❌ No pude resolver la última versión de asdf" >&2; return 1; }
  url="https://github.com/asdf-vm/asdf/releases/download/${tag}/asdf-${tag}-linux-${arch}.tar.gz"
  tmp="$(mktemp -d)"
  echo "⏬ Instalando asdf ${tag} (${arch})…"
  curl -fsSL "$url" -o "$tmp/asdf.tar.gz"
  mkdir -p "$HOME/.asdf/bin"
  tar -xzf "$tmp/asdf.tar.gz" -C "$HOME/.asdf/bin" asdf
  rm -rf "$tmp"
  # Disponible en esta sesión del instalador
  export ASDF_DATA_DIR="$HOME/.asdf"
  export PATH="$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"
}

install_starship() {
  command -v starship > /dev/null 2>&1 && return 0
  echo "⏬ Instalando starship…"
  curl -sS https://starship.rs/install.sh | sh -s -- -y
}

_nvim_is_recent() {
  # Neovim >= 0.10 (requisito de lazy.nvim)
  command -v nvim > /dev/null 2>&1 || return 1
  local ver major minor
  ver="$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1)"
  major="${ver%%.*}"; minor="${ver##*.}"
  (( major > 0 )) || (( minor >= 10 ))
}

install_neovim() {
  # apt puede traer una versión antigua → release oficial (garantiza >= 0.10).
  _nvim_is_recent && { echo "neovim ya está en versión reciente."; return 0; }
  local asset tmp
  case "$(uname -m)" in
    x86_64) asset="nvim-linux-x86_64" ;;
    aarch64 | arm64) asset="nvim-linux-arm64" ;;
    *) echo "❌ Arquitectura no soportada para neovim" >&2; return 1 ;;
  esac
  echo "⏬ Instalando Neovim (release oficial)…"
  tmp="$(mktemp -d)"
  curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/${asset}.tar.gz" \
    -o "$tmp/nvim.tar.gz"
  sudo rm -rf /opt/nvim
  sudo mkdir -p /opt/nvim
  sudo tar -xzf "$tmp/nvim.tar.gz" -C /opt/nvim --strip-components=1
  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
  rm -rf "$tmp"
}

bootstrap_prereqs() {
  case "$PACKAGE_MANAGER" in
    apt)
      echo "==> Instalando toolchain base (apt)…"
      sudo apt update
      # build-essential + libs para compilar runtimes (asdf-python) + utilidades
      sudo apt install -y \
        zsh build-essential curl git unzip ca-certificates gnupg tar xz-utils \
        libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
        libffi-dev liblzma-dev libncurses-dev tk-dev
      install_yq
      install_asdf
      ;;
    pacman)
      echo "==> Instalando toolchain base (pacman)…"
      sudo pacman -Sy --noconfirm base-devel curl git unzip gnupg tar go-yq
      install_asdf
      ;;
    *)
      echo "❌ Este perfil (ubuntu-server) soporta apt/pacman, no '$PACKAGE_MANAGER'." >&2
      exit 1
      ;;
  esac
}

# Herramientas que no vienen (bien) en los repos del sistema.
install_extras() {
  install_starship
  install_neovim
}
