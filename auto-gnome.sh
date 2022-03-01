#!/bin/bash


msg(){
	echo "$(tput bold; tput setaf 2)[+] ${*}$(tput sgr0)"
}

err(){
	echo "$(tput bold; tput setaf 1)[!] ERROR: ${*}$(tput sgr0)"
}

install_yay(){
	msg "Installing yay"
	cd /opt
	sudo git clone https://aur.archlinux.org/yay.git &>/dev/null
	sudo chown -R $user:users /opt/yay
	cd /opt/yay
	makepkg -si --noconfirm &>/dev/null
	msg "Installing yay packages"
	yay_packages="librewolf-bin 
		brave-bin 
		alacritty-themes"
	yay -S $yay_packages --noconfirm &>/dev/null
}

delete_packages(){
	msg "Deleting packages"
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

install_packages(){
	msg "Installing packages"
	packages_to_install="base-devel
		extra/xclip
		community/alacritty
		extra/htop
		core/python
		extra/python-pip
		extra/python2
		core/net-tools
		core/linux-headers
		extra/gtkmm3
		community/tmux
		community/neofetch
		community/cmatrix
		extra/zsh
		extra/wget
		extra/p7zip
		extra/openvpn
		community/lsd
		extra/tree"
	sudo pacman -S $packages_to_install --noconfirm &>/dev/null
}

install_go(){
	cd /home/$user/Descargas
	wget https://go.dev/dl/go1.17.5.linux-amd64.tar.gz &>/dev/null
	tar xvzf go1.17.5.linux-amd64.tar.gz &>/dev/null
	sudo mv go /usr/local
	export PATH=$PATH:/usr/local/go/bin
	source $HOME/.bash_profile
}

theme(){
	msg "Installing Orchis theme"
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

hack_font(){
	# To test
	mkdir /home/$1/hack-font
	cd /home/$1/hack-font
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
	7z x Hack.zip
	sudo mkdir -p /usr/share/fonts/hack
	cp ./*ttf /usr/share/fonts/hack
	rm /home/$1/hack-font
}

zsh_configuration(){
	msg "Configuring zsh"
	yay -S --noconfirm zsh-theme-powerlevel10k-git &>/dev/null
	echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >> /home/$user/.zshrc
	git clone https://github.com/zsh-users/zsh-autosuggestions /home/$user/.zsh/zsh-autosuggestions &>/dev/null
	echo "source /home/$user/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> /home/$user/.zshrc
}

install_blackarch(){
	msg "Installing blackArch"
	cd /home/$user/Descargas
	curl -O https://blackarch.org/strap.sh &>/dev/null
	sudo sh strap.sh &>/dev/null
	sudo pacman -Syy &>/dev/null
	sudo pacman -Syu --noconfirm &>/dev/null
}

install_tools(){
	tools_packages="blackarch/nishang
	core/perl
	extra/php
	extra/ruby
	extra/java-runtime-common
	extra/java-environment-common
	extra/mariadb
	extra/postgresql
	blackarch/metasploit
	blackarch/sqlmap
	blackarch/windows-binaries
	community/dos2unix
	blackarch/binwalk
	community/rlwrap
	community/remmina
	blackarch/radare2
	blackarch/evil-winrm
	blackarch/peass
	blackarch/seclists
	blackarch/juicy-potato
	blackarch/impacket
	blackarch/smbmap
	blackarch/john
	blackarch/hashcat
	blackarch/hashcat-utils
	blackarch/cewl
	blackarch/chisel
	blackarch/responder
	blackarch/sherlock
	blackarch/socat
	blackarch/wireshark-qt
	blackarch/wireshark-cli
	blackarch/whatweb
	blackarch/nikto
	blackarch/burpsuite
	blackarch/wfuzz
	blackarch/gobuster
	blackarch/tcpdump
	blackarch/steghide
	extra/nmap
	blackarch/ysoserial"
	msg "Installing tools"
	sudo pacman -Syu --noconfirm 
	sudo pacman -S $tools_packages --noconfirm

	msg "PortSwigger https://portswigger.net/burp/communitydownload"

	# Monkey PHP
	cd /opt
	sudo mkdir /opt/monkey-php-shell
	cd /opt/monkey-php-shell
	sudo wget https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/master/php-reverse-shell.php &>/dev/null
}

check_priv(){
	if [ "$(id -u)" == 0 ]; then
		err "You must not run this script as root user"
	fi
}

gnome_setup(){
	check_priv
	msg "Enter your username: "
	read user
	msg "Updating packages"
	sudo pacman -Syu --noconfirm &>/dev/null
	install_yay
	delete_packages
	install_packages
	install_go
	theme 
	zsh_configuration
	install_blackarch
	install_tools
}

gnome_setup
