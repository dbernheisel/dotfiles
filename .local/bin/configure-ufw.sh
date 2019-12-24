#!/bin/sh

systemctl stop iptables
systemctl disable iptables

pacman -Syy ufw
systemctl enable ufw.service
ufw enable
ufw logging on
ufw default deny incoming
ufw default allow outgoing

# Local development
ufw allow proto tcp from 192.168.86.0/24 to any port 3000
ufw allow proto tcp from 192.168.86.0/24 to any port 3001
ufw allow proto tcp from 192.168.86.0/24 to any port 3002
ufw allow proto tcp from 192.168.86.0/24 to any port 4000
ufw allow proto tcp from 192.168.86.0/24 to any port 4001

pacman -S ufw-extras

# Known apps
ufw allow ntp     # network time protocol (sync clocks)
ufw allow CIFS    # Samba/CIFS local file sharing.
ufw allow IPP     # Unix CUPS server (printers)
ufw allow Dropbox
