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
	info "Running installer $name"
	source "$ROOT/init/$1"
	success "Installed $name"
}

function copy_file () {
	info "Copying $1"
	ensure_path "$DEST/$1"
	cp -a "$ROOT/copy/$1" "$DEST/.$1"
	success "Copied $1"
}

function link_file () {
	info "Linking $1"
	ensure_path "$DEST/$1"
	ln -sf "$ROOT/link/$1" "$DEST/.$1"
	success "Linked $1"
}

function process () {
	for file in $(cd "$ROOT/$1" && find -H . -type f) ; do
		"$1_file" "${file:2}"
	done
}

# Let's go
for job in {link,copy,init} ; do
	process $job
done

