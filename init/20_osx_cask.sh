is_osx || return 0

(
	# Casks to install
	casks=(
		1password
		atom
		dropbox
		firefox
		flux
		flycut
		google-chrome
		insync
		intel-haxm
		iterm2
		java
		mou
		osxfuse
		qlcolorcode
		qlimagesize
		qlmarkdown
		qlprettypatch
		quicklook-csv
		quicklook-json
		skype
		spotify
		teamviewer
		texpad
		vlc
	)

	# Install the casks
	for package in ${packages[@]} ; do
		brew cask ls $package > /dev/null 2>&1 || brew cask install $package
	done

	# Cleanup after install
	brew cask cleanup > /dev/null
)
