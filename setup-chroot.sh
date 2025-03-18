#!/bin/bash

cd "$(dirname "$0")"
RUNDIR=$(pwd)

source config.sh
source helper.sh

if [ -n "$SETTIMESTAMP" ]; then
  date -s "$SETTIMESTAMP"
fi

mkdir -p /root/installer/logs


for moduleName in ${MODULES[@]}
do
  echo "Executing ${moduleName}"
  cd ${RUNDIR}
  run_module "${moduleName}" "/root/installer/logs"
done

# flatten all permissions
chown -R ${USERNAME}:users /home/${USERNAME}  /root/installer

# boot managers
if [ x"${BOOTMNGR}" == x"grub" ]; then
  grub-install --recheck ${DISKBASEDEVPATH}
  # hack for misnamed devices -> grub bug?
  grub-mkconfig -o /boot/grub/grub.cfg.mkc
  mv /boot/grub/grub.cfg.mkc /boot/grub/grub.cfg
fi

if [ x"${BOOTMNGR}" == x"refind" ]; then
  refind-install
fi

if [ x"${BOOTMNGR}" == x"efistub" ]; then
  # generate unified kernels
  mkinitcpio -p linux

  efibootmgr --create --unicode \
    --disk ${DISKBASEDEVPATH} --part 1 \
    --label 'Arch Linux' \
    --loader '\EFI\Linux\arch-linux.efi'
fi

if [ x"${BOOTMNGR}" == x"xbootldr" ] || [ x"${BOOTMNGR}" == x"systemd" ]; then
  echo "Installing systemd bootloader:"
  if [ x"${BOOTMNGR}" == x"xbootldr" ]; then
    echo '  `bootctl --esp-path=/efi --boot-path=/boot install`'
    bootctl --esp-path=/efi --boot-path=/boot install
  else
    echo '  `bootctl install`'
    bootctl install
  fi
  efibootmgr --create --unicode \
    --disk   ${DISKBASEDEVPATH} --part 1 \
    --label  'Systemd Boot Manager' \
    --loader '\EFI\systemd\systemd-bootx64.efi'
fi

