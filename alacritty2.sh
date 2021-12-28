#!/bin/bash


function alacritty_install(){
	cd /home/lepra/github/alacritty
	cargo build --release

	cp target/release/alacritty /usr/local/bin
	cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
	desktop-file-install extra/linux/Alacritty.desktop
	update-desktop-database
}

if [ "$(echo $UID)" != "0" ]; then
	echo "You must run this script as root user"
else
	echo "Enter your username: "
	read user
	alacritty_install
fi

