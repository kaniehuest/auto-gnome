#!/bin/bash

function install_alacritty(){
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

function install_zsh(){
	echo "[+] Configuring alacritty"
	yay -S --noconfirm zsh-theme-powerlevel10k-git &>/dev/null
	echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >> /home/$1/.zshrc
	git clone https://github.com/zsh-users/zsh-autosuggestions /home/$1/.zsh/zsh-autosuggestions
	echo "source /home/$1/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> /home/$1/.zshrc
}

function install_tools(){
	echo "[+] PortSwigger https://portswigger.net/burp/communitydownload"
	echo "[+] Installing tools"
	cd /opt
	sudo git clone https://github.com/danielmiessler/SecLists &>/dev/null
	sudo git clone https://github.com/carlospolop/PEASS-ng &>/dev/null
	sudo git clone https://gitlab.com/kalilinux/packages/windows-binaries &>/dev/null
	sudo git clone https://github.com/samratashok/nishang.git &>/dev/null
	sudo git clone https://github.com/sqlmapproject/sqlmap.git &>/dev/null

	# Juicy Potato
	echo "[+] Installing Juicy Potato"
	sudo mkdir /opt/Juicy-Potato
	cd /opt/Juicy-Potato
	sudo wget https://github.com/ohpe/juicy-potato/releases/download/v0.1/JuicyPotato.exe &>/dev/null

	# Monkey PHP
	echo "[+] Installing Monkey PHP Shell"
	cd /opt
	sudo mkdir /opt/monkey-php-shell
	cd /opt/monkey-php-shell
	sudo wget https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/master/php-reverse-shell.php &>/dev/null

	# Impacket
	echo "[+] Installing Impacket"
	cd /opt
	sudo git clone https://github.com/SecureAuthCorp/impacket &>/dev/null
	cd /opt/impacket
	python3 -m pip install . &>/dev/null
	sudo python3 -m pip install . &>/dev/null
	
	# smbmap
	echo "[+] Installing Smbmap"
	cd /opt
	sudo git clone https://github.com/ShawnDEvans/smbmap.git &>/dev/null
	cd /opt/smbmap
	python3 -m pip install -r requirements.txt &>/dev/null
	sudo python3 -m pip install -r requirements.txt &>/dev/null
}

function delete_packages(){
	echo "[+] Deleting packages"
	packages_to_delete="gnome-boxes gnome-books gnome-calculator gnome-calendar gnome-maps gnome-music gnome-contacts gnome-weather cheese"
	sudo pacman -R $packages_to_delete --noconfirm &>/dev/null
}

function install_packages(){
	echo "[+] Installing packages"
	packages_to_install="xclip base-devel net-tools linux-headers open-vm-tools gtkmm3 gnome-tweaks opendoas tmux neofetch python-pip nmap cmatrix zsh p7zip wget"
	sudo pacman -S $packages_to_install --noconfirm &>/dev/null

	echo "[+] Installing yay packages"
	yay_packages="librewolf brave-bin"
	yay -S $yay_packages --noconfirm &>/dev/null
}


function dash_to_dock() {
	echo "[+] Installing Dash to Dock"
	mkdir /home/$1/dash-to-dock
	cd /home/$1/dash-to-dock
	wget https://extensions.gnome.org/extension-data/dash-to-dockmicxgx.gmail.com.v71.shell-extension.zip &>/dev/null
	mkdir -p /home/$1/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com
	7z x dash-to-dockmicxgx.gmail.com.v71.shell-extension.zip &>/dev/null
	cp -r /home/$1/dash-to-dock/* /home/$1/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com &>/dev/null
	rm -r /home/$1/dash-to-dock
}

function theme(){
	mkdir /home/$1/github
	cd /home/$1/github

	echo "[+] Installing Orchis theme"
	git clone https://github.com/vinceliuice/Orchis-theme &>/dev/null
	cd /home/$1/github/Orchis-theme
	sudo pacman -S gtk-engine-murrine gnome-themes-extra gnome-themes-standard sassc --noconfirm &>/dev/null
	./install.sh --tweaks solid &>/dev/null

	echo "[+] Installing Kora icons"
	cd /home/$1/github
	git clone https://github.com/bikass/kora.git &>/dev/null
	cd /home/$1/github/kora
	mkdir -p /home/$1/.local/share/icons
	cp -r /home/$1/github/kora/kora* /home/$1/.local/share/icons
}

function conf_doas(){
	echo "[+] Editing doas.conf"
	echo "permit :wheel" > /etc/doas.conf
	echo "permit :root" >> /etc/doas.conf
	sudo chown -c root:root /etc/doas.conf &>/dev/null
	sudo chmod -c 0400 /etc/doas.conf &>/dev/null
}

function install_go(){
	mkdir /home/$1/temporal
	cd /home/$1/temporal
	wget https://go.dev/dl/go1.17.5.linux-amd64.tar.gz &>/dev/null
	tar xvzf go1.17.5.linux-amd64.tar.gz &>/dev/null
	sudo mv go /usr/local
	export PATH=$PATH:/usr/local/go/bin
	source $HOME/.bash_profile
}

function install_yay(){
	echo "[+] Installing yay"
	cd /opt
	sudo git clone https://aur.archlinux.org/yay.git &>/dev/null
	sudo chown -R $1:users /opt/yay
	cd /opt/yay
	makepkg -si &>/dev/null
}

if [ "$(echo $UID)" == "0" ]; then
	echo "You must not run this script as root user"
else
	echo "Enter your username: "
	read user

	echo "[+] Updating packages..."
	sudo pacman -Syu --noconfirm &>/dev/null

	install_go $user
	install_packages
	delete_packages
	conf_doas
	install_yay $user
	theme $user
	dash_to_dock $user
	install_tools
	install_zsh $user
	install_alacritty $user
fi
