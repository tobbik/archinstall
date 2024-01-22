#!/bin/bash

cd "$(dirname "$0")"
RUNDIR=$(pwd)

source config.sh

for moduleName in ${MODULES[@]}; do
  echo "Executing ${moduleName}"
  cd ${RUNDIR}
  source "${moduleName}" 2>&1 | tee "/root/installer/logs/${moduleName}.log"
done

# flatten all permissions
chown -R ${USERNAME}:users /home/${USERNAME}

if [ "${BOOTMNGR}" == "grub" ]; then
  pacman -S --needed --noconfirm grub
  grub-install --recheck /dev/sda
  # hack for misnamed devices -> grub bug?
  grub-mkconfig -o /boot/grub/grub.cfg.mkc
  mv /boot/grub/grub.cfg.mkc /boot/grub/grub.cfg
fi

if [ "${BOOTMNGR}" == "refind" ]; then
  pacman -S --needed --noconfirm refind
  refind-install
fi


if [ "${BOOTMNGR}" == "efistub" ]; then
  pacman -S --needed --noconfirm efibootmgr
  UUIDROOT=$(blkid -s UUID -o value /dev/sda2)
  ESPPATH=/efi/EFI/Arch
  echo -e "ro root=UUID=${UUIDROOT}" > /etc/kernel/cmdline
  echo -e "ro root=UUID=${UUIDROOT} single" > /etc/kernel/fallback_cmdline
  mkdir -p ${ESPPATH}

  cat > /etc/mkinitcpio.d/linux.preset << EOLPRESET
# mkinitcpio preset file for the 'linux' package

#ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux"
ALL_microcode=(/boot/*-ucode.img)

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
#default_image="/boot/initramfs-linux.img"
default_uki="${ESPPATH}/arch-linux.efi"
default_options="--splash=/usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
#fallback_image="/boot/initramfs-linux-fallback.img"
fallback_uki="${ESPPATH}/arch-linux-fallback.efi"
fallback_options="-S autodetect --cmdline /etc/kernel/fallback_cmdline"
EOLPRESET

  # generate unified kernels
  mkinitcpio -p linux

  efibootmgr --create --unicode \
    --disk /dev/sda --part 1 \
    --label "Arch Linux" --loader '\EFI\Arch\arch-linux.efi'

fi


if [ "${BOOTMNGR}" == "systemd" ]; then
  UUIDROOT=$(blkid -s UUID -o value /dev/sda2)
  ESPPATH=/efi/EFI/Arch
  mkdir -p /efi/loader/entries ${ESPPATH}

  cat > /efi/loader/loader.conf << EOUBOOTLOAD
default       arch
timeout       8
console-mode  max
editor        no
EOUBOOTLOAD

cat > /efi/loader/entries/arch.conf << EOARCHCONF
title   Arch Linux
linux   ${ESPPATH}/vmlinuz-linux
initrd  ${ESPPATH}/intel-ucode.img
initrd  ${ESPPATH}/initramfs-linux.img
options root=UUID=${UUIDROOT} ro
EOARCHCONF

cat > /efi/loader/entries/arch-fallback.conf << EOARCHFBCONF
title   Arch Linux (fallback initramfs)
linux   ${ESPPATH}/vmlinuz-linux
initrd  ${ESPPATH}/intel-ucode.img
initrd  ${ESPPATH}/initramfs-linux-fallback.img
options root=UUID=${UUIDROOT} single ro
EOARCHFBCONF

fi
