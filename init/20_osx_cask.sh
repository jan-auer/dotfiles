is_osx || return 0

(
	# Casks to install
	casks=(
		1password
		atom
		clion
		djview
		dropbox
		evernote
		firefox
		flux
		flycut
		goofy
		hipchat
		inkscape
		insync
		intellij-idea
		istumbler
		iterm2
		java
		jdownloader
		mou
		osxfuse
		phpstorm
		pycharm
		qlcolorcode
		qlimagesize
		qlmarkdown
		qlprettypatch
		quicklook-csv
		quicklook-json
		skype
		speak
		spotify
		teamviewer
		texpad
		vagrant
		vlc
		webstorm
	)

	# Install the casks
	for package in ${packages[@]} ; do
		brew cask ls $package > /dev/null 2>&1 || brew cask install $package
	done

	# Cleanup after install
	brew cask cleanup > /dev/null
)
