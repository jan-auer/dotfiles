is_osx || return 0

(
	# Homebrew packages to install
	packages=(
		bat
		cmake
		colordiff
		dos2unix
		fd
		fzf
		gh
		git
		htop
		hub
		mas
		nmap
		node
		ripgrep
		ssh-copy-id
		unrar
		vim
		watch
		watchman
		xz
		yarn
	)

	# Install homebrew first
	if ! hash brew > /dev/null 2>&1 ; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

