#General
alias ..='cd ..'
alias ...='cd ../..'

# Neovim
alias nvdot='cd ~/Development/dotfiles && nvim'
alias nvc='cd ~/Development/dotfiles/nvim && nvim'
#Java
alias jc='javac'
alias jx='java'
# Go
alias got='go test -bench=. -benchmem -cover'
#Python
alias py='python3'
alias activate="source .venv/bin/activate"

# Package manager
alias updall='sudo pacman -Syu'
alias puni='sudo pacman -Rns'
alias pi='sudo pacman -S'

# Apps
if command -v xdg-open > /dev/null 2>&1; then
  alias oa='xdg-open'
fi

# Misc
alias c='clear'
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'
alias fast='clear && fastfetch'

# Project Init
alias initfmt='$HOME/Development/dotfiles/_bin/helpers/init_formatter.sh'
alias initlint='$HOME/Development/dotfiles/_bin/helpers/init_linter.sh'
alias initobs='$HOME/Development/dotfiles/_bin/helpers/init_obsidian_templates.sh'

# Tmux
alias ta='tmux attach -t main || tmux new -s main'
alias tls='tmux ls'
alias tk='tmux kill-session -t'

# File manager
alias y='yazi'

# Obsidian
alias obd='ob today'
alias obs='ob new study-session'
alias obc='ob new concept-note'
alias obso='ob new source-note'
alias obm='ob sync-mocs'
alias oo='cd "$OBSIDIAN_VAULT_DIR"'
alias oor='nvim "$OBSIDIAN_VAULT_DIR"/inbox/*.md'
alias nvoo='cd "$OBSIDIAN_VAULT_DIR" && nvim'
