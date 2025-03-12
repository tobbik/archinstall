#!/bin/bash

#installation modules
# just comment out modules you don't want
# eg. exclude 30_graphics and 31_office etc for a developer VM
MODULES=(
   01_config.sh
   02_base.sh
   03_network.sh
   04_bluetooth.sh

   07_dev_base.sh
   08_bootmgr.sh

   10_display_wayland.sh
   10_display_labwc_aur.sh
   #10_display_wayfire_aur.sh
   #10_display_xorg.sh

   11_amd.sh
   #11_intel.sh
   #11_x13s.sh
   #11_rpi4.sh
   #11_opi5.sh

   12_gui.sh
   13_office.sh
   #14_virtualbox.sh
   #15_vmware.sh

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

# installer variables
DISKNAME=/dev/nvme0n1
PARTNAME="p"                       # so it composes /dev/nvme0n1p2; for /dev/sda2 set PARTNAME=""
DISKROOT=${DISKNAME}${PARTNAME}2   # used to tell the boot loader; NOT used for partitions
                                   # see partition.sh instead

# ----------- CONFIG Variables
HOSTNAME=machinename
USERNAME=arch
USERPASS="arch"
GITNAME="Your Fullname"
GITEMAIL="email.address@for.git.commits"
ROOTPASS="PassForRoot"
KEYBOARD=us
LOCALELC="en_CA.UTF-8"
LOCALECOLLATE="C.UTF-8"
LOCALEFALLBACK="en_CA:en_GB:en"
TIMEZONE="America/Vancouver"
TIMESTAMP=$(date -Iseconds)
NETWORKTYPE="wlan"   # wlan | ether | both

# microcode selection
MICROCODE="intel"    # amd | intel

# this needs intervention; refind and grub work proper
# systemd, xbootldr and efistub need work; see setup-chroot.sh
BOOTMNGR=systemd     # systemd | xbootldr | efistub | refind | grub

# docker container directory - if you choose the docker package and not set
# DOCKERSTORAGEPATH the installer will create /home/${USERNAME}/docker instead
#DOCKERSTORAGEPATH=/mnt/whatever
#
AURBUILDDIR="/home/${USERNAME}/pkgs"

