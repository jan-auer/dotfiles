if [ ! -f "$DEST/.antigen.zsh" ]
then
	curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > "$DEST/.antigen.zsh"
fi

