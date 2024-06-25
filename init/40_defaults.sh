if ( is_osx ); then
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
