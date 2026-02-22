if [ ! -d "$DEST/.zgen" ]; then
	git clone https://github.com/tarjoilija/zgen.git "$DEST/.zgen"
else
	zgen selfupdate
	zgen update
fi

