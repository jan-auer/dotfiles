is_osx || return 0

(
	# Homebrew packages to install
	packages=(
		bat
		colordiff
		dos2unix
		fd
		fzf
		gh
		git
		git-delta
		htop
		hub
		jq
		less
		mas
		nmap
		ripgrep
		speedtest-cli
		ssh-copy-id
		tokei
		vim
		watch
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
	brew cleanup -s
)

