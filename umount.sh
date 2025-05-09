source config.sh

swapoff "${DISKSWAPDEVPATH}"
umount   /mnt/home
mount    /mnt/boot
rmdir    /mnt/{boot,home}
if [ x"${BOOTMNGR}" == x"xbootldr" ]; then
  umount  /mnt/efi
  rmdir   /mnt/efi
fi

umount /mnt
