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
  case "$(uname -m)" in
      'aarch64') _kernelname='vmlinux'
                 _efifile='systemd-bootaa64.efi' ;;
      *)         _kernelname='vmlinuz-linux'
                 _efifile='systemd-bootx64.efi'  ;;
  esac

  mkdir -p ${ESPPATH}/loader ${BOOTPATH}/loader/entries
  cat > ${ESPPATH}/loader/loader.conf << EOUBOOTLOAD
default       arch
timeout       8
console-mode  max
editor        no
EOUBOOTLOAD

  cat > ${BOOTPATH}/loader/entries/arch.conf << EOARCHCONF
title   Arch Linux
linux   /${_kernelname}
initrd  /${MICROCODE}-ucode.img
initrd  /initramfs-linux.img
options root=UUID=${UUIDROOT} ro ${KERNELBOOTPARAMS}
EOARCHCONF

  cat > ${BOOTPATH}/loader/entries/arch-fallback.conf << EOARCHFBCONF
title   Arch Linux (fallback initramfs)
linux   /${_kernelname}
initrd  /${MICROCODE}-ucode.img
initrd  /initramfs-linux-fallback.img
options root=UUID=${UUIDROOT} single ro ${KERNELBOOTPARAMS}
EOARCHFBCONF

  if [[ -z ${MICROCODE} ]]; then
    sed -i ${BOOTPATH}/loader/entries/arch.conf -e "/ucode/d"
    sed -i ${BOOTPATH}/loader/entries/arch-fallback.conf -e "/ucode/d"
  fi

  echo "Installing systemd/xbootldr bootloader:"
  if [ x"${BOOTMNGR}" == x"xbootldr" ]; then
    echo '  `bootctl --esp-path=/efi --boot-path=/boot install`'
    bootctl --esp-path=/efi --boot-path=/boot install
  else
    echo '  `bootctl install`'
    bootctl install
  fi
  efibootmgr --create --unicode \
    --disk   ${DISKBASEDEVPATH} --part 1 \
    --label  'Das Gummiboot' \
    --loader '\EFI\systemd\'${_efifile}

fi
#----------------------------------------------------------------

# ------------------------------------------------ grub
if [ x"${BOOTMNGR}" == x"grub" ]; then
  pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
    grub
  echo "Installing grub bootloader:"
  grub-install --recheck ${DISKBASEDEVPATH}
  # hack for misnamed devices -> grub bug?
  grub-mkconfig -o /boot/grub/grub.cfg.mkc
  mv /boot/grub/grub.cfg.mkc /boot/grub/grub.cfg
fi

# ------------------------------------------------ refind
if [ x"${BOOTMNGR}" == x"refind" ]; then
  pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
    refind
  echo "Installing refind bootloader:"
  refind-install
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

  # generate unified kernels
  mkinitcpio -p linux

  echo "Setting up efistub bootloader in firmware:"
  efibootmgr --create --unicode \
    --disk ${DISKBASEDEVPATH} --part 1 \
    --label 'Arch Linux EFIstub' \
    --loader '\EFI\Linux\arch-linux.efi'
fi
