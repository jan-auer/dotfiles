# VSCode settings

if ( is_osx ); then
  VSCODE_DIR="$HOME/Library/Application Support/Code/User"
elif ( is_linux ); then
  VSCODE_DIR="$HOME/.config/Code/User"
fi

mkdir -p "$VSCODE_DIR"
ln -sf "$ROOT/defaults/vscode.json" "$VSCODE_DIR/settings.json"

# iTerm 2 Theme
# https://iterm2.com/python-api/tutorial/running.html#auto-run-scripts

if ( is_osx ); then
  ITERM_DIR="$HOME/Library/ApplicationSupport/iTerm2/Scripts/AutoLaunch"
  mkdir -p "$ITERM_DIR"
  ln -sf "$ROOT/defaults/iterm2-theme.py" "$ITERM_DIR/theme.py"
fi
