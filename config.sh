#!/bin/bash

# installation modules
# just comment out modules you don't want
# eg. exclude 30_graphics and 31_office etc for a developer VM
MODULES=(
   01_network.sh
   02_config.sh
   03_base.sh
   04_bluetooth.sh

   05_bootmgr.sh

   07_dev.sh
   07_dev_aur.sh

   09_amd.sh
   #09_intel.sh
   #09_x13s.sh
   #09_rpi4.sh
   #09_opi5.sh

   10_display_wayland.sh
   #10_display_xorg.sh
   11_desktop_labwc_aur.sh
   #11_desktop_wayfire_aur.sh

   12_gui.sh
   12_gui_aur.sh

   13_office.sh
   13_office_aur.sh

   20_dev_gui.sh
   20_dev_gui_aur.sh
   21_dotnet.sh
   22_jdk.sh
   23_kvm.sh
   24_docker.sh
   #25_virtualbox.sh
   #26_vmware.sh
   27_datatools.sh
   29_osm_aur.sh

   30_graphics.sh
   32_media.sh
   33_audio.sh
)

# installer variables
DISKBASEDEVPATH=/dev/nvme0n1
DISKPARTNAME="p"                       # so it composes /dev/nvme0n1p2; for /dev/sda2 set PARTNAME=""
DISKBOOTDEVPATH=${DISKBASEDEVPATH}${DISKPARTNAME}1
DISKROOTDEVPATH=${DISKBASEDEVPATH}${DISKPARTNAME}2
DISKHOMEDEVPATH=${DISKBASEDEVPATH}${DISKPARTNAME}3
DISKSWAPDEVPATH=${DISKBASEDEVPATH}${DISKPARTNAME}4

PACMANEXTRAFLAGS=""    # --disable-download-timeout for bad connections

# if set, it will attempt to put that on top of the /etc/pacman.d/mirrorlist file
# PACMANPRIMARYPKGSERVER="Server = http://mylocalcache:8765/pkg"

# ----------- CONFIG Variables
HOSTNAME=machinename
USERNAME=arch
USERPASS="arch"
GITNAME="Your Fullname"
GITEMAIL="email.address@for.git.commits"
ROOTPASS="PassForRoot"
KEYMAP=us
LOCALELC="en_CA.UTF-8"
LOCALECOLLATE="C.UTF-8"
LOCALEFALLBACK="en_CA:en_GB:en"
TIMEZONE="America/Vancouver"
TIMESTAMP=$(date -Iseconds)
# pipewire has some trouble on smaller SBCs such as Orange Pi
AUDIOSYSTEM="pipewire"   # pipewire | pulseaudio
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

