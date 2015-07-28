is_osx || return 1

if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
	xcode-select --install
fi

