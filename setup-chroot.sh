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
  grub-install --recheck /dev/sda
  # hack for misnamed devices -> grub bug?
  grub-mkconfig -o /boot/grub/grub.cfg.mkc
  mv /boot/grub/grub.cfg.mkc /boot/grub/grub.cfg
fi

if [ "${BOOTMNGR}" == "refind" ]; then
  refind-install
fi


if [ "${BOOTMNGR}" == "efistub" ]; then
  UUIDROOT=$(blkid -s UUID -o value /dev/sda2)
  echo -e "ro root=UUID=${UUIDROOT}" > /etc/kernel/cmdline
  echo -e "ro root=UUID=${UUIDROOT} single" > /etc/kernel/fallback_cmdline
  mkdir -p /efi/EFI/Linux

  cat > /etc/mkinitcpio.d/linux.preset << EOLPRESET
# mkinitcpio preset file for the 'linux' package

#ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux"
ALL_microcode=(/boot/*-ucode.img)

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
#default_image="/boot/initramfs-linux.img"
default_uki="/efi/EFI/Linux/arch-linux.efi"
default_options="--splash=/usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
#fallback_image="/boot/initramfs-linux-fallback.img"
fallback_uki="esp/EFI/Linux/arch-linux-fallback.efi"
fallback_options="-S autodetect --cmdline /etc/kernel/fallback_cmdline"
EOLPRESET

  mkinitcpio -p linux

  efibootmgr --create --disk /dev/sda --part 1 --label "Arch Linux" --loader '\EFI\Linux\arch-linux.efi' --unicode

fi
