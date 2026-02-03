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

# Misc
alias c='clear'
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'
alias fast='clear && fastfetch'

# Project Init
alias initfmt='$HOME/Development/dotfiles/_bin/helpers/init_formatter.sh'
alias initlint='$HOME/Development/dotfiles/_bin/helpers/init_linter.sh'

# Obsidian
alias oo='cd $HOME/library/Mobile\ Documents/iCloud~md~obsidian/Documents/Vile'
alias oor='nvim $HOME/library/Mobile\ Documents/iCloud~md~obsidian/Documents/Vile/inbox/*.md'
alias nvoo='cd $HOME/library/Mobile\ Documents/iCloud~md~obsidian/Documents/Vile && nvim'
