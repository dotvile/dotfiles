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

# Brew
alias updall='brew update && brew upgrade'
alias buni='brew uninstall'
alias bi='brew install'
alias bt='brew tap'

# Apps
alias dock='open /Applications/Docker.app/'
alias disc='open /Applications/Discord.app/'
alias oa='open -a'

# tmux
#   tls  -> sesiones vivas de un vistazo. ● conectada / ○ detached.
#   El formato es una condicional de tmux: #{?CONDICION,SI,NO}
alias tls='tmux list-sessions -F "#{?session_attached,●,○} #{session_name}  (#{session_windows} win, #{t:session_created})" 2>/dev/null || echo "sin sesiones"'
alias ta='tmux attach -t'
alias tn='tmux new -A -s'

# Misc
alias c='clear'
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'
alias fast='clear && fastfetch'

# Project Init
alias initfmt='$HOME/Development/dotfiles/_bin/helpers/init_formatter.sh'
alias initlint='$HOME/Development/dotfiles/_bin/helpers/init_linter.sh'
alias initobs='$HOME/Development/dotfiles/_bin/helpers/init_obsidian_templates.sh'

# Obsidian
alias obd='ob today'
alias obs='ob new study-session'
alias obc='ob new concept-note'
alias obso='ob new source-note'
alias obm='ob sync-mocs'
alias oo='cd $HOME/library/Mobile\ Documents/iCloud~md~obsidian/Documents/Vile'
alias oor='nvim $HOME/library/Mobile\ Documents/iCloud~md~obsidian/Documents/Vile/inbox/*.md'
alias nvoo='cd $HOME/library/Mobile\ Documents/iCloud~md~obsidian/Documents/Vile && nvim'
