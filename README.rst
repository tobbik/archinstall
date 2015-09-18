Archlinux custom install
========================

A custom installation script for Archlinux

How to use
----------

after running the ISO do the following steps:

 - make sure you have a network connection and reach the interwebs
 - pacman -S unzip
 - wget https://github.com/tobbik/archinstall/archive/master.zip
 - unzip master.zip
 - cd archinstall-master
 - cfdisk /dev/sda # make two partitions for / and /home
 - ./archlinux__setup.sh
 - arch-chroot /mnt /bin/bash
 - cd /root/installer
 - bash archlinux_install.sh
 - reboot
