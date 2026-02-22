CLAUDE_SRC="$ROOT/claude"
CLAUDE_DEST="$HOME/.claude"

mkdir -p "$CLAUDE_DEST"

for entry in "$CLAUDE_SRC"/*; do
	name="$(basename "$entry")"
	ln -sfn "$entry" "$CLAUDE_DEST/$name"
done
