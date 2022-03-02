#!/bin/bash


msg(){
	echo "$(tput bold; tput setaf 2)[+] ${*}$(tput sgr0)"
}

err(){
	echo "$(tput bold; tput setaf 1)[!] ERROR: ${*}$(tput sgr0)"
}

install_yay(){
	msg "Installing yay"
	pushd /opt
	sudo git clone https://aur.archlinux.org/yay.git &>/dev/null
	sudo chown -R $user:users /opt/yay
	cd /opt/yay
	makepkg -si --noconfirm &>/dev/null
	popd
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


theme(){
	msg "Installing Orchis theme"
	packages_theme="gtk-engine-murrine
		gnome-themes-extra
		gnome-themes-standard 
		sassc"
	mkdir /home/$user/github
	pushd /home/$user/github
	git clone https://github.com/vinceliuice/Orchis-theme &>/dev/null
	cd /home/$user/github/Orchis-theme
	sudo pacman -S $packages_theme --noconfirm &>/dev/null
	sh /home/$user/github/Orchis-theme/install.sh --tweaks solid &>/dev/null
	popd
}

hack_font(){
	# To test
	mkdir /home/$1/hack-font
	pushd /home/$1/hack-font
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
	7z x Hack.zip
	sudo mkdir -p /usr/share/fonts/hack
	cp ./*ttf /usr/share/fonts/hack
	rm /home/$1/hack-font
	popd
}

zsh_configuration(){
	msg "Configuring zsh"
	yay -S --noconfirm zsh-theme-powerlevel10k-git &>/dev/null
	git clone https://github.com/zsh-users/zsh-autosuggestions /home/$user/.zsh/zsh-autosuggestions &>/dev/null
	cat $directory/zshrc > /home/$user/.zshrc
	cat $directory/alacritty.yml > /home/$user/.alacritty.yml
	mkdir -p /home/$user/.config/nvim
	cat $directory/init.vim > /home/$user/.config/nvim/init.vim
	sudo mkdir /etc/cron.minutely
	sudo cp $directory/lepra > /etc/cron.minutely
}

install_blackarch(){
	msg "Installing blackArch"
	pushd /home/$user/Descargas
	curl -O https://blackarch.org/strap.sh &>/dev/null
	sudo sh strap.sh &>/dev/null
	popd
	sudo pacman -Syu --noconfirm &>/dev/null
}

install_tools(){
	packages="base-devel
		core/net-tools
		core/linux-headers
		core/perl
		core/cronie
		core/python
		extra/xclip
		extra/htop
		extra/python-pip
		extra/python2
		extra/gtkmm3
		extra/zsh
		extra/p7zip
		extra/openvpn
		extra/nmap
		extra/tree
		extra/php
		extra/ruby
		extra/java-runtime-common
		extra/java-environment-common
		extra/mariadb
		extra/postgresql
		community/tmux
		community/neofetch
		community/alacritty
		community/cmatrix
		community/lsd
		community/dos2unix
		community/rlwrap
		community/remmina
		blackarch/nishang
		blackarch/metasploit
		blackarch/sqlmap
		blackarch/windows-binaries
		blackarch/binwalk
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
		blackarch/ysoserial"
	msg "Installing tools"
	sudo pacman -S $packages --noconfirm
	sudo pacman -Syu --noconfirm 
	msg "PortSwigger https://portswigger.net/burp/communitydownload"

	# Monkey PHP
	sudo mkdir /opt/monkey-php-shell
	pushd /opt/monkey-php-shell
	sudo wget https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/master/php-reverse-shell.php &>/dev/null
	popd
}

tmux_configuration(){
	msg "Configuring tmux"
	git clone https://github.com/tmux-plugins/tpm /home/$user/.tmux/plugins/tpm &>/dev/null
	cat $directory/tmux.conf > /home/$user/.tmux.conf
	#cat $directory/gray.tmuxtheme > /home/$user/.tmux/plugins/tmux-themepack/powerline/default/gray.tmuxtheme
	#cp $directory/script_htb_vpn.sh > /home/$user/.tmux/plugins/tmux-themepack/powerline/script/script_htb_vpn.sh
	
}

check_priv(){
	if [ "$(id -u)" == 0 ]; then
		err "You must not run this script as root user"
	fi
}

gnome_setup(){
	check_priv
	user=$(whoami)
	directory=$(pwd)
	msg "Updating packages"
	sudo pacman -Syu --noconfirm &>/dev/null
	install_yay
	delete_packages
	theme 
	zsh_configuration
	install_blackarch
	install_tools
	tmux_configuration
}

gnome_setup
