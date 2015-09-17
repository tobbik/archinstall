Archlinux custom install
========================

A custom installation script for Archlinux

How to use
----------

after running the ISO do the following steps:

 - make sure you have a network
 - pacman -S git
 - git clone https://github.com/tobbik/archinstall
 - cd archinstall
 - bash archlinux__setup.sh
 - arch-chroot /mnt /bin/bash
 - cd /root/installer
 - bash archlinux_install.sh
