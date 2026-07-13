# Entry point del entorno zsh (se enlaza a ~/.zshrc mediante setup.sh).
# Autocontenido: define DOTFILES_DIR para que funcione al ser cargado como ~/.zshrc.
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
export DOTFILES_DIR
CONFIG_PATH="$DOTFILES_DIR/_zsh"

# Funciones
for f in "$CONFIG_PATH/functions/"*.zsh(N); do
  source "$f"
done

# Exports y paths
source "$CONFIG_PATH/exports.zsh"

# Aliases y plugins
source "$CONFIG_PATH/aliases.zsh"
source "$CONFIG_PATH/plugins.zsh"

# Llamadas finales
init_ssh_agent
init_starship

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
