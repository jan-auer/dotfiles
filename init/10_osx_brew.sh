is_osx || return 0

(
	# Base packages
	packages=(
		1password
		bat
		claude-code
		coconutbattery
		daisydisk
		docker
		fd
		firefox
		fzf
		gh
		git
		git-delta
		google-chrome
		google-drive
		hub
		iterm2
		jq
		less
		mas
		microsoft-office
		orbstack
		pronotes
		raycast
		ripgrep
		sonos
		tokei
		utm
		vim
		visual-studio-code
		watch
		whatsapp
		yubico-yubikey-manager
	)

	# Work packages
	if [[ "$INSTALL_PROFILE" == "work" ]]; then
		packages+=(
			colordiff
			dos2unix
			getsentry/tools/sentry-cli
			hex-fiend
			htop
			ngrok
			nmap
		)
	fi

	# Personal packages
	if [[ "$INSTALL_PROFILE" == "personal" ]]; then
		packages+=(
			exiftool
			ffmpeg
			handbrake
			vlc
			yt-dlp
			# blackhole-2ch
			# mactex
			# texpad
		)
	fi

	# Install homebrew first
	if ! hash brew > /dev/null 2>&1 ; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		brew doctor
	fi

	# Make sure everything is up-to-date
	brew update > /dev/null

	# Upgrade existing packages
	brew upgrade

	# Install packages
	for package in ${packages[@]} ; do
		brew install $package
	done

	# Cleanup after install
	brew cleanup -s
)
