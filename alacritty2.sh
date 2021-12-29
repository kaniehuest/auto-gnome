#!/bin/bash


function alacritty_install(){
        echo "[+] Installing alacritty"
        sudo pacman -S cmake freetype2 fontconfig pkg-config make libxcb libxkbcommon python --noconfirm &>/dev/null
	mkdir /home/$1/github
        cd /home/$1/github
        git clone https://github.com/alacritty/alacritty.git &>/dev/null
        cd /home/$1/github/alacritty
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        source $HOME/.cargo/env
	cd /home/$1/github/alacritty
	cargo build --release
	sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
	sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
	sudo desktop-file-install extra/linux/Alacritty.desktop
	sudo update-desktop-database
}

echo "Enter your username:"
read user
alacritty_install2 $user
