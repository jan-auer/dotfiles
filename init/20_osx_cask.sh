is_osx || return 0

(
	# Base casks
	casks=(
		1password
		coconutbattery
		daisydisk
		orbstack
		google-chrome
		google-drive
		iterm2
		microsoft-office
		qlimagesize
		qlprettypatch
		qlstephen
		rar
		raycast
		sonos
		tunnelblick
		visual-studio-code
		vlc
	)

	# Work casks
	casks += (
		charles
		hex-fiend
		ngrok
		#parallels
		paw
	)

	# Personal casks
	casks += (
		blackhole-2ch
		handbrake
		mactex
		texpad
		vlc
	)

	# Install the casks
	for package in ${casks[@]} ; do
		brew ls --cask $package > /dev/null 2>&1 || brew install --cask $package
	done

	# Cleanup after install
	brew cleanup -s > /dev/null
)
