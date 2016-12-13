is_osx || return 0

(
	# Homebrew packages to install
	packages=(
		android-sdk
		caskroom/cask/brew-cask
		cmake
		colordiff
		dos2unix
		git
		node
		optipng
		ssh-copy-id
		thefuck
		tmux
		tree
		vim
		watch
		wget
		xz
		yarn
	)

	# Install homebrew first
	if ! hash brew > /dev/null 2>&1 ; then
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		brew doctor
	fi

	# Make sure everything is up-to-date
	brew update > /dev/null

	# Upgrade existing packages
	brew upgrade

	# Install the packages
	for package in ${packages[@]} ; do
		brew ls $package > /dev/null 2>&1 || brew install $package
	done

	# Cleanup after install
	brew prune
	brew cleanup
)

