if [ ! -f "$DEST/.zgen.zsh" ]
then
	curl -L https://raw.githubusercontent.com/tarjoilija/zgen/master/zgen.zsh > "$DEST/.zgen.zsh"
fi

