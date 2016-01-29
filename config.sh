#!/bin/bash

#   11_aurstuff.sh   # doesn't work because it runs as root
#installation modules
# just delete modules you don't like
# eg. remove 09_graphics and 10_office for a developer VM
MODULES=(
   01_config.sh
   02_packages.sh
   03_network_dhcp.sh
   04_setup_user.sh
   05_x2go.sh
   06_docker.sh
   07_vmware.sh
   08_devtools.sh
   09_graphics.sh
   10_office.sh
   20_user_config.sh
)

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
BOOTMNGR=grub                  # use refind-efi for UEFI system

# user configs
#ROXLINKS=(SciTE file-roller epdfview geany geeqie gimp-2.8 inkscape vlc)
ROXLINKS=(SciTE file-roller epdfview geany)
# ----------- END of CONFIG
