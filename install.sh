#!/usr/bin/env zsh
set -e

# Pretty printing

info () {
	printf "  [ \033[00;34m..\033[0m ] $1"
}

user () {
	printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success () {
	printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

warn () {
	printf "\r\033[2K  [ \033[00;33mWARN\033[0m ] $1\n"
}

skip () {
	printf "\r\033[2K  [ \033[00;33mSKIP\033[0m ] $1\n"
}

fail () {
	printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
	echo ''
	exit
}

# OS detection

function is_osx () {
	[[ "$OSTYPE" =~ ^darwin ]] || return 1
}

function is_linux () {
	[[ "$OSTYPE" == "linux-gnu" ]] || return 1
}

function is_cygwin () {
	[[ "$OSTYPE" == "cygwin" ]] || return 1
}

function is_ubuntu () {
	[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1
}

function get_os () {
	for os in osx ubuntu linux cygwin; do
		is_$os; [[ $? == ${1:-0} ]] && echo $os
	done
}

# Helpers

function ensure_path () {
	mkdir -p "$(dirname "$1")"
}

# Installation Process

ROOT=$(dirname $0:A)
DEST="$HOME"

function init_file () {
	local name="$(basename "$1")"
	info "Running installer $name\n"
	source "$ROOT/init/$1"
		success "Installed $name" ||
		fail "Installer $name completed with errors"
}

function copy_file () {
	local src="$ROOT/copy/$1"
	local dst="$DEST/.$1"
	ensure_path "$dst"

	if [ -f "$dst" ]; then
		if diff -q "$src" "$dst" > /dev/null 2>&1; then
			skip "$1 (unchanged)"
			return
		fi
		echo ""
		diff -u "$dst" "$src" || true
		user "Overwrite ~/.$1? (y/n)"
		read -r overwrite
		if [[ "$overwrite" != y* ]]; then
			skip "$1 (kept local version)"
			return
		fi
	fi

	cp -a "$src" "$dst" && success "Copied $1" || fail "Copying $1 failed"
}

function link_file () {
	info "Linking $1"
	ensure_path "$DEST/$1"
	ln -sf "$ROOT/link/$1" "$DEST/.$1" && success "Linked $1" || fail "Linking $1 failed"
}

function process () {
	for file in $(cd "$ROOT/$1" && find -H . -type f | sort) ; do
		"$1_file" "${file:2}"
	done
}

# Let's go
if [[ -z "$INSTALL_PROFILE" ]]; then
	user "Install profile - (p)ersonal or (w)ork?"
	read -r install_profile
	case "$install_profile" in
		p*|P*) export INSTALL_PROFILE="personal" ;;
		w*|W*) export INSTALL_PROFILE="work" ;;
		*)     fail "Unknown install profile: $install_profile" ;;
	esac
fi
success "Using $INSTALL_PROFILE profile"

for job in {link,copy,init} ; do
	process $job
done

