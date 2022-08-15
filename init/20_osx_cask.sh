is_osx || return 0

(
	# Casks to install
	casks=(
		1password
		1password-cli
		blackhole-2ch
		#charles
		coconutbattery
		daisydisk
		docker
		dozer
		flycut
		glance
		google-chrome
		google-drive
		handbrake
		hex-fiend
		iterm2
		kap
		#mactex
		microsoft-office
		ngrok
		#parallels
		#paw
		qlimagesize
		qlprettypatch
		qlstephen
		qlvideo
		rectangle
		homebrew/cask-drivers/sonos
		spotify
		#texpad
		viscosity
		visual-studio-code
		vlc
	)

	# Install the casks
	for package in ${casks[@]} ; do
		brew ls --cask $package > /dev/null 2>&1 || brew install --cask $package
	done

	# Cleanup after install
	brew cleanup -s > /dev/null
)
