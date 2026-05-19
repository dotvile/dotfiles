# Dotfiles Setup (zsh + yq)

## Requisitos

- **zsh** as shell
- **sudo** available (Linux)
- **yq** installed for YAML on CLI
- **git** installed

## EndeavourOS / Arch

```bash
sudo pacman -Syu
sudo pacman -S --needed git zsh go-yq neovim tmux wezterm fastfetch fzf ripgrep starship uv docker
```

Optional fonts for your WezTerm config:

```bash
sudo pacman -S --needed ttf-recursive-nerd ttf-jetbrains-mono-nerd ttf-firacode-nerd ttf-nerd-fonts-symbols
```

If you want to keep using your Obsidian helpers, set your vault path before opening a shell:

```bash
export OBSIDIAN_VAULT_DIR="$HOME/Documents/Obsidian/Vile"
```

### Install config

```bash
./setup.sh
```

## Documentacion de Obsidian

- Referencia completa de comandos y flujo: `_docs/obsidian/README.md`
