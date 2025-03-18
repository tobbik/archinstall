source config.sh

UUIDROOT=$(blkid -s UUID -o value ${DISKROOTDEVPATH})
BOOTPATH="/boot"
ESPPATH="/efi"

# ------- BOOTLDRX or gummiboot (systemd-boot based)
if [ x"${BOOTMNGR}" == x"xbootldr" ] || [ x"${BOOTMNGR}" == x"systemd" ]; then
# for xbootldr to work:
# loader.conf MUST be on the ESP (the same where the /EFI/systemd/systemd-bootx64.efi lives)
# loader/entries/*.conf MUST live on the XBOOTLDR partition
  if [ x"${BOOTMNGR}" == x"systemd" ]; then
    BOOTPATH="/boot"
    ESPPATH=${BOOTPATH}
  fi

  mkdir -p ${ESPPATH}/loader ${BOOTPATH}/loader/entries
  cat > ${ESPPATH}/loader/loader.conf << EOUBOOTLOAD
default       arch
timeout       8
console-mode  max
editor        no
EOUBOOTLOAD

  cat > ${BOOTPATH}/loader/entries/arch.conf << EOARCHCONF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /${MICROCODE}-ucode.img
initrd  /initramfs-linux.img
options root=UUID=${UUIDROOT} ro
EOARCHCONF

  cat > ${BOOTPATH}/loader/entries/arch-fallback.conf << EOARCHFBCONF
title   Arch Linux (fallback initramfs)
linux   /vmlinuz-linux
initrd  /${MICROCODE}-ucode.img
initrd  /initramfs-linux-fallback.img
options root=UUID=${UUIDROOT} single ro
EOARCHFBCONF

fi
#----------------------------------------------------------------

# ------------------------------------------------ grub
if [ x"${BOOTMNGR}" == x"grub" ]; then
  pacman -S ${PACMANFLAGS} \
    grub
fi

# ------------------------------------------------ refind
if [ x"${BOOTMNGR}" == x"refind" ]; then
  pacman -S ${PACMANFLAGS} \
    refind
fi

# ------------------------------------------------ efistub
if [ x"${BOOTMNGR}" == x"efistub" ]; then
  if [ ! -f /root/installer/logs/linux.preset.bak ]; then
    # backup the linux.preset for mkinitcpio
    cp /etc/mkinitcpio.d/linux.preset /root/installer/logs/linux.preset.bak
  fi

  EFI_PATH=${BOOTPATH}/EFI/Linux
  mkdir -p ${EFI_PATH}
  echo -e "ro root=UUID=${UUIDROOT}"        > /etc/kernel/cmdline
  echo -e "ro root=UUID=${UUIDROOT} single" > /etc/kernel/fallback_cmdline

  sed \
    -e "s:.*\(default_image=.*\):#\1:" \
    -e "s:.*\(default_uki\).*:\1=\"${EFI_PATH}/arch-linux.efi\":" \
    -e "s:.*\(default_options\).*:\1=\"--cmdline /etc/kernel/cmdline\":" \
    -e "s:.*\(fallback_image=.*\):#\1:" \
    -e "s:.*\(fallback_uki\).*:\1=\"${EFI_PATH}/arch-linux-fallback.efi\":" \
    -e "s:.*\(fallback_options\).*:\1=\"-S autodetect --cmdline /etc/kernel/fallback_cmdline\":" \
    -i /etc/mkinitcpio.d/linux.preset

  # UGLY-HACK remove and re-install linux kernel to have it pickup the vmlinuz location
  pacman -Rdd --noconfirm linux
  pacman -S   --noconfirm linux
fi
