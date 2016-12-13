is_osx || return 0

(
	# Casks to install
	casks=(
		1password
		android-studio
		atom
		dropbox
		firefox
		flux
		flycut
		franz
		google-chrome
		insync
		intel-haxm
		iterm2
		java
		jetbrains-toolbox
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
