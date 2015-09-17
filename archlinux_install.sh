#!/bin/bash

# ----------- CONFIG Variables
HOSTNAME=tkarch
USERNAME=arch
USERPASS=arch
ROOTPASS=DEhu8624
KEYBOARD=us
LOCALELC="en_CA.UTF-8"
TIMEZONE="America/Vancouver"
BOOTMNGR=grub                  # use refind for UEFI system

# user configs
#ROXLINKS=(SciTE file-roller epdfview geany geeqie gimp-2.8 inkscape vlc)
ROXLINKS=(SciTE file-roller epdfview geany)

# ----------- END of CONFIG

source 01_config.sh && \
source 02_packages.sh && \
source 03_network_dhcp.sh && \
source 04_setup_user.sh && \
source 05_user_config.sh && \
source 06_x2go.sh

systemctl enable sshd

grub-install --recheck /dev/sda
