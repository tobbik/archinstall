#!/bin/bash

cd "$(dirname "$0")"

# ----------- CONFIG Variables
HOSTNAME=tkarch
USERNAME=arch
USERPASS=arch
GITNAME="Tobias Kieslich"
GITEMAIL="tobias.kieslich@gmail.com"
ROOTPASS=rootpass
KEYBOARD=us
LOCALELC="en_CA.UTF-8"
TIMEZONE="America/Vancouver"
BOOTMNGR=grub                  # use refind for UEFI system

# user configs
#ROXLINKS=(SciTE file-roller epdfview geany geeqie gimp-2.8 inkscape vlc)
ROXLINKS=(SciTE file-roller epdfview geany)

# ----------- END of CONFIG

source 01_config.sh \
&& source 02_packages.sh \
&& source 03_network_dhcp.sh \
&& source 04_setup_user.sh \
&& source 05_x2go.sh \
&& source 06_docker.sh \
&& source 07_vmware.sh \
&& source 08_devtools.sh \
&& source 09_graphics.sh \
&& source 10_office.sh \
&& source 11_aurstuff.sh \
&& source 20_user_config.sh

systemctl enable sshd

if [ "${BOOTMNGR}" == "grub" ]; then
	grub-install --recheck /dev/sda
	#hack for misnamed devices -> grub bug?
	grub-mkconfig -o /boot/grub/grub.cfg.mkc
	mv /boot/grub/grub.cfg.mkc /boot/grub/grub.cfg
fi
