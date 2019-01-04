#!/bin/bash

#source partitions.sh
source config.sh

pacstrap /mnt base base-devel
genfstab -p /mnt >> /mnt/etc/fstab

# set the keyboard layout
localectl set-keymap --no-convert ${KEYBOARD}
cp /etc/vconsole.conf /mnt/etc/vconsole.conf

# copying over the netctl profile created by wifi-menu
mkdir -p /mnt/etc/netctl
cp /etc/netctl/${INTERFACE}* /mnt/etc/netctl/

# copy over files into chroot
mkdir /mnt/root/installer
cp -vr ./. /mnt/root/installer/

arch-chroot /mnt /root/installer/setup-chroot.sh

