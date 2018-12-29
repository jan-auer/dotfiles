if [[ ! "$SHELL" == *zsh ]] ; then
	if (( $+commands[chsh] )); then
		chsh -s $(which zsh)
	else
		echo "Could not chsh. Add this to your .profile:"
		echo
		echo "if [[ -x /usr/local/bin/zsh ]]; then"
		echo "	export SHELL=/usr/local/bin/zsh"
		echo "	exec /usr/local/bin/zsh"
		echo "fi"
		echo
	fi
fi
