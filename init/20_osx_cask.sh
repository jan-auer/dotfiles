is_osx || return 0

(
	# Casks to install
	casks=(
		1password
		charles
		coconutbattery
		daisydisk
	  docker
		dropbox
		encryptme
		eul
		firefox
		flycut
		glance
		google-chrome
		handbrake
		hex-fiend
		iterm2
		java
		jiggler
		kap
		microsoft-office
		ngrok
		parallels
		paw
		qlimagesize
		qlprettypatch
		qlstephen
		qlvideo
		skype
		sonos
		spotify
		texpad
		viscosity
		visual-studio-code
		vlc
		wireshark
	)

	# Install the casks
	for package in ${casks[@]} ; do
		brew cask ls $package > /dev/null 2>&1 || brew cask install $package
	done

	# Cleanup after install
	brew cask cleanup > /dev/null
)
