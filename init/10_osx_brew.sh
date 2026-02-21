is_osx || return 0

(
	# Base packages
	packages=(
		bat
		docker
		fd
		fzf
		gh
		git
		git-delta
		hub
		jq
		less
		mas
		ripgrep
		vim
		tokei
		watch
	)

	# Work packages
	packages += (
		colordiff
		dos2unix
		getsentry/tools/sentry-cli
		htop
		nmap
	)

	# Personal packages
	packages += (
		exiftool
		ffmpeg
		yt-dlp
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

