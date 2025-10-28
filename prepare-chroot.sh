#!/bin/bash

#source partitions.sh
#source format.sh
#source mount.sh

timedatectl set-ntp true
source config.sh

if [[ ! -z ${PACOLOCOCACHESERVER} ]]; then
  sed -E "/(options)/! s|^\[.*\]$|\0\nCacheServer = ${PACOLOCOCACHESERVER}|" \
      -i /etc/pacman.conf
fi

case "$(uname -m)" in
  "aarch64") EXTRAPACKAGES="archlinuxarm-keyring" ;;
  "x86_64")  EXTRAPACKAGES="archlinux-keyring vbetool" ;;
esac

pacstrap /mnt base base-devel mkinitcpio ${EXTRAPACKAGES}
genfstab -t PARTUUID -p /mnt >> /mnt/etc/fstab

# set the keyboard layout
localectl set-keymap --no-convert ${KEYMAP}
cp /etc/vconsole.conf /mnt/etc/vconsole.conf

# copy over files into chroot
cp -vr ./. /mnt/root/installer/
mkdir -p   /mnt/root/installer/logs

mkdir -p /mnt/var/lib/iwd
cp -av /var/lib/iwd/*.psk /mnt/var/lib/iwd/

arch-chroot /mnt /root/installer/archinstall.sh

if [ -f /mnt/root/installer/nspawn.sh ]; then
  systemd-nspawn --bind ${DISKBOOTDEVPATH} \
                 --bind ${DISKROOTDEVPATH} \
                 --bind ${DISKHOMEDEVPATH} \
                 --pipe --directory /mnt /bin/bash -x << EOFSPAWN
cd /root/installer
source helper.sh
run_module nspawn.sh
EOFSPAWN
fi

# must be done after the arch-chroot installation because this will release
# the bind-mount of /etc/resolv.conf
if [ ! -L /mnt/etc/resolv.conf ]; then
  OLDPWD=$(pwd)
  rm /mnt/etc/resolv.conf
  cd /mnt
  ln -s ../run/systemd/resolve/resolv.conf /mnt/etc/resolv.conf
  cd ${OLDPWD}
fi

cp -avr /mnt/root/installer /mnt/${USERHOME}/
chown -R ${USERNAME}:users  /mnt/${USERHOME}/installer

