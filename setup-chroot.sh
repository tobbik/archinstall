#!/bin/bash

cd "$(dirname "$0")"
RUNDIR=$(pwd)

source config.sh

if [ -n "$SETTIMESTAMP" ]; then
  date -s "$SETTIMESTAMP"
fi

mkdir -p /root/installer/logs
chown -R ${USERNAME}:users /root/installer

for moduleName in ${MODULES[@]}; do
  echo "Executing ${moduleName}"
  cd ${RUNDIR}
  START_SECS=${SECONDS}
  source "${moduleName}" 2>&1 | tee "/root/installer/logs/${moduleName}.log"
  ELAPSED_SECS=$((${SECONDS} - ${START_SECS}))
  TIME_PASSED=$(date -u -d @"${ELAPSED_SECS}" +'%-Mm %Ss')
  echo -e "\n\n\nLatest diskusage after installing module:\n\t\t$(df -h | grep ${DISKBASEDEVPATH})"
  echo "${moduleName}         ${TIME_PASSED}" >> "/root/installer/logs/progress.log"
  df -h | grep ${DISKROOTDEVPATH} >> "/root/installer/logs/progress.log"
  df -h | grep ${DISKBOOTDEVPATH} >> "/root/installer/logs/progress.log"
done

# flatten all permissions
chown -R ${USERNAME}:users /home/${USERNAME}

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

