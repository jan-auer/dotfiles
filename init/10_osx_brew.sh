is_osx || return 0

(
	# Base packages
	packages=(
		'brew "bat"'
		'brew "claude-code"'
		'brew "fd"'
		'brew "fzf"'
		'brew "gh"'
		'brew "git"'
		'brew "git-delta"'
		'brew "hub"'
		'brew "jq"'
		'brew "less"'
		'brew "mas"'
		'brew "prettier"'
		'brew "ripgrep"'
		'brew "tokei"'
		'brew "vim"'
		'brew "watch"'
		'cask "1password"'
		'cask "coconutbattery"'
		'cask "daisydisk"'
		'cask "docker"'
		'cask "firefox"'
		'cask "google-chrome"'
		'cask "google-drive"'
		'cask "iterm2"'
		'cask "microsoft-office"'
		'cask "orbstack"'
		'cask "pronotes"'
		'cask "raycast"'
		'cask "sonos"'
		'cask "utm"'
		'cask "visual-studio-code"'
		'cask "whatsapp"'
		'cask "yubico-yubikey-manager"'
	)

	# Work packages
	if [[ "$INSTALL_PROFILE" == "work" ]]; then
		packages+=(
			'brew "colordiff"'
			'brew "dos2unix"'
			'brew "getsentry/tools/sentry-cli"'
			'brew "htop"'
			'brew "nmap"'
			'cask "hex-fiend"'
			'cask "ngrok"'
		)
	fi

	# Personal packages
	if [[ "$INSTALL_PROFILE" == "personal" ]]; then
		packages+=(
			'brew "exiftool"'
			'brew "ffmpeg"'
			'brew "yt-dlp"'
			# 'brew "blackhole-2ch"'
			# 'brew "mactex"'
			'cask "handbrake"'
			'cask "vlc"'
			# 'cask "texpad"'
		)
	fi

	# Install homebrew first
	if ! hash brew > /dev/null 2>&1 ; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		brew doctor
	fi

	# Make sure everything is up-to-date
	brew update > /dev/null

	# Install packages
	printf '%s\n' "${packages[@]}" | brew bundle --no-lock --file=-

	# Cleanup after install
	brew cleanup -s

	# Show formulae installed on this machine but not in the Brewfile
	cleanup_output=$(printf '%s\n' "${packages[@]}" | brew bundle cleanup --dry-run --file=- 2>/dev/null)
	if [[ -n "$cleanup_output" ]]; then
		warn "These packages are installed but not tracked in the Brewfile:"
		echo "$cleanup_output"
		echo ""
		echo "Add them to 10_osx_brew.sh to track them, or run 'brew uninstall <formula>' to remove them."
	fi
)
