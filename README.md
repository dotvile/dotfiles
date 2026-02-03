# Dotfiles Setup (zsh + yq)

## Requisitos

- **zsh** as shell
- **sudo** available (Linux)
- **brew** installed (Homebrew (MacOS))
- **yq** installed for YAML on CLI
- **git** installed

### Install Homebrew

```

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
source ~/.zshrc
brew --version

```

### Install yq and git

```
#MacOS
brew install yq git
```

### Install config

```
./setup.sh
```
