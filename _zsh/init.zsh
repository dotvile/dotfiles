CONFIG_PATH="$HOME/Development/dotfiles/_zsh"
# Funciones
for f in "$CONFIG_PATH/functions/"*.zsh; do
  source "$f"
done

# Exports y paths
source "$CONFIG_PATH/exports.zsh"

# Aliases y demás
source "$CONFIG_PATH/aliases.zsh"
source "$CONFIG_PATH/plugins.zsh"

# Llamadas finales
init_ssh_agent
init_starship

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# opencode
export PATH=/Users/victor/.opencode/bin:$PATH

# Android SDK (added for Expo/React Native)
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator
