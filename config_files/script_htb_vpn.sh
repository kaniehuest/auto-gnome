#!/bin/bash

ip_htb=$(/usr/bin/ip a |/usr/bin/grep tun0 | /usr/bin/grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")

if [ $? != 0 ]; then
    echo "0" > /home/lepra/.tmux/plugins/tmux-themepack/powerline/script/ipv4_htb.txt
else
    echo $ip_htb  > /home/lepra/.tmux/plugins/tmux-themepack/powerline/script/ipv4_htb.txt
fi
