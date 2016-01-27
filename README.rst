Archlinux custom install
========================

A custom installation script for Archlinux

How to use
----------

First download the current archlinux iso file from on of the mirrors listed
here:
https://www.archlinux.org/download/
The file needed is called *archlinux-<YEAR>.<MONTH>.<DATE>-dual.iso*.

After booting the ISO follow these steps:

 - make sure you have a network connection and can reach the interwebs
 - consider editing /etc/pacman.d/mirrorlist to put a fast mirror
   on top; it'll speed up the entire process considerably
 - ``wget https://github.com/tobbik/archinstall/tarball/master -O - | tar xz --strip-components 1``
 - cd installer
 - review partions.sh
 - review the config section in setup-chroot.sh for passwords etc.
 - run install.sh
 - reboot
