#!/bin/bash

#   11_aurstuff.sh   # doesn't work because it runs as root
#installation modules
# just comment out modules you don't want
# eg. exclude 09_graphics and 10_office for a developer VM
MODULES=(
   01_config.sh
   02_base.sh
   03_network_dhcp.sh
   #03_network_netctl_static.sh
   03_network_netctl_auto.sh

   09_setup_user.sh

   10_xorg.sh
   11_xfce4.sh
   12_lightdm.sh
   #13_vmware.sh
   #14_virtualbox.sh
   15_x2go.sh

   20_devtools.sh
   21_datatools.sh
   22_docker.sh
   #25_aurstuff.sh
   26_jdk.sh

   #30_graphics.sh
   #31_office.sh
   #32_media.sh
)

# ----------- CONFIG Variables
HOSTNAME=tkarch
USERNAME=arch
USERPASS=arch
GITNAME="Tobias Kieslich"
GITEMAIL="email address for git commits"
ROOTPASS=rootpass
KEYBOARD=us
LOCALELC="en_CA.UTF-8"
TIMEZONE="America/Vancouver"
WL_ESSID="accesspointID"
WL_KEY="wireless_password"
INTERFACE=$(ip link | grep 'state UP' | cut -d " " -f2 | sed "s/://")
BOOTMNGR=refind-efi                  # use "refind-efi" for UEFI system
                                     # use "grub" for Legacy systems or VM-Ware

# user configs
#ROXLINKS=(SciTE file-roller epdfview geany geeqie gimp-2.8 inkscape vlc)
ROXLINKS=(file-roller epdfview geany)
# ----------- END of CONFIG

# docker container directory - if you choose the docker package and not set
# DOCKERSTORAGEPATH the installer will create /home/${USERNAMME}/docker instead
#DOCKERSTORAGEPATH=/mnt/whatever

