#!/bin/bash

cd "$(dirname "$0")"
RUNDIR=$(pwd)

source config.sh

if [ -n "$SETTIMESTAMP" ]; then
  date -s "$SETTIMESTAMP"
fi

for moduleName in ${MODULES[@]}; do
  echo "Executing ${moduleName}"
  cd ${RUNDIR}
  source "${moduleName}" 2>&1 | tee "/root/installer/logs/${moduleName}.log"
done

# flatten all permissions
chown -R ${USERNAME}:users /home/${USERNAME}

# boot managers
if [ x"${BOOTMNGR}" == x"grub" ]; then
  grub-install --recheck /dev/sda
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
    --disk /dev/sda --part 1 \
    --label "Arch Linux" --loader '\EFI\Arch\arch-linux.efi'
fi


if [ x"${BOOTMNGR}" == x"systemd" ]; then
  bootctl install
fi


if [ x"${BOOTMNGR}" == x"xbootldr" ]; then
  echo 'Installing bootloader for XBOOTLDR: `bootctl --esp-path=/efi --boot-path=/boot install`'
  bootctl --esp-path=/efi --boot-path=/boot install
fi
