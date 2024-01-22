#!/bin/bash

#   11_aurstuff.sh   # doesn't work because it runs as root
#installation modules
# just comment out modules you don't want
# eg. exclude 30_graphics and 31_office etc for a developer VM
MODULES=(
   01_config.sh
   02_base.sh
   # 03_network_dhcp.sh
   # 03_network_netctl_static.sh
   # 03_network_netctl_auto.sh
   # 03_network_nwmngr.sh
   03_network_iwd.sh
   04_bluetooth.sh

   09_setup_user.sh

   10_display_wayland.sh
   #10_display_xorg.sh
   12_gui.sh
   #13_vmware.sh
   #14_virtualbox.sh

   #16_amd.sh
   #16_intel.sh

   20_devtools.sh
   21_dotnet.sh
   22_jdk.sh
   23_kvm.sh
   24_docker.sh
   25_datatools.sh
   29_aurstuff.sh

   30_graphics.sh
   32_media.sh
   33_audio.sh
)

# ----------- CONFIG Variables
HOSTNAME=tkarch
USERNAME=arch
USERPASS="arch"
GITNAME="Tobias Kieslich"
GITEMAIL="email address for git commits"
ROOTPASS="rootpass"
KEYBOARD=us
LOCALELC="en_CA.UTF-8"
TIMEZONE="America/Vancouver"
WL_ESSID="accesspointID"
WL_KEY="wireless_password"
INTERFACE=$(ip link | grep 'state UP' | cut -d " " -f2 | sed "s/://")
# this needs intervention; refind and grub work proper
# systemd and efistub need work; see setup-chroot.sh 
BOOTMNGR=systemd


# docker container directory - if you choose the docker package and not set
# DOCKERSTORAGEPATH the installer will create /home/${USERNAMME}/docker instead
#DOCKERSTORAGEPATH=/mnt/whatever

