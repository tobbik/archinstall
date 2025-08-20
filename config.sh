#!/bin/bash

RUNDIR=$(pwd)

# installation modules
# just comment out modules you don't want
MODULES=(
   01_network.sh
   02_config.sh
   03_base.sh
   04_bluetooth.sh
   07_dev.sh
   08_media.sh

   09_amd.sh
   #09_intel.sh
   #09_x13s.sh
   #09_rpi4.sh
   #09_opi5.sh

   10_display_wayland.sh
   #10_display_xorg.sh
   11_desktop_labwc.sh
   11_desktop_hyprland.sh
   11_desktop_niri.sh
   #11_desktop_wayfire.sh

   12_gui.sh
   13_office.sh

   #14_arm_widevine.sh

   20_dev_extra.sh
   21_dotnet.sh
   22_jdk.sh
   23_kvm.sh
   24_docker.sh
   #25_virtualbox.sh
   #26_vmware.sh
   27_datatools.sh
   28_network_extra.sh
   29_osm.sh

   30_graphics.sh
   32_media_extra.sh
   33_audio.sh

   #40_router.sh
   #41_pacoloco.sh

   # boot manager setup
   99_bootmgr.sh
)

# installer variables
DISKBASEDEVPATH=/dev/nvme0n1
DISKPARTNAME="p"                       # composes /dev/nvme0n1p2; for /dev/sda2 set PARTNAME=""
DISKBOOTDEVPATH=${DISKBASEDEVPATH}${DISKPARTNAME}1
DISKROOTDEVPATH=${DISKBASEDEVPATH}${DISKPARTNAME}2
DISKHOMEDEVPATH=${DISKBASEDEVPATH}${DISKPARTNAME}3
DISKSWAPDEVPATH=${DISKBASEDEVPATH}${DISKPARTNAME}4
# if using xbootldr partition
#DISKBOOTDEVPATH=${DISKBASEDEVPATH}${DISKPARTNAME}5
#DISKESPDEVPATH=${DISKBASEDEVPATH}${DISKPARTNAME}1

PACMANEXTRAFLAGS=""    # --disable-download-timeout for bad connections
# if set, it will use a pacoloco server to fetch cached packages
#PACOLOCOCACHESERVER='http://localhost:9129/repo/archlinux/$repo/os/$arch'
# if set, it will re-locate pacmans cache, gnupg and pacman.log into the directory
#PACMANSERVICEDIR=/home/pacman

# if REMOVABLES is defined the installer runs `pacman -Rdd $REMOVABLES` followed
# by a `pacman -U *.pkg.tar.*`
#REMOVABLES=""

# ----------- CONFIG Variables
HOSTNAME=machinename
USERNAME=arch
USERPASS="arch"
USERHOME="/home/${USERNAME}"     # overwrite if desired
GITNAME="Your Fullname"
GITEMAIL="email.address@for.git.commits"
ROOTPASS="PassForRoot"
KEYMAP=us
LOCALELC="en_CA.UTF-8"
LOCALECOLLATE="C.UTF-8"
LOCALEFALLBACK="en_CA:en_GB:en"
TIMEZONE="America/Vancouver"
# pipewire has some trouble on smaller SBCs such as Orange Pi 5
AUDIOSYSTEM="pipewire"   # pipewire | pulseaudio
NETWORKTYPE="wlan"   # wlan | ether | both

# microcode selection
# comment out for no microcode
MICROCODE="intel"    # amd | intel

# this needs intervention; refind and grub work proper
# systemd, xbootldr and efistub need work; see setup-chroot.sh
BOOTMNGR=systemd     # systemd | xbootldr | efistub | refind | grub

# docker container directory - if you choose the docker package and not set
# DOCKERSTORAGEPATH the installer will create ${USERHOME}/docker instead
#DOCKERSTORAGEPATH=/mnt/whatever

AURBUILDDIR="${USERHOME}/pkgs"
AURBASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"

# for installation of a system providing a network router
# (must enable 40_router.sh)
ROUTER_DNS=systemd-resolved            # can be "systemd-resolved" or "openresolv"
ROUTER_DOMAIN=subdomain
ROUTER_IF_EXTERN="wlan0"
ROUTER_IF_INTERN="eno1"
ROUTER_IPv4="192.168.200.1./24"
ROUTER_IPv4_RANGE="192.168.200.10,192.168.200.50,255.255.255.0,1h"
ROUTER_IPv6="fe80::c274:2bff:fefe:8049/64"

# for installation of a pacoloco server
# (must enable 41_pacoloco.sh)
PACOLOCODATADIR=/var/cache/pacoloco
