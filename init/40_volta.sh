export VOLTA_HOME="$HOME/.volta"
[ -s "$VOLTA_HOME/load.sh" ] || return 0

# Initialize volta
. "$VOLTA_HOME/load.sh"
export PATH="$VOLTA_HOME/bin:$PATH"
volta install node

if ( is_osx ); then
  # Format Markdown quick action requires node & prettier
  volta install prettier
fi
