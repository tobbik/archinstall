Archlinux custom install
========================

A custom installation script for Archlinux

How to use
----------

after running the ISO do the following steps:

 - make sure you have a network connection and reach the interwebs
 - pacman -Sy       # update the package manager database
 - consider editing /etc/pacman.d/mirrorlist to put a fast mirror
   on top, it'll speed up the entire process considerably
 - pacman -S unzip
 - wget https://github.com/tobbik/archinstall/archive/master.zip
 - unzip master.zip
 - cd archinstall-master
 - review partions.txt
 - run install.sh
 - reboot
