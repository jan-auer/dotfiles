is_osx || return 0

if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
	xcode-select --install
fi

