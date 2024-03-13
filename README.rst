Archlinux custom install
========================

A custom installation script for Archlinux

How to use
----------

First download the current archlinux iso file from on of the mirrors listed
here:
https://www.archlinux.org/download/.

The file needed is called *archlinux-<YEAR>.<MONTH>.<DATE>_x86_64.iso*.

copoy on USB stick:
``dd bs=4M if=path/to/archlinux-version-x86_64.iso of=/dev/disk/by-id/usb-My_flash_drive conv=fsync oflag=direct status=progress``

After booting the ISO follow these steps:

 - make sure you have a network connection and can reach the interwebs
 - consider editing /etc/pacman.d/mirrorlist to put a fast mirror
   on top; it'll speed up the entire process considerably
 - ``curl https://codeload.github.com/tobbik/archinstall/tar.gz/master --output - | tar xz``
 - cd archinstall-master
 - review partions.sh
 - review config.sh for names, passswords and modules to install
 - run install.sh
 - reboot
