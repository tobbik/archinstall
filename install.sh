#!/bin/bash

source partitions.sh
source config.sh

pacstrap /mnt base base-devel
genfstab -p /mnt >> /mnt/etc/fstab

# set the keyboard layout
localectl set-keymap --no-convert ${KEYBOARD}
cp /etc/vconsole.conf /mnt/etc/vconsole.conf

# copy over files into chroot
mkdir -p /mnt/root/installer/logs
cp -vr ./. /mnt/root/installer/

mkdir -p /mnt/var/lib/iwd
cp -av /var/lib/iwd/*.psk /mnt/var/lib/iwd/

arch-chroot /mnt /root/installer/setup-chroot.sh

