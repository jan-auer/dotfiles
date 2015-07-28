source $HOME/.antigen.zsh

# Load oh-my-zsh with custom configuration
DEFAULT_USER="jauer"
DISABLE_AUTO_TITLE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="dd.mm.yyyy"
antigen use oh-my-zsh

# Bundles from oh-my-zsh
antigen bundle bower
antigen bundle common-aliases
antigen bundle colored-man
antigen bundle gitfast
antigen bundle tmux
antigen bundle vagrant

# Other plugins
antigen bundle zsh-users/zsh-syntax-highlighting

# OS specific plugins
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # None so far...
elif [[ "$OSTYPE" == "darwin"* ]]; then
    antigen bundle brew
    antigen bundle brew-cask
    antigen bundle osx
elif [[ "$OSTYPE" == "cygwin" ]]; then
    antigen bundle cygwin
fi

# Own settings
antigen bundle jan-auer/zsh-config
antigen theme jan-auer/zsh-multiline multiline

# Apply all plugins
antigen apply

