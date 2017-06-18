is_osx || return 0

(
	# Casks to install
	casks=(
		1password
		atom
		betterzipql
		day-o
		dropbox
		firefox
		flycut
		franz
		google-chrome
		google-drive
		handbrake
		hyperdock
		iterm2
		java
		jetbrains-toolbox
		microsoft-office
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
		vlc
	)

	# Install the casks
	for package in ${packages[@]} ; do
		brew cask ls $package > /dev/null 2>&1 || brew cask install $package
	done

	# Cleanup after install
	brew cask cleanup > /dev/null
)
