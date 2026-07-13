# General
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias ll='ls -lah'

# Neovim
alias nvdot='cd $DOTFILES_DIR && nvim'
alias nvc='cd $DOTFILES_DIR/nvim && nvim'

# Java
alias jc='javac'
alias jx='java'
# Go
alias got='go test -bench=. -benchmem -cover'
# Python
alias py='python3'
alias activate="source .venv/bin/activate"

# apt (gestión de paquetes del sistema)
alias updall='sudo apt update && sudo apt full-upgrade -y'
alias api='sudo apt install -y'
alias apr='sudo apt remove'
alias aps='apt search'

# Docker (homelab)
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'

# Misc
alias fast='clear && fastfetch'

# Project Init (helpers del repo)
alias initfmt='$DOTFILES_DIR/_bin/helpers/init_formatter.sh'
alias initlint='$DOTFILES_DIR/_bin/helpers/init_linter.sh'
