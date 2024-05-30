is_osx || return 0

mkdir -p "$HOME/.iterm2"
cd "$HOME/.iterm2"

curl -L https://iterm2.com/shell_integration/zsh -o iterm2_shell_integration.zsh
