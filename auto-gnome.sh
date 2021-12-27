#!/bin/bash

function install_zsh(){
	echo "[+] Configuring alacritty"
	doas -u lepra yay -S --noconfirm zsh-theme-powerlevel10k-git &>/dev/null
	echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >> /home/$1/.zshrc
	git clone https://github.com/zsh-users/zsh-autosuggestions /home/$1/.zsh/zsh-autosuggestions
	echo "source /home/$1/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> /home/$1/.zshrc
}

function install_alacritty(){
	echo "[+] Installing alacritty"
	cd /home/$1/github
	git clone https://github.com/alacritty/alacritty.git &>/dev/null
	cd alacritty
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh &>/dev/null
	pacman -S cmake freetype2 fontconfig pkg-config make libxcb libxkbcommon python --noconfirm &>/dev/null
	echo "[!] You need to restart and run alacritty2.sh"
}

function install_tools(){
	echo "[+] PortSwigger https://portswigger.net/burp/communitydownload"
	echo "[+] Installing tools"
	cd /opt
	git clone https://github.com/danielmiessler/SecLists &>/dev/null
	git clone https://github.com/carlospolop/PEASS-ng &>/dev/null
	git clone https://gitlab.com/kalilinux/packages/windows-binaries &>/dev/null
	git clone https://github.com/samratashok/nishang.git &>/dev/null
	git clone https://github.com/sqlmapproject/sqlmap.git &>/dev/null

	# Juicy Potato
	echo "[+] Installing Juicy Potato"
	mkdir /opt/Juicy-Potato
	cd /opt/Juicy-Potato
	wget https://github.com/ohpe/juicy-potato/releases/download/v0.1/JuicyPotato.exe &>/dev/null
	cd /opt

	# Monkey PHP
	echo "[+] Installing Monkey PHP Shell"
	mkdir /opt/monkey-php-shell
	cd /opt/monkey-php-shell
	wget https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/master/php-reverse-shell.php &>/dev/null
	cd /opt

	# Impacket
	echo "[+] Installing Impacket"
	git clone https://github.com/SecureAuthCorp/impacket &>/dev/null
	cd /opt/impacket
	python3 -m pip install . &>/dev/null
	cd /opt
	
	# smbmap
	echo "[+] Installing Smbmap"
	git clone https://github.com/ShawnDEvans/smbmap.git &>/dev/null
	cd /opt/smbmap
	python3 -m pip install -r requirements.txt &>/dev/null
	cd /opt
}

function delete_packages(){
	echo "[+] Deleting packages"
	packages_to_delete="gnome-boxes gnome-books gnome-calculator gnome-calendar gnome-maps gnome-music gnome-contacts gnome-weather cheese"
	pacman -R $packages_to_delete --noconfirm &>/dev/null
}

function install_packages(){
	echo "[+] Installing packages"
	packages_to_install="xclip base-devel net-tools linux-headers open-vm-tools gtkmm3 gnome-tweaks opendoas tmux neofetch python-pip nmap cmatrix zsh p7zip wget"
	pacman -S $packages_to_install --noconfirm &>/dev/null
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
	pacman -S gtk-engine-murrine gnome-themes-extra gnome-themes-standard sassc --noconfirm &>/dev/null
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
	chown -c root:root /etc/doas.conf &>/dev/null
	chmod -c 0400 /etc/doas.conf &>/dev/null
}

function yay_install(){
	echo "[+] Installing yay"
	cd /opt
	git clone https://aur.archlinux.org/yay.git &>/dev/null
	chown -R $1:users /opt/yay
	cd /opt/yay
	doas -u $1 makepkg -si &>/dev/null

	echo "[+] Installing yay packages"
	yay_packages="librewolf brave-bin"
	doas -u lepra yay -S $yay_packages --noconfirm &>/dev/null
}

if [ "$(echo $UID)" != "0" ]; then
	echo "You must run this script as root user"
else
	echo "[+] Updating packages..."
	pacman -Syu --noconfirm &>/dev/null
	echo "Enter your username: "
	read user
	conf_doas
	yay_install $user
	install_packages
	theme $user
	dash_to_dock $user
	install_tools
	install_alacritty $user
	install_zsh $user
	delete_packages
fi
