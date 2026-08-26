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

# Contenedores (homelab). El motor depende de la maquina: docker en macOS,
# podman en el perfil de servidor. La CLI de podman es compatible, asi que
# basta con apuntar los aliases al primero que exista; si no hay ninguno no
# se definen, en vez de fallar con "command not found" al invocarlos.
for _engine in docker podman; do
  if command -v "$_engine" > /dev/null 2>&1; then
    alias dps="$_engine ps"
    alias dpsa="$_engine ps -a"
    alias dcu="$_engine compose up -d"
    alias dcd="$_engine compose down"
    alias dcl="$_engine compose logs -f"
    break
  fi
done
unset _engine

# tmux
#   tls  -> sesiones vivas de un vistazo. ● conectada / ○ detached.
#   El formato es una condicional de tmux: #{?CONDICION,SI,NO}
alias tls='tmux list-sessions -F "#{?session_attached,●,○} #{session_name}  (#{session_windows} win, #{t:session_created})" 2>/dev/null || echo "sin sesiones"'
alias ta='tmux attach -t'
alias tn='tmux new -A -s'

# Misc
alias fast='clear && fastfetch'

# Project Init (helpers del repo)
alias initfmt='$DOTFILES_DIR/_bin/helpers/init_formatter.sh'
alias initlint='$DOTFILES_DIR/_bin/helpers/init_linter.sh'
