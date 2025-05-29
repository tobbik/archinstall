Archlinux custom install
========================

A custom installation script for Archlinux

How to use
----------

First download the current archlinux iso file from on of the mirrors listed
here:
https://www.archlinux.org/download/

The file needed is called *archlinux-<YEAR>.<MONTH>.<DATE>_x86_64.iso*.

copy on USB stick:
``dd bs=4M if=path/to/archlinux-version-x86_64.iso of=/dev/disk/by-id/usb-My_flash_drive conv=fsync oflag=direct status=progress``

After booting the ISO follow these steps:

 - make sure you have a network connection and can reach the interwebs
 - ``curl https://codeload.github.com/tobbik/archinstall/tar.gz/master --output - | tar xz``
 - cd archinstall-master
 - review partions.sh, then execute it. It should create partitions and mount a full system into /mnt
 - review config.sh for names, passswords and modules to install
 - run prepare-chroot.sh
 - reboot

Running from another computer
-----------------------------

If you like to run this from another computer, follow these steps:

 - once booted, the computer should be available as ``archiso`` on the
   local network
 - in order to ssh into the ``archiso`` image you need to set a password on
   the machine first: run ``passwd``
 - if you plan to login from a non standard terminal, `BEFORE` you login
   into the ``archiso`` machine run:
   ``infocmp -x | ssh root@archiso -- tic -x -`` from your non standard
   terminal.  This copies over the terminfo files.
