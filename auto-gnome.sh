#!/bin/bash

function install_yay(){
	echo "[+] Installing yay"
	cd /opt
	sudo git clone https://aur.archlinux.org/yay.git &>/dev/null
	sudo chown -R $user:users /opt/yay
	cd /opt/yay
	makepkg -si --noconfirm &>/dev/null
	echo "[+] Installing yay packages"
	yay_packages="librewolf-bin 
		brave-bin 
		alacritty-themes"
	yay -S $yay_packages --noconfirm &>/dev/null
}

function delete_packages(){
	echo "[+] Deleting packages"
	packages_to_delete="gnome-boxes 
		gnome-books 
		gnome-calculator
		gnome-calendar 
		gnome-maps 
		gnome-music 
		gnome-contacts 
		gnome-weather 
		cheese"
	sudo pacman -R $packages_to_delete --noconfirm &>/dev/null
}

function install_packages(){
	echo "[+] Installing packages"
	packages_to_install="xclip
		python
		python-pip 
		base-devel 
		net-tools 
		linux-headers
		gtkmm3 
		gnome-tweaks 
		tmux
		neofetch
		cmatrix 
		zsh
		p7zip
		wget 
		alacritty 
		openvpn
		tree
		lsd"
	sudo pacman -S $packages_to_install --noconfirm &>/dev/null
}

function install_go(){
	cd /home/$user/Descargas
	wget https://go.dev/dl/go1.17.5.linux-amd64.tar.gz &>/dev/null
	tar xvzf go1.17.5.linux-amd64.tar.gz &>/dev/null
	sudo mv go /usr/local
	export PATH=$PATH:/usr/local/go/bin
	source $HOME/.bash_profile
}

function theme(){
	echo "[+] Installing Orchis theme"
	packages_theme="gtk-engine-murrine
		gnome-themes-extra
		gnome-themes-standard 
		sassc"
	mkdir /home/$user/github
	cd /home/$user/github
	git clone https://github.com/vinceliuice/Orchis-theme &>/dev/null
	cd /home/$user/github/Orchis-theme
	sudo pacman -S $packages_theme --noconfirm &>/dev/null
	sh /home/$user/github/Orchis-theme/install.sh --tweaks solid &>/dev/null
}

function hack_font(){
	# To test
	mkdir /home/$1/hack-font
	cd /home/$1/hack-font
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
	7z x Hack.zip
	sudo mkdir -p /usr/share/fonts/hack
	cp ./*ttf /usr/share/fonts/hack
	rm /home/$1/hack-font
}

function zsh_configuration(){
	echo "[+] Configuring zsh"
	yay -S --noconfirm zsh-theme-powerlevel10k-git &>/dev/null
	echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >> /home/$user/.zshrc
	git clone https://github.com/zsh-users/zsh-autosuggestions /home/$user/.zsh/zsh-autosuggestions &>/dev/null
	echo "source /home/$user/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> /home/$user/.zshrc
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
	
	# smbmap
	echo "[+] Installing Smbmap"
	cd /opt
	sudo git clone https://github.com/ShawnDEvans/smbmap.git &>/dev/null
	cd /opt/smbmap
	python3 -m pip install -r requirements.txt &>/dev/null
}


if [ "$(echo $UID)" == "0" ]; then
	echo "You must not run this script as root user"
else
	echo "Enter your username: "
	read user
	echo "[+] Updating packages..."
	sudo pacman -Syu --noconfirm &>/dev/null
	install_yay
	delete_packages
	install_packages
	install_go
	theme 
	zsh_configuration
	#install_tools
fi
