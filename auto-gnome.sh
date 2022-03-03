#!/bin/bash

msg(){
	echo "$(tput bold; tput setaf 2)[+] ${*}$(tput sgr0)"
}

err(){
	echo "$(tput bold; tput setaf 1)[!] ERROR: ${*}$(tput sgr0)"
}

warn(){
	echo -e "$(tput bold; tput setaf 3)${*}$(tput sgr0)"
}

banner(){
	tput bold; tput setaf 1
    	cat << EOF
     _______  __   __  _______  _______         _______  __    _  _______  __   __  _______ 
    |   _   ||  | |  ||       ||       |       |       ||  |  | ||       ||  |_|  ||       |
    |  |_|  ||  | |  ||_     _||   _   | ____  |    ___||   |_| ||   _   ||       ||    ___|
    |       ||  |_|  |  |   |  |  | |  ||____| |   | __ |       ||  | |  ||       ||   |___ 
    |       ||       |  |   |  |  |_|  |       |   ||  ||  _    ||  |_|  ||       ||    ___|
    |   _   ||       |  |   |  |       |       |   |_| || | |   ||       || ||_|| ||   |___ 
    |__| |__||_______|  |___|  |_______|       |_______||_|  |__||_______||_|   |_||_______|
    :)
EOF
    	tput sgr0
}

tmux_configuration(){
	msg "Configuring tmux"
	git clone https://github.com/tmux-plugins/tpm /home/$user/.tmux/plugins/tpm &>/dev/null
	cat $directory/tmux.conf > /home/$user/.tmux.conf
}

zsh_configuration(){
	msg "Configuring zsh"
	git clone https://github.com/zsh-users/zsh-autosuggestions /home/$user/.zsh/zsh-autosuggestions &>/dev/null
	cat $directory/zshrc > /home/$user/.zshrc
	cat $directory/alacritty.yml > /home/$user/.alacritty.yml
	mkdir -p /home/$user/.config/nvim
	cat $directory/init.vim > /home/$user/.config/nvim/init.vim
}

install_yay(){
	msg "Installing yay"
	sudo pacman -S base-devel
	pushd /opt &>/dev/null
	sudo git clone https://aur.archlinux.org/yay.git &>/dev/null
	sudo chown -R $user:users /opt/yay
	cd /opt/yay
	makepkg -si --noconfirm &>/dev/null
	popd &>/dev/null
	msg "Installing yay packages"
	yay_packages="librewolf-bin 
		brave-bin 
		zsh-theme-powerlevel10k-git
		alacritty-themes"
	yay -S $yay_packages --noconfirm &>/dev/null
}

install_tools(){
	packages="core/man-db
		core/man-pages
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
	sudo pacman -S $packages --noconfirm &>/dev/null
	sudo pacman -Syu --noconfirm  &>/dev/null

	# Monkey PHP
	sudo mkdir /opt/monkey-php-shell
	pushd /opt/monkey-php-shell &>/dev/null
	sudo wget https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/master/php-reverse-shell.php &>/dev/null
	popd &>/dev/null
}

install_blackarch(){
	msg "Installing blackArch"
	pushd /home/$user/Descargas &>/dev/null
	curl -O https://blackarch.org/strap.sh &>/dev/null
	sudo sh strap.sh &>/dev/null
	popd &>/dev/null
	sudo pacman -Syu --noconfirm &>/dev/null
}

theme(){
	msg "Installing Orchis theme"
	packages_theme="gtk-engine-murrine
		gnome-themes-extra
		gnome-themes-standard 
		sassc"
	mkdir /home/$user/github
	pushd /home/$user/github &>/dev/null
	git clone https://github.com/vinceliuice/Orchis-theme &>/dev/null
	cd /home/$user/github/Orchis-theme
	sudo pacman -S $packages_theme --noconfirm &>/dev/null
	sh /home/$user/github/Orchis-theme/install.sh --tweaks solid &>/dev/null
	popd &>/dev/null
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

check_priv(){
	if [ "$(id -u)" == 0 ]; then
		err "You must not run this script as root user"
		tput cnorm
	fi
}

gnome_setup(){
	tput civis
    	banner
	check_priv
	user=$(whoami)
	directory=$(pwd)
	msg "Updating packages"
	sudo pacman -Syu --noconfirm &>/dev/null
	delete_packages
	theme 
	install_blackarch
	install_tools
	install_yay
	zsh_configuration
	tmux_configuration
    	sudo usermod -s /usr/bin/zsh lepra
	warn "\n\t\t[!] START TMUX AND PRESS \"PREFIX + I\"  [!]"
	warn "\t\t[!] AND EXECUTE THE FOLLOWING COMMANDS [!]\n"
	warn "cat $directory/gray.tmuxtheme > /home/$user/.tmux/plugins/tmux-themepack/powerline/default/gray.tmuxtheme\n"
	warn "mkdir /home/$user/.tmux/plugins/tmux-themepack/powerline/script/\n"
    	warn "cp $directory/script_htb_vpn.sh /home/$user/.tmux/plugins/tmux-themepack/powerline/script/script_htb_vpn.sh\n"
    	warn "\n\t\t[!] WRITE THE FOLLOWING IN \"/etc/cron.d\" [!]\n"
    	warn "* * * * * /usr/bin/bash /home/lepra/.tmux/plugins/tmux-themepack/powerline/script/script_htb_vpn.sh"
	tput cnorm
}

gnome_setup
