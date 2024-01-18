#!/bin/bash

source partitions.sh
source config.sh

pacstrap /mnt base base-devel
genfstab -p /mnt >> /mnt/etc/fstab

# set the keyboard layout
localectl set-keymap --no-convert ${KEYBOARD}
cp /etc/vconsole.conf /mnt/etc/vconsole.conf

# copy over files into chroot
mkdir /mnt/root/installer
cp -vr ./. /mnt/root/installer/
mkdir /mnt/root/installer/logs

arch-chroot /mnt /root/installer/setup-chroot.sh

