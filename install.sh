#!/bin/bash

# source partitions.sh
source config.sh

pacstrap /mnt base base-devel
genfstab -p /mnt >> /mnt/etc/fstab

# set the keyboard layout
localectl set-keymap --no-convert ${KEYMAP}
cp /etc/vconsole.conf /mnt/etc/vconsole.conf

# copy over files into chroot
cp -vr ./. /mnt/root/installer/

mkdir -p /mnt/var/lib/iwd
cp -av /var/lib/iwd/*.psk /mnt/var/lib/iwd/

arch-chroot /mnt /root/installer/setup-chroot.sh

# must be done after the arch-chroot installation because this will release
# the bind-mount of /etc/resolv.conf
if [ ! -L /mnt/etc/resolv.conf ]; then
  OLDPWD=$(pwd)
  cd /mnt/etc
  rm ./resolv.conf
  ln -s /run/systemd/resolve/resolv.conf ./resolv.conf
  cd ${OLDPWD}
fi
