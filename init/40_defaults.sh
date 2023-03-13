if ( is_osx ); then
  # Switch iTerm 2 Theme between light and dark
  # https://iterm2.com/python-api/tutorial/running.html#auto-run-scripts
  ITERM_DIR="$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch"
  mkdir -p "$ITERM_DIR"
  ln -sf "$ROOT/defaults/iterm2-theme.py" "$ITERM_DIR/theme.py"

  # Copy automator quick actions
  SERVICES_DIR="$HOME/Library/Services/"
  for workflow in $ROOT/defaults/*.workflow; do
    ln -sf "$workflow" $SERVICES_DIR
  done

  # Copy Rectangle config to application support
  RECTANGLE_DIR="$HOME/Library/Application Support/Rectangle"
  mkdir -p "$RECTANGLE_DIR"
  ln -sf "$ROOT/defaults/RectangleConfig.json" "$RECTANGLE_DIR/RectangleConfig.json"
fi
