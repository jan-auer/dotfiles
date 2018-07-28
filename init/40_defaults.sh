# VSCode settings

if ( is_osx ); then
  mkdir -p "$HOME/Library/Application Support/Code/User"
  ln -sf "$ROOT/defaults/vscode.json" "$HOME/Library/Application Support/Code/User/settings.json"
elif ( is_linux ); then
  mkdir -p "$HOME/.config/Code/User"
  ln -sf "$ROOT/defaults/vscode.json" "$HOME/.config/Code/User/settings.json"
fi
