is_osx || return 0

# this has to be separate, as it requires brew cask osxfuse
if ! brew ls homebrew/fuse/ntfs-3g > /dev/null 2>&1 ; then
	brew install homebrew/fuse/ntfs-3g

	# automatically mount NTFS drives in Finder
	sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.original
	sudo ln -s /usr/local/sbin/mount_ntfs /sbin/mount_ntfs
fi

