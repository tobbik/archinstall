#!/bin/bash

cd "$(dirname "$0")"
RUNDIR=$(pwd)

source config.sh
source helper.sh

if [ -n "$SETTIMESTAMP" ]; then
  date -s "$SETTIMESTAMP"
fi

mkdir -p /root/installer/logs

# these re-locations are useful, if you like to set-up an RO-mounted root (/) directory
if [[ ! -z ${SYSTEMDSERVICEDIR} ]]; then
  mkdir -p $(dirname ${SYSTEMDSERVICEDIR})
  mv       /var/lib/systemd ${SYSTEMDSERVICEDIR}
  ln    -s ${SYSTEMDSERVICEDIR} /var/lib/systemd
fi

if [[ ! -z ${PACMANSERVICEDIR} ]]; then
  mkdir -p ${PACMANSERVICEDIR}/cache
  mv /var/log/pacman.log ${PACMANSERVICEDIR}/
  mv /etc/pacman.d/gnupg ${PACMANSERVICEDIR}/
  sed -i /etc/pacman.conf \
      -e "s:^#\(CacheDir *\).*:\1 = ${PACMANSERVICEDIR}/cache:" \
      -e "s:^#\(LogFile *\).*:\1 = ${PACMANSERVICEDIR}/pacman.log:" \
      -e "s:^#\(GPGDir *\).*:\1 = ${PACMANSERVICEDIR}/gnupg:"
fi

# installing the
for moduleName in ${MODULES[@]}
do
  echo -e "\n\n      >>>>>>>>>>>   EXECUTING ${moduleName} <<<<<<<<<<<<\n"
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

