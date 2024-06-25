if ( is_osx ); then
  # Copy Rectangle config to application support
  RECTANGLE_DIR="$HOME/Library/Application Support/Rectangle"
  mkdir -p "$RECTANGLE_DIR"
  ln -sf "$ROOT/defaults/RectangleConfig.json" "$RECTANGLE_DIR/RectangleConfig.json"
fi
