# Dotfiles — perfil `ubuntu-server`

Configuración Linux-first (Ubuntu Server) del entorno: **zsh + starship + neovim** y runtimes
gestionados con **asdf** (Node, Python, Go). Pensado para un servidor headless (homelab).

Sin herencia de macOS: no usa Homebrew ni apps de escritorio.

## Requisitos

- Ubuntu/Debian (apt) — también soporta Arch (pacman).
- `sudo` disponible.
- `git` instalado (para clonar el repo).

Todo lo demás (zsh, toolchain de build, `yq`, `asdf`, `starship`, `neovim`) lo instala `setup.sh`.

## Instalación

```bash
# 1) Clonar en ~/dotfiles y seleccionar este perfil
git clone git@github.com:dotvile/dotfiles.git ~/dotfiles
cd ~/dotfiles
git checkout profiles/ubuntu-server

# 2) Ejecutar el instalador
./setup.sh

# 3) Poner zsh como shell por defecto (si no lo está) y reiniciar la sesión
chsh -s "$(command -v zsh)"
```

Cierra y reabre la sesión SSH: `~/.zshrc` (enlazado a `_zsh/init.zsh`) cargará el entorno.

## Qué hace `setup.sh`

1. **Prerrequisitos** (`_setup/lib/bootstrap.sh`): instala vía apt `zsh` + toolchain de build +
   librerías para compilar Python, más `yq` (mikefarah v4) y **asdf** (binario 0.16).
2. **Paquetes CLI** (`_setup/apps.yaml`): `fzf`, `ripgrep`, `fastfetch`, `jq`, `tree`, `htop`.
3. **Extras** fuera de repos: **starship** (script oficial) y **neovim ≥0.10** (release oficial).
4. **Symlinks**: `~/.zshrc → _zsh/init.zsh`, y cada carpeta de config (`nvim`, `starship`) a
   `~/.config/`.
5. **Runtimes con asdf** (`_setup/bin/install_runtimes.sh`): Node, Python, Go (Java y .NET vienen
   desactivados; descoméntalos en el script si los necesitas).

## Notas

- **Node.js** (para Claude Code y tooling JS) se instala vía asdf.
- **Docker** NO se instala aquí: va en la fase de servicios del homelab con Docker CE oficial.
- Overrides locales no versionados (secretos, URLs de BBDD): copia `_zsh/local.zsh.example` a
  `_zsh/local.zsh`.
- La clave SSH que carga el agente al iniciar zsh es `~/.ssh/github` (ver `_zsh/functions/init_ssh.zsh`).
