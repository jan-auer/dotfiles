is_osx || return 0

(
	# Base casks
	casks=(
		1password
		claude-code
		coconutbattery
		daisydisk
		firefox
		google-chrome
		google-drive
		iterm2
		microsoft-office
		orbstack
		pronotes
		rar
		raycast
		sonos
		utm
		visual-studio-code
		whatsapp
		yubico-yubikey-manager
	)

	# Work casks
	casks += (
		hex-fiend
		ngrok
	)

	# Personal casks
	casks += (
		handbrake
		vlc
		# blackhole-2ch
		# mactex
		# texpad
	)

	# Install the casks
	for package in ${casks[@]} ; do
		brew ls --cask $package > /dev/null 2>&1 || brew install --cask $package
	done

	# Cleanup after install
	brew cleanup -s > /dev/null
)
