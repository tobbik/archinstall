#!/bin/bash

mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

mount /dev/sda1 /mnt
mkdir /mnt/home
mount /dev/sda2 /mnt/home

pacstrap /mnt base base-devel
genfstab -p /mnt >> /mnt/etc/fstab

# copy over files into chroot
mkdir /mnt/root/installer
cp -avp installer/* /mnt/root/installer
