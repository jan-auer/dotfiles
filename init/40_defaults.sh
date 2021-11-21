# iTerm 2 Theme
# https://iterm2.com/python-api/tutorial/running.html#auto-run-scripts

if ( is_osx ); then
  ITERM_DIR="$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch"
  mkdir -p "$ITERM_DIR"
  ln -sf "$ROOT/defaults/iterm2-theme.py" "$ITERM_DIR/theme.py"
fi
