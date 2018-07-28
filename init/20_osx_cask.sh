is_osx || return 0

(
	# Casks to install
	casks=(
		1password
		betterzipql
		charles
		coconutbattery
		daisydisk
		day-o
	  docker
		dropbox
		firefox
		flycut
		google-chrome
		google-drive
		handbrake
		hex-fiend
		iterm2
		java
		ngrok
		qlimagesize
		qlmarkdown
		qlprettypatch
		qlstephen
		qlvideo
		quicklook-csv
		quicklook-json
		skype
		spotify
		teamviewer
		texpad
		tunnelblick
		visual-studio-code
		vlc
	)

	# Install the casks
	for package in ${casks[@]} ; do
		brew cask ls $package > /dev/null 2>&1 || brew cask install $package
	done

	# Cleanup after install
	brew cask cleanup > /dev/null
)
