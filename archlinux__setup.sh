#!/bin/bash

KEYBOARD=us

mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

mount /dev/sda1 /mnt
mkdir /mnt/home
mount /dev/sda2 /mnt/home

pacstrap /mnt base base-devel
genfstab -p /mnt >> /mnt/etc/fstab

# set the keyboard layout
localectl set-keymap --no-convert ${KEYBOARD}
cp /etc/vconsole.conf /mnt/etc/vconsole.conf

# copy over files into chroot
mkdir /mnt/root/installer
cp -avr ./* ./.* /mnt/root/installer
